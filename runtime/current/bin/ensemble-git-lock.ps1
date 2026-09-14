[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$RepoPath,
    [Parameter(Mandatory=$true)][ValidatePattern('^[A-Za-z0-9._-]+$')][string]$DispatchId,
    [Parameter(Mandatory=$true)][ValidatePattern('^[A-Za-z0-9._-]+$')][string]$Operation,
    [switch]$Describe,
    [Parameter(ValueFromRemainingArguments=$true)][string[]]$GitArgs
)

$ErrorActionPreference = 'Stop'
$AdminHome = 'C:\Users\Wiryl\.codex-ensemble'
$LockDir = Join-Path $AdminHome 'locks'
$Repo = (Resolve-Path $RepoPath).Path
$Top = (git -C $Repo rev-parse --show-toplevel).Trim()
if (-not $Top) { throw 'RepoPath is not a Git worktree.' }

$Common = (git -C $Repo rev-parse --path-format=absolute --git-common-dir).Trim().Replace('\','/')
if (-not $Common) { throw 'Unable to resolve Git common directory.' }
$Hasher = [Security.Cryptography.SHA256]::Create()
try {
    $KeyBytes = [Text.Encoding]::UTF8.GetBytes($Common.ToLowerInvariant())
    $Key = -join ($Hasher.ComputeHash($KeyBytes) | ForEach-Object { $_.ToString('x2') })
} finally {
    $Hasher.Dispose()
}

$LockPath = Join-Path $LockDir ('git-' + $Key.Substring(0,24) + '.lock.json')
if ($Describe) {
    Write-Output 'ENSEMBLE_SHARED_GIT_LOCK=DESCRIBE'
    Write-Output "COMMON_GIT_DIR=$Common"
    Write-Output "LOCK_PATH=$LockPath"
    exit 0
}

if (-not $GitArgs -or $GitArgs.Count -eq 0) {
    throw 'A Git command is required unless -Describe is used.'
}

New-Item -ItemType Directory -Force -Path $LockDir | Out-Null
$Record = [ordered]@{
    repository_common_git = $Common
    operation = $Operation
    process_session_identity = "${PID}:$([Environment]::UserName)"
    utc_acquired = (Get-Date).ToUniversalTime().ToString('o')
    dispatch_id = $DispatchId
}
$Json = $Record | ConvertTo-Json -Compress
$Utf8 = New-Object Text.UTF8Encoding($false)
$Bytes = $Utf8.GetBytes($Json)
$Stream = $null
try {
    $Stream = New-Object IO.FileStream($LockPath,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None)
    $Stream.Write($Bytes,0,$Bytes.Length)
    $Stream.Flush()
} catch [IO.IOException] {
    if ($Stream) { $Stream.Dispose(); $Stream = $null }
    [Console]::Error.WriteLine("Shared Git lock contention. No wait/no removal. Lock=$LockPath")
    exit 75
}
 finally {
    if ($Stream) { $Stream.Dispose() }
}

Write-Output 'ENSEMBLE_SHARED_GIT_LOCK=ACQUIRED'
Write-Output "LOCK_PATH=$LockPath"
Write-Output "OPERATION=$Operation"
$GitExit = $null
try {
    $Previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        & git -C $Repo @GitArgs
        $GitExit = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $Previous
    }
} finally {
    if (Test-Path $LockPath) {
        $Current = [IO.File]::ReadAllText($LockPath)
        if ($Current -ne $Json) {
            throw "Shared Git lock ownership changed; refusing removal: $LockPath"
        }
        Remove-Item -LiteralPath $LockPath -Force
        Write-Output 'ENSEMBLE_SHARED_GIT_LOCK=RELEASED'
    }
}

if ($null -eq $GitExit) { throw 'Git command did not produce an exit code.' }
exit $GitExit
