<#
.SYNOPSIS
    Build the SQL project into a .dacpac.

.DESCRIPTION
    Runs 'dotnet build' on the SDK-style SQL project (Microsoft.Build.Sql) and reports
    the path to the produced dacpac. The dacpac is the deployable artifact used by
    3_compare.ps1 and 4_deploy.ps1.

.PARAMETER NoPause
    Do not pause for a key press at the end. Set automatically for nested calls and CI.

.EXAMPLE
    .\scripts\2_build.ps1                 # Release build
    .\scripts\2_build.ps1 -Configuration Debug -Rebuild
#>
[CmdletBinding()]
param(
    [ValidateSet('Release','Debug')][string]$Configuration = 'Release',
    [switch]$Rebuild,
    [switch]$NoPause,
    [switch]$NoLog
)

. "$PSScriptRoot\_Common.ps1"
if (-not $NoLog) { Start-ScriptLog -Name '2_build' }

$failed = $false
try {
    Write-Host 'NOTE: This step builds the project locally with dotnet and does NOT connect' -ForegroundColor DarkGray
    Write-Host '      to any database, so no DB network access is required here.' -ForegroundColor DarkGray

    $project = Get-ProjectFile
    $targetArg = if ($Rebuild) { '-t:Rebuild' } else { $null }

    Write-Host "Building $project ($Configuration) ..." -ForegroundColor Cyan
    $buildArgs = @($project, '-c', $Configuration, '-v', 'minimal') + @($targetArg | Where-Object { $_ })
    # Route build output to the host so it doesn't pollute this script's return value
    # (3_compare.ps1/4_deploy.ps1 capture the returned dacpac path).
    dotnet build @buildArgs 2>&1 | Out-Host
    if ($LASTEXITCODE -ne 0) { throw "dotnet build failed with exit code $LASTEXITCODE" }

    $dacpac = Join-Path (Get-ProjectDir) "bin\$Configuration\CentralAccessDB.dacpac"
    if (-not (Test-Path $dacpac)) { throw "Build succeeded but dacpac not found at $dacpac" }

    Write-Host "Dacpac: $dacpac" -ForegroundColor Green
    return $dacpac
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
