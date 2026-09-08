<#
.SYNOPSIS
    Check (and optionally download + install) every tool the CentralAccessDB scripts need.

.DESCRIPTION
    Run this FIRST on a new machine. It verifies the running machine has everything the
    numbered scripts (1_extract / 2_build / 3_compare / 4_deploy) depend on and, for any
    missing tool, downloads and installs it - showing every step in colour with a clear
    per-tool status (OK / MISSING / INSTALLING / INSTALLED / FAILED) and a final summary.

    Tools checked:
      * .NET SDK   (required) - 'dotnet build' produces the .dacpac and hosts SqlPackage.
      * SqlPackage (required) - extract / compare / deploy (generate + apply migrations).
      * sqlcmd     (optional) - ad-hoc T-SQL from the command line.
      * Git        (optional) - review schema diffs before committing.

    Installs use the common Windows method (winget) where possible, falling back to the
    official Microsoft install scripts. .NET machine-wide installs may prompt for elevation
    (UAC) - run this script "as Administrator" for the smoothest experience. Installing the
    .NET SDK and 'dotnet tool install' both need internet access (NuGet / Microsoft CDN).

.PARAMETER CheckOnly
    Only report what is present/missing - never download or install anything.

.PARAMETER IncludeOptional
    Also install the OPTIONAL tools (sqlcmd, Git) when they are missing. By default only the
    REQUIRED tools are installed; optional ones are just reported.

.PARAMETER Force
    Install missing tools without asking for confirmation (for automation / CI). In a
    non-interactive session confirmation can't be shown, so -Force is required to install there.

.PARAMETER NoPause
    Do not pause for a key press at the end. Set automatically for CI / redirected input.

.PARAMETER NoLog
    Do not write a transcript log file under logs\.

.EXAMPLE
    .\scripts\0_check_prerequisites.ps1
        Check everything and install any missing REQUIRED tool (asks Y/n before each install).

.EXAMPLE
    .\scripts\0_check_prerequisites.ps1 -CheckOnly
        Just report - install nothing.

.EXAMPLE
    .\scripts\0_check_prerequisites.ps1 -IncludeOptional -Force
        Install every missing tool (required + optional) without prompting.
#>
[CmdletBinding()]
param(
    [switch]$CheckOnly,
    [switch]$IncludeOptional,
    [switch]$Force,
    [switch]$NoPause,
    [switch]$NoLog
)

. "$PSScriptRoot\_Common.ps1"
if (-not $NoLog) { Start-ScriptLog -Name '0_check_prerequisites' }

# ---------------------------------------------------------------------------
# Local helpers (prerequisite-specific; shared style comes from _Common.ps1).
# ---------------------------------------------------------------------------

# True if the current process is elevated (Administrator).
function Test-IsAdmin {
    try {
        $id = [Security.Principal.WindowsIdentity]::GetCurrent()
        $pr = New-Object Security.Principal.WindowsPrincipal($id)
        return $pr.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    } catch { return $false }
}

# True if winget (the Windows App Installer) is available.
function Test-WinGet { return [bool](Get-Command winget -ErrorAction SilentlyContinue) }

# Re-read PATH from the registry (+ known tool dirs) so tools installed during THIS run are
# visible without opening a new terminal.
function Update-SessionPath {
    $paths = @(
        [Environment]::GetEnvironmentVariable('Path', 'Machine'),
        [Environment]::GetEnvironmentVariable('Path', 'User'),
        (Join-Path $HOME '.dotnet\tools'),                       # dotnet global tools (sqlpackage)
        (Join-Path $env:LOCALAPPDATA 'Microsoft\dotnet')         # user-local .NET (install-script fallback)
    ) | Where-Object { $_ }
    $env:Path = ($paths -join ';')
}

# ---- version probes: return a version/description string, or $null when absent ----

function Get-DotNetSdkVersion {
    $cmd = Get-Command dotnet -ErrorAction SilentlyContinue
    if (-not $cmd) { return $null }
    try {
        $sdks = @(& $cmd.Source --list-sdks 2>$null)
        if ($sdks.Count -gt 0) {
            $latest = ($sdks[-1] -replace '\s*\[.*$', '').Trim()
            return ("{0} SDK(s) - latest {1}" -f $sdks.Count, $latest)
        }
    } catch { }
    return $null   # dotnet present but only a runtime (no SDK) - can't build
}

function Get-SqlPackageVersion {
    try { $exe = Get-SqlPackagePath } catch { return $null }   # _Common: throws when not found
    try {
        $v = (& $exe /version 2>$null | Select-Object -First 1)
        if ($v) { return ($v | Out-String).Trim() }
    } catch { }
    return 'installed'
}

function Get-BestEffortVersion {
    param([Parameter(Mandatory)][string]$Name)
    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if (-not $cmd) { return $null }
    foreach ($arg in @('--version', '-?')) {
        try {
            $out = (& $cmd.Source $arg 2>$null | Where-Object { $_ } | Select-Object -First 1)
            if ($out) { return ($out | Out-String).Trim() }
        } catch { }
    }
    return 'installed'
}

# ---- installers: run the install, return the installer exit code (0 = reported OK); throw on hard error ----

function Install-ViaWinGet {
    param([Parameter(Mandatory)][string]$Id, [string]$Moniker)
    if (-not (Test-WinGet)) { throw "winget (Windows App Installer) is not available on this machine." }
    $flags = @('-e', '--accept-package-agreements', '--accept-source-agreements', '--source', 'winget')
    Write-Host "      > winget install --id $Id $($flags -join ' ')" -ForegroundColor DarkGray
    & winget install --id $Id @flags 2>&1 | Out-Host
    $code = $LASTEXITCODE
    if ($code -ne 0 -and $Moniker) {
        Write-Host "      winget by id returned $code; retrying via moniker '$Moniker' ..." -ForegroundColor DarkGray
        & winget install $Moniker @flags 2>&1 | Out-Host
        $code = $LASTEXITCODE
    }
    return $code
}

function Install-DotNetSdk {
    # Preferred: winget (machine-wide, may prompt for UAC). Fallback: official user-local script.
    if (Test-WinGet) {
        $code = Install-ViaWinGet -Id 'Microsoft.DotNet.SDK.10'
        Update-SessionPath
        if ($code -eq 0 -and (Get-DotNetSdkVersion)) { return 0 }
        Write-Host "      winget did not yield a usable SDK (exit $code); using the official install script ..." -ForegroundColor Yellow
    } else {
        Write-Host "      winget not available; using the official install script ..." -ForegroundColor Yellow
    }
    $script = Join-Path $env:TEMP 'dotnet-install.ps1'
    Write-Host "      Downloading https://dot.net/v1/dotnet-install.ps1 ..." -ForegroundColor DarkGray
    Invoke-WebRequest -Uri 'https://dot.net/v1/dotnet-install.ps1' -OutFile $script -UseBasicParsing
    Write-Host "      Running dotnet-install (channel 10.0, user-local, no admin needed) ..." -ForegroundColor DarkGray
    & $script -Channel '10.0' -Quality GA | Out-Host
    Update-SessionPath
    return 0
}

function Install-SqlPackage {
    Update-SessionPath
    if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
        throw "The .NET SDK is required to install SqlPackage - install .NET first, then re-run."
    }
    Write-Host "      > dotnet tool install --global microsoft.sqlpackage" -ForegroundColor DarkGray
    & dotnet tool install --global microsoft.sqlpackage 2>&1 | Out-Host
    $code = $LASTEXITCODE
    if ($code -ne 0) {
        Write-Host "      install returned $code; trying 'dotnet tool update' (already installed?) ..." -ForegroundColor DarkGray
        & dotnet tool update --global microsoft.sqlpackage 2>&1 | Out-Host
        $code = $LASTEXITCODE
    }
    Update-SessionPath
    return $code
}

# Ask Y/n (default Yes). Auto-yes with -Force; auto-no when we can't prompt.
function Confirm-Install {
    param([Parameter(Mandatory)][string]$What)
    if ($Force) { return $true }
    if (-not (Test-Interactive)) { return $false }
    $ans = Read-Host "      Download and install $What now? [Y/n]"
    if ([string]::IsNullOrWhiteSpace($ans)) { return $true }
    return ($ans.Trim().ToUpper() -in @('Y', 'YES'))
}

# ---------------------------------------------------------------------------
# Prerequisite catalogue.
# ---------------------------------------------------------------------------
$prereqs = @(
    @{
        Name = '.NET SDK'; Required = $true
        Why  = "Builds the .sqlproj into a .dacpac ('dotnet build') and hosts SqlPackage."
        Hint = 'winget install Microsoft.DotNet.SDK.10   (or https://dotnet.microsoft.com/download)'
        Check   = { Get-DotNetSdkVersion }
        Install = { Install-DotNetSdk }
    },
    @{
        Name = 'SqlPackage'; Required = $true
        Why  = 'Extract / compare / deploy - generates and applies the migration scripts.'
        Hint = 'dotnet tool install --global microsoft.sqlpackage'
        Check   = { Get-SqlPackageVersion }
        Install = { Install-SqlPackage }
    },
    @{
        Name = 'sqlcmd'; Required = $false
        Why  = 'Optional - run ad-hoc T-SQL from the command line (not used by 1-4 scripts).'
        Hint = 'winget install sqlcmd   (or SQL Server client tools)'
        Check   = { Get-BestEffortVersion -Name 'sqlcmd' }
        Install = { Install-ViaWinGet -Id 'Microsoft.Sqlcmd' -Moniker 'sqlcmd' }
    },
    @{
        Name = 'Git'; Required = $false
        Why  = 'Optional - review schema diffs (git status / git diff) before committing.'
        Hint = 'winget install Git.Git   (or https://git-scm.com)'
        Check   = { Get-BestEffortVersion -Name 'git' }
        Install = { Install-ViaWinGet -Id 'Git.Git' -Moniker 'git' }
    }
)

$failed       = $false
$results      = @()
$needsRestart = @()
try {
    $isAdmin = Test-IsAdmin
    $mode = if ($CheckOnly) { 'check only (no installs)' }
            elseif ($Force) { 'auto-install (-Force, no prompts)' }
            else            { 'install missing (asks before each)' }

    Write-Host ''
    Write-Host '================= CentralAccessDB - prerequisite check =================' -ForegroundColor Cyan
    Write-Host (" PowerShell      : {0} ({1})" -f $PSVersionTable.PSVersion, $PSVersionTable.PSEdition)
    Write-Host (" OS              : {0}" -f [Environment]::OSVersion.VersionString)
    Write-Host (" User            : {0}   Administrator: {1}" -f [Environment]::UserName, $isAdmin)
    Write-Host (" winget          : {0}" -f $(if (Test-WinGet) { 'available' } else { 'NOT available' }))
    Write-Host (" Mode            : {0}" -f $mode)
    Write-Host (" Include optional: {0}" -f [bool]$IncludeOptional)
    Write-Host '========================================================================' -ForegroundColor Cyan

    if (-not $isAdmin -and -not $CheckOnly -and (Test-WinGet)) {
        Write-Host ''
        Write-Host 'NOTE: Not running as Administrator. Machine-wide installs (e.g. the .NET SDK)' -ForegroundColor Yellow
        Write-Host '      may pop a UAC prompt or fall back to a user-local install. For the' -ForegroundColor Yellow
        Write-Host '      smoothest run, right-click PowerShell and "Run as administrator".' -ForegroundColor Yellow
    }

    $stepNo = 0
    $total  = $prereqs.Count
    foreach ($p in $prereqs) {
        $stepNo++
        Write-Host ''
        Write-Host ('[{0}/{1}] {2}  ({3})' -f $stepNo, $total, $p.Name, $(if ($p.Required) { 'required' } else { 'optional' })) -ForegroundColor White
        Write-Host ("        Purpose: {0}" -f $p.Why) -ForegroundColor DarkGray
        Write-Host  '        Checking ...' -ForegroundColor DarkGray

        $ver = & $p.Check
        if ($ver) {
            Write-Host ("      [OK] Found: {0}" -f $ver) -ForegroundColor Green
            $results += [pscustomobject]@{ Name = $p.Name; Required = $p.Required; Status = 'OK'; Detail = $ver }
            continue
        }

        # Missing.
        $missColor = if ($p.Required) { 'Red' } else { 'Yellow' }
        Write-Host ("      [MISSING] {0} is not installed." -f $p.Name) -ForegroundColor $missColor
        Write-Host ("      Install : {0}" -f $p.Hint) -ForegroundColor DarkGray

        # Decide whether to install.
        $doInstall = $false
        if ($CheckOnly) {
            Write-Host '      -CheckOnly: not installing.' -ForegroundColor Yellow
        }
        elseif (-not $p.Required -and -not $IncludeOptional) {
            Write-Host '      Optional - skipping. Use -IncludeOptional to install it.' -ForegroundColor Yellow
        }
        else {
            $doInstall = Confirm-Install -What $p.Name
            if (-not $doInstall) {
                if (Test-Interactive) { Write-Host '      Skipped (you declined).' -ForegroundColor Yellow }
                else { Write-Host '      Non-interactive session - cannot prompt. Re-run with -Force to install.' -ForegroundColor Yellow }
            }
        }

        if (-not $doInstall) {
            $status = if ($p.Required) { 'MISSING' } else { 'SKIPPED' }
            $results += [pscustomobject]@{ Name = $p.Name; Required = $p.Required; Status = $status; Detail = $p.Hint }
            continue
        }

        # Install, then re-check to confirm.
        Write-Host ("      [INSTALLING] {0} ..." -f $p.Name) -ForegroundColor Cyan
        $threw = $false; $err = $null; $code = $null
        try { $code = & $p.Install }
        catch { $threw = $true; $err = $_.Exception.Message }

        Update-SessionPath
        $ver2 = if ($threw) { $null } else { & $p.Check }

        if ($ver2) {
            Write-Host ("      [INSTALLED] {0}: {1}" -f $p.Name, $ver2) -ForegroundColor Green
            $results += [pscustomobject]@{ Name = $p.Name; Required = $p.Required; Status = 'INSTALLED'; Detail = $ver2 }
        }
        elseif ($threw) {
            Write-Host ("      [FAILED] Could not install {0}: {1}" -f $p.Name, $err) -ForegroundColor Red
            $results += [pscustomobject]@{ Name = $p.Name; Required = $p.Required; Status = 'FAILED'; Detail = $err }
        }
        elseif ($code -ne $null -and $code -ne 0) {
            Write-Host ("      [FAILED] Installer for {0} exited with code {1}." -f $p.Name, $code) -ForegroundColor Red
            $results += [pscustomobject]@{ Name = $p.Name; Required = $p.Required; Status = 'FAILED'; Detail = "installer exit $code" }
        }
        else {
            # Installed OK but not visible on PATH in this process yet.
            Write-Host ("      [INSTALLED] {0} installed, but not detected yet - open a NEW terminal and re-run this script to verify." -f $p.Name) -ForegroundColor Yellow
            $results += [pscustomobject]@{ Name = $p.Name; Required = $p.Required; Status = 'RESTART'; Detail = 'reopen terminal to detect' }
            $needsRestart += $p.Name
        }
    }

    # ---- Summary ----
    Write-Host ''
    Write-Host '==================== PREREQUISITE SUMMARY ====================' -ForegroundColor Cyan
    foreach ($r in $results) {
        $color = switch ($r.Status) {
            'OK'        { 'Green' }
            'INSTALLED' { 'Green' }
            'RESTART'   { 'Yellow' }
            'SKIPPED'   { 'Yellow' }
            'MISSING'   { 'Red' }
            'FAILED'    { 'Red' }
            default     { 'Gray' }
        }
        $tag = if ($r.Required) { '(required)' } else { '(optional)' }
        Write-Host ("  {0,-12} {1,-11} {2,-10} {3}" -f $r.Name, $tag, $r.Status, $r.Detail) -ForegroundColor $color
    }
    Write-Host '==============================================================' -ForegroundColor Cyan

    $missingRequired = @($results | Where-Object { $_.Required -and $_.Status -in @('MISSING', 'FAILED') })

    Write-Host ''
    if ($missingRequired.Count -gt 0) {
        $failed = $true
        Write-Host ("Action needed: {0} required tool(s) still missing:" -f $missingRequired.Count) -ForegroundColor Red
        foreach ($m in $missingRequired) { Write-Host ("   - {0}  ->  {1}" -f $m.Name, $m.Detail) -ForegroundColor Red }
        Write-Host ''
        Write-Host 'Fix it, then re-run this script:' -ForegroundColor Yellow
        Write-Host '   * re-run as Administrator (needed for machine-wide .NET installs), or' -ForegroundColor Yellow
        Write-Host '   * install the tool(s) manually using the commands above, or' -ForegroundColor Yellow
        Write-Host '   * re-run with -Force to skip the prompts.' -ForegroundColor Yellow
    }
    elseif ($needsRestart.Count -gt 0) {
        Write-Host ("Installed but not yet on PATH: {0}." -f ($needsRestart -join ', ')) -ForegroundColor Yellow
        Write-Host 'Open a NEW terminal and re-run this script - it should then report all OK.' -ForegroundColor Yellow
    }
    else {
        Write-Host 'All required prerequisites are present. You are ready to run:' -ForegroundColor Green
        Write-Host '   .\scripts\1_extract.ps1   - refresh the project from the live source DB' -ForegroundColor Green
        Write-Host '   .\scripts\2_build.ps1     - build the .dacpac' -ForegroundColor Green
        Write-Host '   .\scripts\3_compare.ps1   - generate the migration script vs a target DB' -ForegroundColor Green
        Write-Host '   .\scripts\4_deploy.ps1    - preview, confirm (type YES), then migrate' -ForegroundColor Green
    }
}
catch {
    $failed = $true
    if ($NoPause) { throw }
    Write-Host "`nERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ScriptStackTrace) { Write-Host $_.ScriptStackTrace -ForegroundColor DarkGray }
}
finally {
    if (-not $NoLog) { Write-ScriptStatus -Failed $failed }
    Stop-ScriptLog
    if (-not $NoPause) { Wait-ForKeyIfInteractive }
}
# Set our own exit code explicitly so a leaked $LASTEXITCODE from a native version
# probe (sqlcmd/git) can't be mistaken for failure by CI or a calling script.
if ($failed) { exit 1 } else { exit 0 }
