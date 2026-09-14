param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Project","Website")]
    [string]$Lane,
    [switch]$Check,
    [string]$WorktreePath,
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$CodexArgs
)

$ErrorActionPreference = "Stop"
$AdminHome = "C:\Users\Wiryl\.codex-ensemble"
$ManifestPath = Join-Path $AdminHome "state\runtime-manifest.json"
$Manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json
$Exe = $Manifest.codex.executable
$Python = $Manifest.tooling.python_runtime.executable
$PythonEnv = $Python.Replace('\','/')

$Repos = @{
    Project = @{ Path = "C:\Users\Wiryl\Sol Dev\Ensemble-Project"; Remote = "https://github.com/Rylascoo/Ensemble-Project" }
    Website = @{ Path = "C:\Users\Wiryl\Sol Dev\Ensemble-Website"; Remote = "https://github.com/Rylascoo/Ensemble-Website" }
}
$Repo = $Repos[$Lane]
$EffectivePath = $Repo.Path
if ($WorktreePath) {
    $Candidate = (Resolve-Path $WorktreePath).Path
    $CandidateTop = (git -C $Candidate rev-parse --show-toplevel).Trim().Replace('\','/')
    $ExpectedCandidateTop = $Candidate.Replace('\','/')
    if ($CandidateTop -ne $ExpectedCandidateTop) { throw "WorktreePath must name the exact worktree root: $CandidateTop" }
    $CanonicalCommon = (git -C $Repo.Path rev-parse --path-format=absolute --git-common-dir).Trim().Replace('\','/')
    $CandidateCommon = (git -C $Candidate rev-parse --path-format=absolute --git-common-dir).Trim().Replace('\','/')
    if ($CandidateCommon -ne $CanonicalCommon) { throw "WorktreePath belongs to a different Git common directory: $CandidateCommon" }
    $CandidateRemote = (git -C $Candidate remote get-url origin).Trim().TrimEnd('/')
    if ($CandidateRemote -ne $Repo.Remote) { throw "WorktreePath has unexpected origin: $CandidateRemote" }
    $EffectivePath = $Candidate
}

if (-not (Test-Path $Exe -PathType Leaf)) { throw "Pinned Codex executable missing: $Exe" }
$Hash = (Get-FileHash $Exe -Algorithm SHA256).Hash
if ($Hash -ne $Manifest.codex.sha256) { throw "Pinned Codex executable hash drift: $Hash" }
$Version = (& $Exe --version 2>$null).Trim()
if ($Version -ne $Manifest.codex.version_output) { throw "Pinned Codex version drift: $Version" }
if (-not (Test-Path $Python -PathType Leaf)) { throw "Pinned Python executable missing: $Python" }
$PythonHash = (Get-FileHash $Python -Algorithm SHA256).Hash
if ($PythonHash -ne $Manifest.tooling.python_runtime.sha256) { throw "Pinned Python executable hash drift: $PythonHash" }
$PythonVersion = (& $Python --version 2>&1).Trim()
if ($PythonVersion -ne $Manifest.tooling.python_runtime.version_output) { throw "Pinned Python version drift: $PythonVersion" }

$Top = (git -C $EffectivePath rev-parse --show-toplevel).Trim().Replace('\','/')
$ExpectedTop = $EffectivePath.Replace('\','/')
if ($Top -ne $ExpectedTop) { throw "Unexpected Git root: $Top" }
$Remote = (git -C $EffectivePath remote get-url origin).Trim().TrimEnd('/')
if ($Remote -ne $Repo.Remote) { throw "Unexpected origin: $Remote" }
if (Test-Path (Join-Path $EffectivePath ".codex\config.toml")) {
    throw "Project .codex/config.toml exists and has not been admitted by the Administrator runtime."
}

$env:CODEX_HOME = $AdminHome
if ($Check) {
    Write-Output "ENSEMBLE_ADMIN_PREFLIGHT=PASS"
    Write-Output "LANE=$Lane"
    Write-Output "REPOSITORY=$EffectivePath"
    Write-Output "CANONICAL_REPOSITORY=$($Repo.Path)"
    Write-Output "CODEX_HOME=$AdminHome"
    Write-Output "CODEX_VERSION=$Version"
    Write-Output "CODEX_SHA256=$Hash"
    exit 0
}

$Args = @(
    "--strict-config",
    "--profile", "administrator",
    "--config", 'default_permissions="ensemble-admin-readonly"',
    "--ask-for-approval", "on-request",
    "--disable", "remote_plugin",
    "--disable", "browser_use",
    "--disable", "browser_use_external",
    "--disable", "browser_use_full_cdp_access",
    "--disable", "computer_use",
    "--disable", "hooks",
    "--disable", "memories",
    "--disable", "multi_agent",
    "--disable", "goals",
    "--config", 'forced_login_method="chatgpt"',
    "--config", 'approvals_reviewer="user"',
    "--config", 'allow_login_shell=false',
    "--config", 'windows.sandbox="elevated"',
    "--config", 'web_search="disabled"',
    "--config", 'apps._default.enabled=false',
    "--config", 'apps._default.open_world_enabled=false',
    "--config", 'apps._default.destructive_enabled=false',
    "--config", 'apps.connector_76869538009648d5b282a4bb21c3d157.enabled=true',
    "--config", 'apps.connector_76869538009648d5b282a4bb21c3d157.default_tools_enabled=false',
    "--config", 'apps.connector_76869538009648d5b282a4bb21c3d157.open_world_enabled=false',
    "--config", 'apps.connector_76869538009648d5b282a4bb21c3d157.destructive_enabled=false',
    "--config", 'apps.connector_76869538009648d5b282a4bb21c3d157.tools.fetch.enabled=true',
    "--config", 'apps.connector_76869538009648d5b282a4bb21c3d157.tools.fetch.approval_mode="auto"',
    "--config", 'shell_environment_policy.inherit="core"',
    "--config", 'shell_environment_policy.ignore_default_excludes=false',
    "--config", ('shell_environment_policy.set.ENSEMBLE_PYTHON="' + $PythonEnv + '"'),
    "--config", 'memories.generate_memories=false',
    "--config", 'memories.use_memories=false',
    "--config", 'agents.enabled=false',
    "--config", 'agents.max_concurrent_threads_per_session=1',
    "--cd", $EffectivePath
)
if ($CodexArgs) { $Args += $CodexArgs }
$PreviousErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = "Continue"
try {
    & $Exe @Args
    $CodexExitCode = $LASTEXITCODE
}
finally {
    $ErrorActionPreference = $PreviousErrorActionPreference
}
exit $CodexExitCode