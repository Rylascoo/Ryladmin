param(
    [string]$WorkspaceRoot = (Join-Path $env:USERPROFILE 'Sol Dev'),
    [Parameter(Mandatory=$true)][string]$CodexExe,
    [Parameter(Mandatory=$true)][string]$PythonExe
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$RecoveryRoot = $PSScriptRoot
$Baseline = Get-Content -LiteralPath (Join-Path $RecoveryRoot 'RECOVERY_BASELINE.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$AdminHome = Join-Path $env:USERPROFILE '.codex-ensemble'
$Repos = @(
    @{ Name='Ryladmin'; Path=(Split-Path -Parent $RecoveryRoot); Remote=$Baseline.repositories.admin_continuity; Snapshot=$null },
    @{ Name='Project'; Path=(Join-Path $WorkspaceRoot 'Ensemble-Project'); Remote=$Baseline.repositories.project_authority; Snapshot=$Baseline.snapshot_refs.project_main },
    @{ Name='Website'; Path=(Join-Path $WorkspaceRoot 'Ensemble-Website'); Remote=$Baseline.repositories.design_authority; Snapshot=$Baseline.snapshot_refs.website_main }
)
$Failures = New-Object System.Collections.Generic.List[string]
$Actions = New-Object System.Collections.Generic.List[string]

function Fail([string]$Message) { $script:Failures.Add($Message) }
function Action([string]$Message) { $script:Actions.Add($Message) }
function Require-File([string]$Path) { if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { Fail "Missing file: $Path" } }

if ($env:PROCESSOR_ARCHITECTURE -ne 'ARM64') { Fail "Expected Windows ARM64; observed $env:PROCESSOR_ARCHITECTURE" }
foreach($Repo in $Repos) {
    if (-not (Test-Path -LiteralPath $Repo.Path -PathType Container)) { Fail "Missing repository: $($Repo.Name) $($Repo.Path)"; continue }
    $OriginOutput = & git -C $Repo.Path remote get-url origin 2>$null
    $OriginExit = $LASTEXITCODE
    $Origin = if ($null -eq $OriginOutput) { '' } else { ([string]($OriginOutput | Select-Object -First 1)).Trim().TrimEnd('/') }
    $ExpectedOrigin = ([string]$Repo.Remote).Trim().TrimEnd('/')
    if ($OriginExit -ne 0 -or $Origin -ne $ExpectedOrigin) { Fail "Unexpected origin for $($Repo.Name): $Origin"; continue }
    $RemoteMainOutput = & git -C $Repo.Path ls-remote origin refs/heads/main 2>$null
    $RemoteMainExit = $LASTEXITCODE
    $RemoteMain = if ($null -eq $RemoteMainOutput) { '' } else { [string]($RemoteMainOutput | Select-Object -First 1) }
    if ($RemoteMainExit -ne 0 -or [string]::IsNullOrWhiteSpace($RemoteMain)) { Fail "Cannot resolve live main for $($Repo.Name)" } else { Write-Output ("LIVE_MAIN_{0}={1}" -f $Repo.Name.ToUpperInvariant(),(($RemoteMain -split '\s+')[0])) }
}

$ProjectRoot = Join-Path $WorkspaceRoot 'Ensemble-Project'
foreach($Rel in @('AGENTS.md','CURRENT_STATE.md','docs\PROJECT_EXECUTION_QUEUE.md','docs\blueprint\CODEX_ADMINISTRATOR_RUNTIME_SPECIFICATION.md')) { Require-File (Join-Path $ProjectRoot $Rel) }
if (Test-Path -LiteralPath (Join-Path $ProjectRoot '.codex\config.toml')) { Fail 'Project-local .codex/config.toml is present but is not admitted by the recovered baseline.' }

foreach($Rel in @('AGENTS.md','config.toml','administrator.config.toml','worker.config.toml','bin\ensemble-admin.ps1','bin\ensemble-worker.ps1','bin\ensemble-git-lock.ps1','state\runtime-manifest.json','agents\reviewer.toml','agents\scout.toml','agents\worker.toml')) { Require-File (Join-Path $AdminHome $Rel) }

if (Test-Path -LiteralPath (Join-Path $AdminHome 'config.toml')) {
    $Config = [System.IO.File]::ReadAllText((Join-Path $AdminHome 'config.toml'))
    foreach($Required in @('sandbox_mode = "read-only"','approval_policy = "on-request"','network_access = false','remote_plugins = false','browser = false','computer_use = false','hooks = false','memories = false','multi_agent = false','goals = false','forced_login_method = "chatgpt"')) {
        if (-not $Config.Contains($Required)) { Fail "Recovered config missing fail-closed invariant: $Required" }
    }
}

if (-not (Test-Path -LiteralPath $CodexExe -PathType Leaf)) { Fail "Codex executable missing: $CodexExe" }
else {
    $Version = (& $CodexExe --version 2>$null | Select-Object -First 1).Trim()
    $Hash = (Get-FileHash -LiteralPath $CodexExe -Algorithm SHA256).Hash
    if ($Version -ne $Baseline.tools.codex.version_output) { Fail "Codex version drift: $Version" }
    if ($Hash -ne $Baseline.tools.codex.sha256) { Fail 'Codex binary hash drift.' }
}

if (-not (Test-Path -LiteralPath $PythonExe -PathType Leaf)) { Fail "Python executable missing: $PythonExe" }
else {
    $Version = (& $PythonExe --version 2>&1 | Select-Object -First 1).Trim()
    $Hash = (Get-FileHash -LiteralPath $PythonExe -Algorithm SHA256).Hash
    $Arch = (& $PythonExe -c "import platform; print(platform.machine())" | Select-Object -First 1).Trim()
    if ($Version -ne $Baseline.tools.python.version_output -or $Hash -ne $Baseline.tools.python.sha256 -or $Arch -ne 'ARM64') { Fail "Python realization drift: $Version / $Arch" }
}

foreach($Name in @('ANTHROPIC_API_KEY','AWS_ACCESS_KEY_ID','AWS_SECRET_ACCESS_KEY','GOOGLE_APPLICATION_CREDENTIALS')) {
    $Value = [Environment]::GetEnvironmentVariable($Name)
    if (-not [string]::IsNullOrWhiteSpace($Value)) { Fail "Credential environment route is populated and requires explicit review: $Name" }
}

$Claude = Get-Command claude -ErrorAction SilentlyContinue
if ($null -eq $Claude) { Action 'Claude Code is not installed/on PATH. Reinstall/revalidate only if Claude review capability is needed.' }
else {
    $ClaudeVersion = (& $Claude.Source --version 2>$null | Select-Object -First 1).Trim()
    if ($ClaudeVersion -notmatch [regex]::Escape($Baseline.tools.claude_code.version)) { Action "Claude Code version differs from historical baseline or could not be normalized: $ClaudeVersion" }
    Action 'Verify dedicated .claude-ensemble auth is claude.ai subscription auth before any future Claude use; credentials are intentionally not backed up.'
}
Action ('Authorize Remote Desktop Commander {0} or a separately revalidated successor on this replacement device; historical device IDs are not portable.' -f $Baseline.tools.remote_desktop_commander.version)
Action 'Reconnect the GitHub integration and confirm the recovered Codex connector remains fetch-only before depending on it.'
Action 'Fresh-read owning repository CURRENT_STATE/queue/CI after this verification; snapshot refs in RECOVERY_BASELINE.json are never current authority.'

$RecoveryRepo = Split-Path -Parent $RecoveryRoot
$Tracked = @(git -C $RecoveryRepo ls-files 'recovery/*')
foreach($Rel in $Tracked) {
    if ($Rel -match '(?i)(auth\.json|cookie|credential|token\.json|session\.json|\.sqlite)') { Fail "Forbidden secret/state-like recovery artifact is tracked: $Rel" }
}

if ($Failures.Count -gt 0) {
    foreach($Failure in $Failures) { Write-Output "FAIL=$Failure" }
    foreach($Item in $Actions) { Write-Output "ACTION_REQUIRED=$Item" }
    Write-Output 'RECOVERY_VERIFICATION=FAIL'
    exit 1
}
foreach($Item in $Actions) { Write-Output "ACTION_REQUIRED=$Item" }
Write-Output 'RECOVERY_CORE_SAFETY=PASS'
Write-Output 'RECOVERY_VERIFICATION=PASS_WITH_INTERACTIVE_ACTIONS'
