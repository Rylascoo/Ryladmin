param(
    [Parameter(Mandatory=$true)][ValidateSet("Project","Website")][string]$Lane,
    [Parameter(Mandatory=$true)][string]$WorktreePath,
    [Parameter(Mandatory=$true)][ValidatePattern("^[0-9a-fA-F]{40}$")][string]$ExpectedHead,
    [switch]$Check,
    [Parameter(ValueFromRemainingArguments=$true)][string[]]$CodexArgs
)
$ErrorActionPreference = "Stop"
$AdminHome = "C:\Users\Wiryl\.codex-ensemble"
$ManifestPath = Join-Path $AdminHome "state\runtime-manifest.json"
$Manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json
$Exe = $Manifest.codex.executable
$Python = $Manifest.tooling.python_runtime.executable
$Repos = @{
    Project = @{ Path = "C:\Users\Wiryl\Sol Dev\Ensemble-Project"; Remote = "https://github.com/Rylascoo/Ensemble-Project" }
    Website = @{ Path = "C:\Users\Wiryl\Sol Dev\Ensemble-Website"; Remote = "https://github.com/Rylascoo/Ensemble-Website" }
}
$Repo = $Repos[$Lane]
$Candidate = (Resolve-Path $WorktreePath).Path
if ($Candidate -eq (Resolve-Path $Repo.Path).Path) { throw "Worker requires an isolated linked worktree, not the canonical repository root." }
$Top = (git -C $Candidate rev-parse --show-toplevel).Trim().Replace('\','/')
if ($Top -ne $Candidate.Replace('\','/')) { throw "WorktreePath must name the exact worktree root: $Top" }
$CanonicalCommon = (git -C $Repo.Path rev-parse --path-format=absolute --git-common-dir).Trim().Replace('\','/')
$CandidateCommon = (git -C $Candidate rev-parse --path-format=absolute --git-common-dir).Trim().Replace('\','/')
if ($CandidateCommon -ne $CanonicalCommon) { throw "WorktreePath belongs to a different Git common directory: $CandidateCommon" }
$Remote = (git -C $Candidate remote get-url origin).Trim().TrimEnd('/')
if ($Remote -ne $Repo.Remote) { throw "WorktreePath has unexpected origin: $Remote" }
$Branch = (git -C $Candidate branch --show-current).Trim()
if (-not $Branch) { throw "Worker refuses detached worktrees." }
$Head = (git -C $Candidate rev-parse HEAD).Trim().ToLowerInvariant()
if ($Head -ne $ExpectedHead.ToLowerInvariant()) { throw "Worker HEAD mismatch: expected $ExpectedHead; found $Head" }
$Dirty = @(git -C $Candidate status --porcelain)
if ($Dirty.Count -ne 0) { throw "Worker requires a clean dispatch baseline; found $($Dirty.Count) status entries." }
if (Test-Path (Join-Path $Candidate ".codex\config.toml")) { throw "Project .codex/config.toml exists and has not been admitted for Worker execution." }
if (-not (Test-Path $Exe -PathType Leaf)) { throw "Pinned Codex executable missing: $Exe" }
if ((Get-FileHash $Exe -Algorithm SHA256).Hash -ne $Manifest.codex.sha256) { throw "Pinned Codex executable hash drift." }
$Version = (& $Exe --version 2>$null).Trim()
if ($Version -ne $Manifest.codex.version_output) { throw "Pinned Codex version drift: $Version" }
if (-not (Test-Path $Python -PathType Leaf)) { throw "Pinned Python executable missing: $Python" }
if ((Get-FileHash $Python -Algorithm SHA256).Hash -ne $Manifest.tooling.python_runtime.sha256) { throw "Pinned Python executable hash drift." }
$PythonVersion = (& $Python --version 2>&1).Trim()
if ($PythonVersion -ne $Manifest.tooling.python_runtime.version_output) { throw "Pinned Python version drift: $PythonVersion" }
$ProfilePath = Join-Path $AdminHome "worker.config.toml"
if (-not (Test-Path $ProfilePath -PathType Leaf)) { throw "Worker profile missing: $ProfilePath" }
if ((Get-FileHash $ProfilePath -Algorithm SHA256).Hash -ne $Manifest.files.'worker.config.toml') { throw "Worker profile hash drift." }
if ((Get-FileHash $PSCommandPath -Algorithm SHA256).Hash -ne $Manifest.files.'bin/ensemble-worker.ps1') { throw "Worker launcher hash drift." }
if ((Get-FileHash (Join-Path $AdminHome 'config.toml') -Algorithm SHA256).Hash -ne $Manifest.files.'config.toml') { throw "Runtime config hash drift." }
$env:CODEX_HOME = $AdminHome
$env:ENSEMBLE_PYTHON = $Python.Replace('\','/')
if ($Check) {
    Write-Output "ENSEMBLE_WORKER_PREFLIGHT=PASS"
    Write-Output "LANE=$Lane"
    Write-Output "WORKTREE=$Candidate"
    Write-Output "BRANCH=$Branch"
    Write-Output "HEAD=$Head"
    Write-Output "CODEX_VERSION=$Version"
    Write-Output "PYTHON_VERSION=$PythonVersion"
    exit 0
}
$Args = @(
    "--strict-config",
    "--profile", "worker",
    "--config", 'default_permissions="ensemble-worker-workspace"',
    "--ask-for-approval", "never",
    "--disable", "remote_plugin",
    "--disable", "browser_use",
    "--disable", "browser_use_external",
    "--disable", "browser_use_full_cdp_access",
    "--disable", "computer_use",
    "--disable", "hooks",
    "--disable", "memories",
    "--disable", "multi_agent",
    "--disable", "goals",
    "--config", 'features.apps=false',
    "--config", 'apps._default.enabled=false',
    "--config", 'apps.connector_76869538009648d5b282a4bb21c3d157.enabled=false',
    "--config", 'forced_login_method="chatgpt"',
    "--config", 'allow_login_shell=false',
    "--config", 'web_search="disabled"',
    "--config", 'shell_environment_policy.inherit="core"',
    "--config", 'shell_environment_policy.ignore_default_excludes=false',
    "--config", ('shell_environment_policy.set.ENSEMBLE_PYTHON="' + $env:ENSEMBLE_PYTHON + '"'),
    "--config", 'memories.generate_memories=false',
    "--config", 'memories.use_memories=false',
    "--config", 'agents.enabled=false',
    "--config", 'agents.max_concurrent_threads_per_session=1',
    "--cd", $Candidate
)
if ($CodexArgs) { $Args += $CodexArgs }
$PreviousErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = "Continue"
try { & $Exe @Args; $CodexExitCode = $LASTEXITCODE }
finally { $ErrorActionPreference = $PreviousErrorActionPreference }
exit $CodexExitCode