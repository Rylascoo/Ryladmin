[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][ValidateSet("Project","Website")][string]$Lane,
    [Parameter(Mandatory=$true)][string]$WorktreePath,
    [Parameter(Mandatory=$true)][ValidatePattern("^[0-9a-fA-F]{40}$")][string]$ExpectedHead,
    [Parameter(Mandatory=$true)][string]$PromptPath,
    [Parameter(Mandatory=$true)][ValidatePattern("^[A-Za-z0-9._-]+$")][string]$DispatchId,
    [ValidateRange(30,240)][int]$TimeoutSeconds = 240,
    [string]$OutputRoot = 'C:\Users\Wiryl\.codex-ensemble\scratch\supervised-review',
    [switch]$Check
)

$ErrorActionPreference = 'Stop'
$AdminHome = 'C:\Users\Wiryl\.codex-ensemble'
$ManifestPath = Join-Path $AdminHome 'state\runtime-manifest.json'
$AdminLauncher = Join-Path $AdminHome 'bin\ensemble-admin.ps1'
$ChildLauncher = Join-Path $AdminHome 'bin\ensemble-reviewer-child.ps1'
$Manifest = Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json
$Exe = $Manifest.codex.executable

$Repos = @{
    Project = @{ Path = 'C:\Users\Wiryl\Sol Dev\Ensemble-Project'; Remote = 'https://github.com/Rylascoo/Ensemble-Project' }
    Website = @{ Path = 'C:\Users\Wiryl\Sol Dev\Ensemble-Website'; Remote = 'https://github.com/Rylascoo/Ensemble-Website' }
}
$Repo = $Repos[$Lane]
function Get-StringSha256([string]$Text) {
    $sha = [Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [Text.Encoding]::UTF8.GetBytes($Text)
        return (-join ($sha.ComputeHash($bytes) | ForEach-Object { $_.ToString('X2') }))
    } finally { $sha.Dispose() }
}

function Get-WorktreeSeal([string]$Root) {
    $head = (git -C $Root rev-parse HEAD).Trim().ToLowerInvariant()
    $statusText = ((git -C $Root status --porcelain=v1 --untracked-files=all) -join "`n")
    $workDiff = ((git -C $Root diff --binary --no-ext-diff -- .) -join "`n")
    $indexDiff = ((git -C $Root diff --cached --binary --no-ext-diff -- .) -join "`n")
    $paths = @(git -C $Root ls-files -co --exclude-standard | Sort-Object -Unique)
    $entries = [System.Collections.Generic.List[string]]::new()
    foreach ($relative in $paths) {
        $full = Join-Path $Root $relative
        if (Test-Path -LiteralPath $full -PathType Leaf) {
            $item = Get-Item -LiteralPath $full
            $hash = (Get-FileHash -LiteralPath $full -Algorithm SHA256).Hash
            $entries.Add("$relative`t$($item.Length)`t$hash")
        } else { $entries.Add("$relative`tMISSING") }
    }
    $material = @(
        "HEAD=$head",
        "STATUS_SHA256=$(Get-StringSha256 $statusText)",
        "WORK_DIFF_SHA256=$(Get-StringSha256 $workDiff)",
        "INDEX_DIFF_SHA256=$(Get-StringSha256 $indexDiff)",
        "FILES_SHA256=$(Get-StringSha256 ($entries -join "`n"))"
    ) -join "`n"
    return [pscustomobject]@{
        head = $head
        status = $statusText
        file_count = $entries.Count
        seal_sha256 = Get-StringSha256 $material
    }
}

$native = @'
using System;
using System.Runtime.InteropServices;
public static class EnsembleReviewerJob {
 [StructLayout(LayoutKind.Sequential)] public struct BASIC { public long A,B; public uint LimitFlags; public UIntPtr C,D; public uint E; public UIntPtr F; public uint G,H; }
 [StructLayout(LayoutKind.Sequential)] public struct IOC { public ulong A,B,C,D,E,F; }
 [StructLayout(LayoutKind.Sequential)] public struct EXT { public BASIC BasicLimitInformation; public IOC IoInfo; public UIntPtr A,B,C,D; }
 [DllImport("kernel32.dll", CharSet=CharSet.Unicode)] public static extern IntPtr CreateJobObject(IntPtr a,string n);
 [DllImport("kernel32.dll", SetLastError=true)] public static extern bool SetInformationJobObject(IntPtr j,int c,ref EXT i,uint l);
 [DllImport("kernel32.dll", SetLastError=true)] public static extern bool QueryInformationJobObject(IntPtr j,int c,out EXT i,uint l,out uint r);
 [DllImport("kernel32.dll", SetLastError=true)] public static extern bool AssignProcessToJobObject(IntPtr j,IntPtr p);
 [DllImport("kernel32.dll", SetLastError=true)] public static extern bool TerminateJobObject(IntPtr j,uint e);
 [DllImport("kernel32.dll")] public static extern bool CloseHandle(IntPtr h);
 public const uint KILL_ON_CLOSE=0x2000; public const int EXTENDED=9;
}
'@
if (-not ('EnsembleReviewerJob' -as [type])) { Add-Type -TypeDefinition $native }

function Get-DescendantSnapshot([int]$RootPid) {
    $rows = Get-CimInstance Win32_Process | Select-Object ProcessId,ParentProcessId,Name,CommandLine
    $found = [System.Collections.Generic.List[object]]::new()
    $queue = [System.Collections.Generic.Queue[int]]::new()
    $queue.Enqueue($RootPid)
    while ($queue.Count -gt 0) {
        $parent = $queue.Dequeue()
        foreach ($row in $rows | Where-Object { [int]$_.ParentProcessId -eq $parent }) {
            $found.Add($row)
            $queue.Enqueue([int]$row.ProcessId)
        }
    }
    return @($found)
}

if (-not (Test-Path -LiteralPath $ChildLauncher -PathType Leaf)) { throw "Reviewer child missing: $ChildLauncher" }
if (-not $Manifest.files.'bin/ensemble-reviewer-supervisor.ps1') { throw 'Runtime manifest does not admit reviewer supervisor.' }
$Candidate = (Resolve-Path -LiteralPath $WorktreePath).Path
$Canonical = (Resolve-Path -LiteralPath $Repo.Path).Path
if ($Candidate -eq $Canonical) { throw 'Supervised Reviewer requires an isolated linked worktree, not the canonical repository root.' }
$Top = (git -C $Candidate rev-parse --show-toplevel).Trim().Replace('\','/')
if ($Top -ne $Candidate.Replace('\','/')) { throw "WorktreePath must name the exact worktree root: $Top" }
$CanonicalCommon = (git -C $Canonical rev-parse --path-format=absolute --git-common-dir).Trim().Replace('\','/')
$CandidateCommon = (git -C $Candidate rev-parse --path-format=absolute --git-common-dir).Trim().Replace('\','/')
if ($CandidateCommon -ne $CanonicalCommon) { throw "WorktreePath belongs to a different Git common directory: $CandidateCommon" }
$Remote = (git -C $Candidate remote get-url origin).Trim().TrimEnd('/')
if ($Remote -ne $Repo.Remote) { throw "Unexpected origin: $Remote" }
$Head = (git -C $Candidate rev-parse HEAD).Trim().ToLowerInvariant()
if ($Head -ne $ExpectedHead.ToLowerInvariant()) { throw "Reviewer HEAD mismatch: expected $ExpectedHead; found $Head" }
if (Test-Path (Join-Path $Candidate '.codex\config.toml')) { throw 'Project .codex/config.toml exists and is not admitted.' }

$Prompt = (Resolve-Path -LiteralPath $PromptPath).Path
$PromptHash = (Get-FileHash -LiteralPath $Prompt -Algorithm SHA256).Hash
$BeforeSeal = Get-WorktreeSeal $Candidate
if ($BeforeSeal.head -ne $ExpectedHead.ToLowerInvariant()) { throw 'Pre-review seal HEAD mismatch.' }

if (-not (Test-Path -LiteralPath $Exe -PathType Leaf)) { throw "Pinned Codex executable missing: $Exe" }
$ExeHash = (Get-FileHash -LiteralPath $Exe -Algorithm SHA256).Hash
if ($ExeHash -ne $Manifest.codex.sha256) { throw "Pinned Codex executable hash drift: $ExeHash" }
$Version = (& $Exe --version 2>$null).Trim()
if ($Version -ne $Manifest.codex.version_output) { throw "Pinned Codex version drift: $Version" }
$SupervisorHash = (Get-FileHash -LiteralPath $PSCommandPath -Algorithm SHA256).Hash
$ChildHash = (Get-FileHash -LiteralPath $ChildLauncher -Algorithm SHA256).Hash
if ($SupervisorHash -ne $Manifest.files.'bin/ensemble-reviewer-supervisor.ps1') { throw 'Reviewer supervisor hash drift.' }
if ($ChildHash -ne $Manifest.files.'bin/ensemble-reviewer-child.ps1') { throw 'Reviewer child hash drift.' }
if ((Get-FileHash -LiteralPath $AdminLauncher -Algorithm SHA256).Hash -ne $Manifest.files.'bin/ensemble-admin.ps1') { throw 'Administrator launcher hash drift.' }

$ScratchRoot = [IO.Path]::GetFullPath((Join-Path $AdminHome 'scratch'))
$OutputRootFull = [IO.Path]::GetFullPath($OutputRoot)
$ScratchPrefix = $ScratchRoot.TrimEnd('\') + '\'
if (-not (($OutputRootFull + '\').StartsWith($ScratchPrefix,[StringComparison]::OrdinalIgnoreCase))) { throw 'OutputRoot must remain inside Administrator scratch.' }
$OutputDir = Join-Path $OutputRootFull $DispatchId
$Gate = Join-Path $OutputDir 'start.gate'
$Stdout = Join-Path $OutputDir 'reviewer.stdout.txt'
$Stderr = Join-Path $OutputDir 'reviewer.stderr.txt'
$EvidencePath = Join-Path $OutputDir 'reviewer.evidence.json'
if (Test-Path -LiteralPath $OutputDir) { throw "Dispatch output already exists; refusing overwrite: $OutputDir" }
New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

if ($Check) {
    [pscustomobject]@{
        check = 'PASS'; lane = $Lane; dispatch_id = $DispatchId
        worktree = $Candidate; expected_head = $ExpectedHead.ToLowerInvariant()
        prompt_sha256 = $PromptHash; before_seal_sha256 = $BeforeSeal.seal_sha256
        codex_version = $Version; codex_sha256 = $ExeHash
        output_dir = $OutputDir
    } | ConvertTo-Json -Depth 4
    Remove-Item -LiteralPath $OutputDir -Force
    exit 0
}

$job = [EnsembleReviewerJob]::CreateJobObject([IntPtr]::Zero,$null)
if ($job -eq [IntPtr]::Zero) { throw 'CreateJobObject failed.' }
$p = $null; $jobClosed = $false
$clock = [Diagnostics.Stopwatch]::StartNew()
$deadlineObservedMs = $null; $terminateRequestedMs = $null; $treeTerminatedMs = $null
try {
    $info = [EnsembleReviewerJob+EXT]::new()
    $basic = $info.BasicLimitInformation
    $basic.LimitFlags = [EnsembleReviewerJob]::KILL_ON_CLOSE
    $info.BasicLimitInformation = $basic
    $len = [Runtime.InteropServices.Marshal]::SizeOf([type][EnsembleReviewerJob+EXT])
    $setOk = [EnsembleReviewerJob]::SetInformationJobObject($job,[EnsembleReviewerJob]::EXTENDED,[ref]$info,[uint32]$len)
    if (-not $setOk) { throw 'SetInformationJobObject failed.' }
    $queryInfo = [EnsembleReviewerJob+EXT]::new(); $returned = 0
    $queryOk = [EnsembleReviewerJob]::QueryInformationJobObject($job,[EnsembleReviewerJob]::EXTENDED,[ref]$queryInfo,[uint32]$len,[ref]$returned)
    $flags = [uint32]$queryInfo.BasicLimitInformation.LimitFlags
    if ((-not $queryOk) -or (($flags -band [EnsembleReviewerJob]::KILL_ON_CLOSE) -eq 0)) {
        throw ('Job kill-on-close verification failed: 0x{0:X}' -f $flags)
    }

    $psi = [Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = (Get-Command pwsh.exe).Source
    $psi.UseShellExecute = $false
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.WorkingDirectory = $Candidate
    $psi.ArgumentList.Add('-NoProfile')
    $psi.ArgumentList.Add('-File'); $psi.ArgumentList.Add($ChildLauncher)
    $psi.ArgumentList.Add('-Lane'); $psi.ArgumentList.Add($Lane)
    $psi.ArgumentList.Add('-WorktreePath'); $psi.ArgumentList.Add($Candidate)
    $psi.ArgumentList.Add('-StartGate'); $psi.ArgumentList.Add($Gate)
    $p = [Diagnostics.Process]::new(); $p.StartInfo = $psi
    if (-not $p.Start()) { throw 'Reviewer wrapper start failed.' }
    $assignOk = [EnsembleReviewerJob]::AssignProcessToJobObject($job,$p.Handle)
    if (-not $assignOk) { throw 'AssignProcessToJobObject failed.' }
    $outTask = $p.StandardOutput.ReadToEndAsync()
    $errTask = $p.StandardError.ReadToEndAsync()
    $promptText = [IO.File]::ReadAllText($Prompt,[Text.UTF8Encoding]::new($false,$true))
    [IO.File]::WriteAllText($Gate,'go',[Text.UTF8Encoding]::new($false))
    $p.StandardInput.Write($promptText)
    $p.StandardInput.Close()

    $deadlineMs = $TimeoutSeconds * 1000
    while ((-not $p.HasExited) -and $clock.ElapsedMilliseconds -lt $deadlineMs) {
        Start-Sleep -Milliseconds 100
    }
    $timedOut = -not $p.HasExited
    $descendantsBeforeStop = if ($timedOut) { @(Get-DescendantSnapshot $p.Id) } else { @() }
    $terminateOk = $false
    if ($timedOut) {
        $deadlineObservedMs = [int64]$clock.ElapsedMilliseconds
        $terminateRequestedMs = [int64]$clock.ElapsedMilliseconds
        $terminateOk = [EnsembleReviewerJob]::TerminateJobObject($job,124)
        if (-not $terminateOk) { throw 'TerminateJobObject failed.' }
        if (-not $p.WaitForExit(10000)) { throw 'Reviewer wrapper did not terminate after job termination.' }
        $treeTerminatedMs = [int64]$clock.ElapsedMilliseconds
    } else {
        $p.WaitForExit()
        $treeTerminatedMs = [int64]$clock.ElapsedMilliseconds
    }

    $out = $outTask.GetAwaiter().GetResult()
    $err = $errTask.GetAwaiter().GetResult()
    [IO.File]::WriteAllText($Stdout,$out,[Text.UTF8Encoding]::new($false))
    [IO.File]::WriteAllText($Stderr,$err,[Text.UTF8Encoding]::new($false))
    [EnsembleReviewerJob]::CloseHandle($job) | Out-Null
    $jobClosed = $true
    Start-Sleep -Milliseconds 500

    $known = @($descendantsBeforeStop | ForEach-Object { [int]$_.ProcessId }) + @([int]$p.Id)
    $survivors = @()
    foreach ($pid0 in ($known | Sort-Object -Unique)) {
        $alive = Get-Process -Id $pid0 -ErrorAction SilentlyContinue
        if ($alive) { $survivors += [pscustomobject]@{ pid=$pid0; name=$alive.ProcessName } }
    }
    $all = Get-CimInstance Win32_Process | Select-Object ProcessId,Name,CommandLine
    $broad = @($all | Where-Object {
        $_.CommandLine -and (
            (($_.Name -ieq 'codex.exe') -and $_.CommandLine.Contains($Candidate)) -or
            (($_.Name -match '^pwsh(\.exe)?$') -and $_.CommandLine.Contains('ensemble-reviewer-child.ps1') -and $_.CommandLine.Contains($Candidate))
        )
    })

    $AfterSeal = Get-WorktreeSeal $Candidate
    $worktreeUnchanged = ($BeforeSeal.seal_sha256 -eq $AfterSeal.seal_sha256) -and ($AfterSeal.head -eq $ExpectedHead.ToLowerInvariant())
    $required = @('WORK_RESULT:','BASELINE:','SCOPE:','EVIDENCE:','AUTHORITY_EFFECT:','FINDINGS:','ADOPTION:','NEXT_TASK_CANDIDATE:','NEXT_TASK_SOURCE:','NEXT_TASK_AUTHORITY:','NEXT_DISPATCH_DRAFT:','STOP_REASON:')
    $missing = @($required | Where-Object { -not $out.Contains($_) })
    $structured = ($missing.Count -eq 0)
    $completionPass = (-not $timedOut) -and ($p.ExitCode -eq 0) -and $structured
    $containmentPass = (($survivors.Count -eq 0) -and ($broad.Count -eq 0) -and $worktreeUnchanged)
    $timeoutContainmentPass = $timedOut -and $terminateOk -and $containmentPass
    $reviewPass = $completionPass -and $containmentPass
    $resultClass = if ($reviewPass) { 'COMPLETED_STRUCTURED' } elseif ($timeoutContainmentPass -and $structured) { 'TIMEOUT_CONTAINED_WITH_CONTRACT' } elseif ($timeoutContainmentPass) { 'TIMEOUT_CONTAINED_NO_CONTRACT' } elseif (-not $structured) { 'INVALID_REVIEW_RESULT' } else { 'SUPERVISION_FAILURE' }
    $evidence = [ordered]@{
        schema = 'ENSEMBLE_SUPERVISED_REVIEWER_V1'
        dispatch_id = $DispatchId; lane = $Lane; expected_head = $ExpectedHead.ToLowerInvariant()
        prompt_sha256 = $PromptHash; timeout_seconds = $TimeoutSeconds
        codex_version = $Version; codex_sha256 = $ExeHash
        supervisor_sha256 = $SupervisorHash; child_sha256 = $ChildHash
        job_set_kill_on_close = [bool]$setOk; job_query_ok = [bool]$queryOk
        job_limit_flags = ('0x{0:X}' -f $flags); job_assigned_before_gate = [bool]$assignOk
        timed_out = [bool]$timedOut; terminate_job_ok = [bool]$terminateOk
        reviewer_exit_code = $p.ExitCode; structured_contract = [bool]$structured
        missing_contract_fields = $missing; completion_pass = [bool]$completionPass
        containment_pass = [bool]$containmentPass; timeout_containment_pass = [bool]$timeoutContainmentPass
        review_pass = [bool]$reviewPass; result_class = $resultClass
        deadline_observed_ms = $deadlineObservedMs; terminate_requested_ms = $terminateRequestedMs
        tree_terminated_ms = $treeTerminatedMs; total_elapsed_ms = [int64]$clock.ElapsedMilliseconds
        before_seal_sha256 = $BeforeSeal.seal_sha256; after_seal_sha256 = $AfterSeal.seal_sha256
        worktree_unchanged = [bool]$worktreeUnchanged
        descendants_before_stop = @($descendantsBeforeStop | ForEach-Object { [ordered]@{ pid=[int]$_.ProcessId; ppid=[int]$_.ParentProcessId; name=$_.Name; command_line=$_.CommandLine } })
        survivors = $survivors; broad_survivor_hits = @($broad | ForEach-Object { [ordered]@{ pid=[int]$_.ProcessId; name=$_.Name; command_line=$_.CommandLine } })
        stdout_path = $Stdout; stdout_bytes = (Get-Item -LiteralPath $Stdout).Length
        stdout_sha256 = (Get-FileHash -LiteralPath $Stdout -Algorithm SHA256).Hash
        stderr_path = $Stderr; stderr_bytes = (Get-Item -LiteralPath $Stderr).Length
        stderr_sha256 = (Get-FileHash -LiteralPath $Stderr -Algorithm SHA256).Hash
    }
    [IO.File]::WriteAllText($EvidencePath,($evidence | ConvertTo-Json -Depth 10),[Text.UTF8Encoding]::new($false))
    $EvidenceHash = (Get-FileHash -LiteralPath $EvidencePath -Algorithm SHA256).Hash
    Write-Output "REVIEW_PASS=$reviewPass"
    Write-Output "RESULT_CLASS=$resultClass"
    Write-Output "TIMED_OUT=$timedOut"
    Write-Output "STRUCTURED_CONTRACT=$structured"
    Write-Output "CONTAINMENT_PASS=$containmentPass"
    Write-Output "WORKTREE_UNCHANGED=$worktreeUnchanged"
    Write-Output "KNOWN_SURVIVORS=$($survivors.Count)"
    Write-Output "BROAD_SURVIVORS=$($broad.Count)"
    Write-Output "EVIDENCE_SHA256=$EvidenceHash"
    if ($reviewPass) { exit 0 }
    if ($timeoutContainmentPass) { exit 124 }
    exit 2
}
finally {
    if ($job -ne [IntPtr]::Zero -and -not $jobClosed) {
        if ($p -and -not $p.HasExited) {
            [EnsembleReviewerJob]::TerminateJobObject($job,125) | Out-Null
            $null = $p.WaitForExit(10000)
        }
        [EnsembleReviewerJob]::CloseHandle($job) | Out-Null
    }
}
