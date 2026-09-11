<#
.SYNOPSIS
    Shared helpers for the CentralAccessDB database DevOps scripts.
    Dot-source this file from the other scripts:  . "$PSScriptRoot\_Common.ps1"
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Absolute path to the repository root (parent of the scripts/ folder).
function Get-RepoRoot {
    return (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}

# Absolute path to the SQL project folder.
function Get-ProjectDir {
    return (Join-Path (Get-RepoRoot) 'src\CentralAccessDB')
}

# Absolute path to the .sqlproj file.
function Get-ProjectFile {
    return (Join-Path (Get-ProjectDir) 'CentralAccessDB.sqlproj')
}

# Locate the sqlpackage executable (PATH first, then the dotnet global-tools shim).
function Get-SqlPackagePath {
    $cmd = Get-Command sqlpackage -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $shim = Join-Path $HOME '.dotnet\tools\sqlpackage.exe'
    if (Test-Path $shim) { return $shim }
    throw "sqlpackage not found. Install it with:  dotnet tool install --global microsoft.sqlpackage"
}

# Convert a SecureString to plain text (needed to hand a password to sqlpackage).
function ConvertFrom-SecureStringPlain {
    param([Parameter(Mandatory)][securestring]$Secure)
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Secure)
    try { return [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
}

# Resolve a DB password from (in order): explicit value, named env var, interactive prompt.
# NEVER hard-code passwords in these scripts or in source control.
function Resolve-DbPassword {
    param(
        [string]$Password,
        [string]$EnvVar,
        [string]$PromptLabel = 'Database password'
    )
    if ($Password) { return $Password }
    if ($EnvVar -and (Test-Path "env:$EnvVar")) { return (Get-Item "env:$EnvVar").Value }
    $secure = Read-Host -AsSecureString -Prompt $PromptLabel
    return (ConvertFrom-SecureStringPlain -Secure $secure)
}

# Build an ADO.NET / SqlPackage connection string. SQL auth when -User is given,
# otherwise Windows integrated auth. The password is double-quoted so values with
# most special characters are handled correctly.
function New-DbConnectionString {
    param(
        [Parameter(Mandatory)][string]$Server,
        [Parameter(Mandatory)][string]$Database,
        [string]$User,
        [string]$Password,
        [bool]$Encrypt = $true,
        [bool]$TrustServerCertificate = $true
    )
    $parts = @("Server=$Server", "Database=$Database")
    if ($User) {
        $parts += "User ID=$User"
        $parts += 'Password="' + $Password + '"'
    } else {
        $parts += 'Integrated Security=true'
    }
    $parts += 'Encrypt=' + ($Encrypt.ToString().ToLower())
    $parts += 'TrustServerCertificate=' + ($TrustServerCertificate.ToString().ToLower())
    return (($parts -join ';') + ';')
}

# Run sqlpackage with an argument array and throw on non-zero exit.
function Invoke-SqlPackage {
    param([Parameter(Mandatory)][string[]]$Arguments)
    $exe = Get-SqlPackagePath
    Write-Host "  > sqlpackage $($Arguments -replace '(Password=)\"[^\"]*\"', '$1"***"' -replace '(/.*Password:).*', '$1***')" -ForegroundColor DarkGray
    & $exe @Arguments
    if ($LASTEXITCODE -ne 0) { throw "sqlpackage exited with code $LASTEXITCODE" }
}

# Keep the console window open until a key is pressed, so output/errors can be read.
# Automatically skips when it would be pointless or harmful: in CI, in a non-interactive
# session, or when input is redirected (nested script call, piped, or agent/tool runs).
# True only when we can actually read keyboard input (not CI, not redirected/piped).
function Test-Interactive {
    if ($env:CI) { return $false }
    if (-not [Environment]::UserInteractive) { return $false }
    try { if ([Console]::IsInputRedirected) { return $false } } catch { }
    return $true
}

function Wait-ForKeyIfInteractive {
    if (-not (Test-Interactive)) { return }
    Write-Host ''
    Write-Host 'Press any key to close...' -ForegroundColor Cyan
    try {
        $null = [System.Console]::ReadKey($true)
    } catch {
        # Fallback for hosts without a raw console.
        try { $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') }
        catch { try { Read-Host 'Press Enter to close' | Out-Null } catch { } }
    }
}

# ---------------------------------------------------------------------------
# Resource use: the heavy steps (dotnet build, SqlPackage) can spike CPU/RAM. Run them at
# BelowNormal priority so the machine stays responsive - the dotnet/sqlpackage child
# processes inherit the priority class from this process. Opt out with $env:CADB_PRIORITY='Normal'.
# ---------------------------------------------------------------------------
function Set-LowProcessPriority {
    if ($env:CADB_PRIORITY -eq 'Normal') { return }
    try {
        [System.Diagnostics.Process]::GetCurrentProcess().PriorityClass =
            [System.Diagnostics.ProcessPriorityClass]::BelowNormal
        Write-Host 'Priority: BelowNormal (keeps the machine responsive; set CADB_PRIORITY=Normal to disable).' -ForegroundColor DarkGray
    } catch {
        Write-Host "WARN: could not lower process priority: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# Shut down resident MSBuild build-server processes so they stop holding RAM after a build.
# (dotnet keeps these alive for ~15 min by default to speed up re-builds; on a shared/low-RAM
# server they accumulate. Combined with MSBUILDDISABLENODEREUSE=1 this keeps the footprint down.)
function Stop-BuildServers {
    try { & dotnet build-server shutdown 2>&1 | Out-Null } catch { }
}

# ---------------------------------------------------------------------------
# Logging: capture everything a script prints (output + errors) to a .txt log.
# ---------------------------------------------------------------------------
$global:__CADB_LogPath = $null

function Start-ScriptLog {
    param([Parameter(Mandatory)][string]$Name)
    try {
        $logDir = Join-Path (Get-RepoRoot) 'logs'
        New-Item -ItemType Directory -Force -Path $logDir | Out-Null
        $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
        $global:__CADB_LogPath = Join-Path $logDir "${Name}_${stamp}.txt"
        Start-Transcript -Path $global:__CADB_LogPath -Force | Out-Null
        Write-Host "Logging to: $global:__CADB_LogPath" -ForegroundColor DarkGray
    } catch {
        Write-Host "WARN: could not start log file: $($_.Exception.Message)" -ForegroundColor Yellow
        $global:__CADB_LogPath = $null
    }
}

function Stop-ScriptLog {
    $path = $global:__CADB_LogPath
    if ($path) {
        try { Stop-Transcript | Out-Null } catch { }
        $global:__CADB_LogPath = $null
        Write-Host "Log saved: $path" -ForegroundColor DarkGray
    }
}

# Print a final SUCCESS/FAILED banner (also captured in the log).
function Write-ScriptStatus {
    param([bool]$Failed)
    Write-Host ''
    if ($Failed) { Write-Host 'STATUS: FAILED' -ForegroundColor Red }
    else         { Write-Host 'STATUS: SUCCESS' -ForegroundColor Green }
}

# Read a SqlPackage DeployReport XML and print a grouped summary of the changes.
function Show-ChangeSummary {
    param([string]$ReportPath)
    Write-Host ''
    Write-Host '==================== CHANGE SUMMARY ====================' -ForegroundColor Cyan
    if (-not $ReportPath -or -not (Test-Path $ReportPath)) {
        Write-Host 'No change report available.' -ForegroundColor Yellow
        Write-Host '========================================================' -ForegroundColor Cyan
        return
    }
    try { [xml]$xml = Get-Content -Raw -LiteralPath $ReportPath }
    catch { Write-Host "Could not parse change report: $($_.Exception.Message)" -ForegroundColor Yellow; return }

    # Namespace-agnostic, strict-mode-safe node access via XPath local-name().
    $opNodes = @($xml.SelectNodes('//*[local-name()="Operation"]'))
    if ($opNodes.Count -eq 0) {
        Write-Host 'No schema differences - the target already matches the project.' -ForegroundColor Green
        Write-Host '========================================================' -ForegroundColor Cyan
        return
    }

    $grand = 0
    foreach ($op in $opNodes) {
        $name  = $op.GetAttribute('Name')
        $items = @($op.SelectNodes('*[local-name()="Item"]'))
        $grand += $items.Count
        $color = switch ($name) { 'Create' { 'Green' } 'Alter' { 'Yellow' } 'Drop' { 'Red' } default { 'Gray' } }
        Write-Host ("{0,-8} : {1} object(s)" -f $name, $items.Count) -ForegroundColor $color
        $items | Group-Object { $_.GetAttribute('Type') } | Sort-Object Name | ForEach-Object {
            $t = ($_.Name -replace '^Sql', '')
            Write-Host ("           - {0,-22} {1}" -f $t, $_.Count) -ForegroundColor DarkGray
        }
    }
    Write-Host ("TOTAL    : {0} change(s)" -f $grand) -ForegroundColor White

    $alertNodes = @($xml.SelectNodes('//*[local-name()="Alert"]'))
    if ($alertNodes.Count -gt 0) {
        Write-Host 'ALERTS (review before applying):' -ForegroundColor Red
        foreach ($a in $alertNodes) {
            $an = $a.GetAttribute('Name'); if (-not $an) { $an = $a.LocalName }
            Write-Host ("   ! {0}" -f $an) -ForegroundColor Red
            foreach ($i in @($a.SelectNodes('*'))) {
                $iv = $i.GetAttribute('Value'); if (-not $iv) { $iv = $i.InnerText }
                if ($iv) { Write-Host ("       {0}" -f $iv) -ForegroundColor Red }
            }
        }
    }
    Write-Host '========================================================' -ForegroundColor Cyan
}

# Guide note printed by scripts that reach out to the SQL Server over the network.
function Write-DbAccessNote {
    param([string]$Server)
    $where = if ($Server) { "the DB server ($Server)" } else { 'the DB server' }
    Write-Host '---------------------------------------------------------------' -ForegroundColor DarkYellow
    Write-Host "NOTE: You must be on the SAME NETWORK as $where to connect." -ForegroundColor Yellow
    Write-Host '      Make sure your VPN / office LAN can reach the SQL Server' -ForegroundColor Yellow
    Write-Host '      host and its port (default TCP 1433). If you get a' -ForegroundColor Yellow
    Write-Host '      connection/timeout error, this is almost always why.' -ForegroundColor Yellow
    Write-Host '---------------------------------------------------------------' -ForegroundColor DarkYellow
}
