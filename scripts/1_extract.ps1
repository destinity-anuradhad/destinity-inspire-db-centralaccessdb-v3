<#
.SYNOPSIS
    Refresh the SQL project from a live source database.

.DESCRIPTION
    Extracts every application-scoped object from the source database into
    file-per-object .sql scripts (SqlPackage /Action:Extract, ExtractTarget=SchemaObjectType)
    and syncs them into src\CentralAccessDB, so the project stays a faithful mirror
    of the database. Object folders are replaced wholesale, so objects deleted in the
    database are also removed from the project (no stale files). The .sqlproj file is
    preserved.

.PARAMETER Password
    Source DB password. If omitted, falls back to $env:SOURCE_DB_PASSWORD, then prompts.

.PARAMETER NoPause
    Do not pause for a key press at the end. Set automatically for CI / redirected input.

.EXAMPLE
    $env:SOURCE_DB_PASSWORD = '...'; .\scripts\1_extract.ps1
#>
[CmdletBinding()]
param(
    [string]$Server   = '10.4.1.180',
    [string]$Database = 'CentralAccessDB',
    [string]$User     = 'stplfo',
    [string]$Password,
    [switch]$TrustServerCertificate = $true,
    [switch]$NoPause,
    [switch]$NoLog
)

. "$PSScriptRoot\_Common.ps1"
if (-not $NoLog) { Start-ScriptLog -Name '1_extract' }

$failed   = $false
$tempRoot = $null
try {
    Write-DbAccessNote -Server $Server

    $projectDir = Get-ProjectDir
    $srcPwd     = Resolve-DbPassword -Password $Password -EnvVar 'SOURCE_DB_PASSWORD' -PromptLabel "Password for $User@$Server"
    $cs         = New-DbConnectionString -Server $Server -Database $Database -User $User -Password $srcPwd -TrustServerCertificate:$TrustServerCertificate

    # SchemaObjectType extraction requires a NON-existing target folder, so extract to a
    # temp location and then sync the schema folders into the project.
    $tempRoot = Join-Path ([IO.Path]::GetTempPath()) ("cadb_extract_" + [guid]::NewGuid().ToString('N'))
    $target   = Join-Path $tempRoot 'db'
    New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null

    Write-Host "Extracting $Database from $Server ..." -ForegroundColor Cyan
    Invoke-SqlPackage -Arguments @(
        '/Action:Extract',
        "/SourceConnectionString:$cs",
        "/TargetFile:$target",
        '/p:ExtractTarget=SchemaObjectType',
        '/p:ExtractApplicationScopedObjectsOnly=True',
        '/p:VerifyExtraction=False'
    )

    Write-Host "Syncing extracted objects into $projectDir ..." -ForegroundColor Cyan
    foreach ($dir in Get-ChildItem -Path $target -Directory) {
        $dest = Join-Path $projectDir $dir.Name
        if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
        Move-Item -Path $dir.FullName -Destination $dest
    }

    $count = (Get-ChildItem -Path $projectDir -Recurse -Filter *.sql | Measure-Object).Count
    Write-Host "Done. Project now contains $count .sql files." -ForegroundColor Green
    Write-Host "Review the diff with 'git status' / 'git diff' before committing." -ForegroundColor Yellow
}
catch {
    $failed = $true
    if ($NoPause) { throw }
    Write-Host "`nERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ScriptStackTrace) { Write-Host $_.ScriptStackTrace -ForegroundColor DarkGray }
}
finally {
    if ($tempRoot) { Remove-Item -Recurse -Force $tempRoot -ErrorAction SilentlyContinue }
    if (-not $NoLog) { Write-ScriptStatus -Failed $failed }
    Stop-ScriptLog
    if (-not $NoPause) { Wait-ForKeyIfInteractive }
}
if ($failed) { exit 1 }
