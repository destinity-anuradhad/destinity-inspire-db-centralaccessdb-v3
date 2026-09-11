<#
.SYNOPSIS
    Preview the changes against a target database, then (after you confirm) migrate.

.DESCRIPTION
    One-step migrate with a built-in safety gate:
      1. Builds the migration script + change report against the target and prints a
         CHANGE SUMMARY (what will be created / altered / dropped) - NOTHING applied yet.
      2. Shows a big PREVIEW banner.
      3. Asks you to type YES to proceed.
      4. Only if you confirm, publishes the schema to the target (SqlPackage /Action:Publish).

    Uses the shared safe-defaults profile (CentralAccessDB.publish.xml): blocks on possible
    data loss and never drops objects that aren't in the project.

.PARAMETER TargetServer / TargetDatabase / TargetUser / TargetPassword
    Connection to the database to migrate. SQL Server authentication; prompts for the login
    username if not supplied. Password falls back to $env:TARGET_DB_PASSWORD, then prompts.

.PARAMETER Force
    Skip the interactive "type YES" confirmation and apply immediately (for automation/CI).
    In a non-interactive session a prompt can't be shown, so -Force is required to apply there.

.PARAMETER NoPause / NoLog
    Do not pause for a key press / do not write a log file. Set automatically for nested/CI.

.EXAMPLE
    .\scripts\4_deploy.ps1 -TargetServer OLDSRV -TargetDatabase CentralAccessDB_Old -TargetUser sa
        Previews the changes, asks you to type YES, then migrates.

    .\scripts\4_deploy.ps1 -TargetServer OLDSRV -TargetDatabase CentralAccessDB_Old -TargetUser sa -Force
        Migrates without prompting (automation).
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$TargetServer,
    [Parameter(Mandatory)][string]$TargetDatabase,
    [string]$TargetUser,
    [string]$TargetPassword,
    [switch]$TrustServerCertificate = $true,
    [string]$DacpacPath,
    [switch]$Force,
    [switch]$NoPause,
    [switch]$NoLog
)

. "$PSScriptRoot\_Common.ps1"
if (-not $NoLog) { Start-ScriptLog -Name '4_deploy' }
Set-LowProcessPriority

$failed = $false
try {
    Write-DbAccessNote -Server $TargetServer

    if (-not $DacpacPath) {
        $DacpacPath = Join-Path (Get-ProjectDir) 'bin\Release\CentralAccessDB.dacpac'
    }
    if (-not (Test-Path $DacpacPath)) {
        Write-Host "Dacpac not found - building it first ..." -ForegroundColor Yellow
        $DacpacPath = & "$PSScriptRoot\2_build.ps1" -Configuration Release -NoPause -NoLog
    }

    # SQL Server authentication; ask for the login username if not supplied.
    if (-not $TargetUser) { $TargetUser = Read-Host "SQL login (username) for $TargetServer/$TargetDatabase" }
    if ([string]::IsNullOrWhiteSpace($TargetUser)) { throw "A SQL login username is required." }
    $tpwd = Resolve-DbPassword -Password $TargetPassword -EnvVar 'TARGET_DB_PASSWORD' -PromptLabel "Password for $TargetUser@$TargetServer"
    $targetCs    = New-DbConnectionString -Server $TargetServer -Database $TargetDatabase -User $TargetUser -Password $tpwd -TrustServerCertificate:$TrustServerCertificate
    $profilePath = Join-Path (Get-ProjectDir) 'CentralAccessDB.publish.xml'

    # ---- 1. PREVIEW: migration script + report + summary (nothing applied) ----
    $outDir = Join-Path (Get-RepoRoot) 'artifacts'
    New-Item -ItemType Directory -Force -Path $outDir | Out-Null
    $stamp     = Get-Date -Format 'yyyyMMdd_HHmmss'
    $scriptOut = Join-Path $outDir "migration_$($TargetDatabase)_$stamp.sql"
    $reportOut = Join-Path $outDir "changereport_$($TargetDatabase)_$stamp.xml"

    Write-Host "Generating migration script ..." -ForegroundColor Cyan
    Invoke-SqlPackage -Arguments @(
        '/Action:Script',
        "/SourceFile:$DacpacPath",
        "/TargetConnectionString:$targetCs",
        "/Profile:$profilePath",
        "/OutputPath:$scriptOut",
        '/p:CommentOutSetVarDeclarations=False'
    )
    Write-Host "Migration script: $scriptOut" -ForegroundColor Green

    Write-Host "Generating change report ..." -ForegroundColor Cyan
    Invoke-SqlPackage -Arguments @(
        '/Action:DeployReport',
        "/SourceFile:$DacpacPath",
        "/TargetConnectionString:$targetCs",
        "/Profile:$profilePath",
        "/OutputPath:$reportOut"
    )
    Show-ChangeSummary -ReportPath $reportOut

    $hasChanges = @(([xml](Get-Content -Raw -LiteralPath $reportOut)).SelectNodes('//*[local-name()="Operation"]')).Count -gt 0

    # ---- 2. Big preview banner ----
    Write-Host ''
    Write-Host '  ==============================================================' -ForegroundColor Yellow
    Write-Host '   ***  P R E V I E W   O N L Y  -  NOTHING CHANGED YET  ***' -ForegroundColor Yellow
    Write-Host "   Target : $TargetServer/$TargetDatabase" -ForegroundColor Yellow
    Write-Host "   Script : $scriptOut" -ForegroundColor Yellow
    Write-Host '   Review the CHANGE SUMMARY above before you continue.' -ForegroundColor Yellow
    Write-Host '  ==============================================================' -ForegroundColor Yellow
    Write-Host ''

    if (-not $hasChanges) {
        Write-Host "Nothing to migrate - the target already matches the project." -ForegroundColor Green
        return
    }

    # ---- 3. Confirm, then apply ----
    $proceed = $false
    if ($Force) {
        Write-Host "-Force specified: applying without confirmation." -ForegroundColor Yellow
        $proceed = $true
    }
    elseif (Test-Interactive) {
        $answer  = Read-Host "Apply these changes to $TargetServer/$TargetDatabase ?  Type YES to migrate"
        $proceed = ($answer -and $answer.Trim().ToUpper() -eq 'YES')
        if (-not $proceed) { Write-Host "Cancelled - you did not type YES. No changes were made." -ForegroundColor Yellow; return }
    }
    else {
        Write-Host "Non-interactive session: cannot ask for confirmation." -ForegroundColor Yellow
        Write-Host "Re-run with -Force to apply without a prompt. No changes were made." -ForegroundColor Yellow
        return
    }

    Write-Host ''
    Write-Host "APPLYING schema to $TargetServer/$TargetDatabase ..." -ForegroundColor Red
    Invoke-SqlPackage -Arguments @(
        '/Action:Publish',
        "/SourceFile:$DacpacPath",
        "/TargetConnectionString:$targetCs",
        "/Profile:$profilePath"
    )
    Write-Host "Publish complete - target migrated." -ForegroundColor Green
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
if ($failed) { exit 1 }
