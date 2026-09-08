<#
.SYNOPSIS
    Compare the SQL project (dacpac) against an OLD/target database and generate the
    migration script that would bring the target up to the project's schema.

.DESCRIPTION
    This is the core "compare and get the script" step. It runs:
      * SqlPackage /Action:Script       -> a T-SQL migration script (the diff), and
      * SqlPackage /Action:DeployReport -> an XML change report, summarized on screen.
    NOTHING is applied to the target - this is read-only against the target. Review the
    generated script, then apply it manually or via 4_deploy.ps1.

.PARAMETER TargetServer / TargetDatabase / TargetUser / TargetPassword
    Connection to the OLD database you want to migrate. This script ALWAYS uses SQL Server
    authentication and asks for the login username and password every run. Pass -TargetUser
    / -TargetPassword only to skip the prompts (e.g. in automation). Windows authentication
    is not used here.

.PARAMETER DacpacPath
    Dacpac to compare from. Defaults to the Release build; built automatically if missing.

.PARAMETER OutputDir
    Where to write the migration script + report. Default: <repo>\artifacts.

.PARAMETER NoPause
    Do not pause for a key press at the end. Set automatically for nested calls and CI.

.EXAMPLE
    .\scripts\3_compare.ps1 -TargetServer OLDSRV -TargetDatabase CentralAccessDB_Old -TargetUser sa
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$TargetServer,
    [Parameter(Mandatory)][string]$TargetDatabase,
    [string]$TargetUser,
    [string]$TargetPassword,
    [switch]$TrustServerCertificate = $true,
    [string]$DacpacPath,
    [string]$OutputDir,
    [switch]$NoPause,
    [switch]$NoLog
)

. "$PSScriptRoot\_Common.ps1"
if (-not $NoLog) { Start-ScriptLog -Name '3_compare' }

$failed = $false
try {
    Write-DbAccessNote -Server $TargetServer

    # Resolve the dacpac (build if needed).
    if (-not $DacpacPath) {
        $DacpacPath = Join-Path (Get-ProjectDir) 'bin\Release\CentralAccessDB.dacpac'
    }
    if (-not (Test-Path $DacpacPath)) {
        Write-Host "Dacpac not found - building it first ..." -ForegroundColor Yellow
        $DacpacPath = & "$PSScriptRoot\2_build.ps1" -Configuration Release -NoPause -NoLog
    }

    # Target connection: ALWAYS SQL Server authentication; ask for the login every run.
    if (-not $TargetUser) { $TargetUser = Read-Host "SQL login (username) for $TargetServer/$TargetDatabase" }
    if ([string]::IsNullOrWhiteSpace($TargetUser)) { throw "A SQL login username is required." }
    $tpwd = Resolve-DbPassword -Password $TargetPassword -PromptLabel "Password for $TargetUser@$TargetServer"
    $targetCs = New-DbConnectionString -Server $TargetServer -Database $TargetDatabase -User $TargetUser -Password $tpwd -TrustServerCertificate:$TrustServerCertificate

    # Output paths.
    if (-not $OutputDir) { $OutputDir = Join-Path (Get-RepoRoot) 'artifacts' }
    New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
    $stamp       = Get-Date -Format 'yyyyMMdd_HHmmss'
    $scriptOut   = Join-Path $OutputDir "migration_$($TargetDatabase)_$stamp.sql"
    $profilePath = Join-Path (Get-ProjectDir) 'CentralAccessDB.publish.xml'

    Write-Host "Generating migration script: $DacpacPath  ->  $TargetServer/$TargetDatabase" -ForegroundColor Cyan
    Invoke-SqlPackage -Arguments @(
        '/Action:Script',
        "/SourceFile:$DacpacPath",
        "/TargetConnectionString:$targetCs",
        "/Profile:$profilePath",
        "/OutputPath:$scriptOut",
        '/p:CommentOutSetVarDeclarations=False'
    )
    Write-Host "Migration script written to: $scriptOut" -ForegroundColor Green

    $reportOut = Join-Path $OutputDir "changereport_$($TargetDatabase)_$stamp.xml"
    Write-Host "Generating change report ..." -ForegroundColor Cyan
    Invoke-SqlPackage -Arguments @(
        '/Action:DeployReport',
        "/SourceFile:$DacpacPath",
        "/TargetConnectionString:$targetCs",
        "/Profile:$profilePath",
        "/OutputPath:$reportOut"
    )
    Write-Host "Change report written to: $reportOut" -ForegroundColor Green

    # Show what WILL change (grouped by operation and object type).
    Show-ChangeSummary -ReportPath $reportOut

    Write-Host ""
    Write-Host "To apply these changes, run 4_deploy.ps1 - it previews again and asks you to confirm." -ForegroundColor Yellow
}
catch {
    $failed = $true
    if ($NoPause) { throw }   # nested call: let the parent report and pause
    Write-Host "`nERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ScriptStackTrace) { Write-Host $_.ScriptStackTrace -ForegroundColor DarkGray }
}
finally {
    if (-not $NoLog) { Write-ScriptStatus -Failed $failed }
    Stop-ScriptLog
    if (-not $NoPause) { Wait-ForKeyIfInteractive }
}
if ($failed) { exit 1 }
