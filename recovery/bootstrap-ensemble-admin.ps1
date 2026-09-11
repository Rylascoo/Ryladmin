param(
    [string]$WorkspaceRoot = (Join-Path $env:USERPROFILE 'Sol Dev'),
    [Parameter(Mandatory=$true)][string]$CodexExe,
    [Parameter(Mandatory=$true)][string]$PythonExe,
    [string]$GitHubConnectorId = '',
    [switch]$Apply
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$RecoveryRoot = $PSScriptRoot
$TemplateRoot = Join-Path $RecoveryRoot 'templates\runtime'
$BaselinePath = Join-Path $RecoveryRoot 'RECOVERY_BASELINE.json'
$Baseline = Get-Content -LiteralPath $BaselinePath -Raw -Encoding UTF8 | ConvertFrom-Json
$AdminHome = Join-Path $env:USERPROFILE '.codex-ensemble'
$ProjectRoot = Join-Path $WorkspaceRoot 'Ensemble-Project'
$WebsiteRoot = Join-Path $WorkspaceRoot 'Ensemble-Website'
$RyladminRoot = Split-Path -Parent $RecoveryRoot

function Write-Utf8NoBom([string]$Path, [string]$Content) {
    $Encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $Encoding)
}

function Assert-ExactOrWrite([string]$Path, [string]$Content) {
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        $Existing = [System.IO.File]::ReadAllText($Path)
        if ($Existing -ne $Content) { throw "Existing recovery target differs; refusing overwrite: $Path" }
        return
    }
    Write-Utf8NoBom -Path $Path -Content $Content
}

function Assert-RepoOrPlan([string]$Path, [string]$Remote) {
    if (Test-Path -LiteralPath $Path -PathType Container) {
        $OriginOutput = & git -C $Path remote get-url origin 2>$null
        $GitExit = $LASTEXITCODE
        if ($GitExit -ne 0 -or $null -eq $OriginOutput) { throw "Cannot read repository origin: $Path" }
        $Observed = ([string]($OriginOutput | Select-Object -First 1)).Trim().TrimEnd('/')
        $Expected = ([string]$Remote).Trim().TrimEnd('/')
        if ($Observed -ne $Expected) { throw "Existing repository has unexpected origin: $Path -> $Observed" }
        Write-Output "REPOSITORY_PRESENT=$Path"
        return
    }
    Write-Output "REPOSITORY_MISSING=$Path"
    if ($Apply) {
        $Parent = Split-Path -Parent $Path
        $null = New-Item -ItemType Directory -Force -Path $Parent
        & git clone $Remote $Path
        if ($LASTEXITCODE -ne 0) { throw "Clone failed: $Remote" }
    }
}

$Arch = $env:PROCESSOR_ARCHITECTURE
if ($Arch -ne 'ARM64') { throw "Recovery baseline requires Windows ARM64; observed PROCESSOR_ARCHITECTURE=$Arch" }
if (-not (Test-Path -LiteralPath $CodexExe -PathType Leaf)) { throw "Codex executable not found: $CodexExe" }
if (-not (Test-Path -LiteralPath $PythonExe -PathType Leaf)) { throw "Python executable not found: $PythonExe" }

$CodexVersion = (& $CodexExe --version 2>$null | Select-Object -First 1).Trim()
$CodexHash = (Get-FileHash -LiteralPath $CodexExe -Algorithm SHA256).Hash
if ($CodexVersion -ne $Baseline.tools.codex.version_output) { throw "Codex version drift requires revalidation. Expected '$($Baseline.tools.codex.version_output)'; got '$CodexVersion'." }
if ($CodexHash -ne $Baseline.tools.codex.sha256) { throw "Codex binary hash drift requires revalidation." }

$PythonVersion = (& $PythonExe --version 2>&1 | Select-Object -First 1).Trim()
$PythonHash = (Get-FileHash -LiteralPath $PythonExe -Algorithm SHA256).Hash
$PythonArch = (& $PythonExe -c "import platform; print(platform.machine())" | Select-Object -First 1).Trim()
if ($PythonVersion -ne $Baseline.tools.python.version_output -or $PythonArch -ne $Baseline.tools.python.architecture -or $PythonHash -ne $Baseline.tools.python.sha256) { throw "Python realization drift requires revalidation." }

Assert-RepoOrPlan -Path $RyladminRoot -Remote $Baseline.repositories.admin_continuity
Assert-RepoOrPlan -Path $ProjectRoot -Remote $Baseline.repositories.project_authority
Assert-RepoOrPlan -Path $WebsiteRoot -Remote $Baseline.repositories.design_authority

Write-Output "RECOVERY_PLATFORM=PASS"
Write-Output "CODEX_REALIZATION=PASS $CodexVersion"
Write-Output "PYTHON_REALIZATION=PASS $PythonVersion $PythonArch"
Write-Output "PROJECT_ROOT=$ProjectRoot"
Write-Output "WEBSITE_ROOT=$WebsiteRoot"
Write-Output "ADMIN_HOME=$AdminHome"

if (-not $Apply) {
    Write-Output 'RECOVERY_BOOTSTRAP=PLAN_ONLY'
    Write-Output 'Re-run with -Apply only after reviewing the paths and tool checks above.'
    exit 0
}

foreach($Dir in @($AdminHome,(Join-Path $AdminHome 'bin'),(Join-Path $AdminHome 'agents'),(Join-Path $AdminHome 'state'),(Join-Path $AdminHome 'sessions'),(Join-Path $AdminHome 'locks'))) {
    $null = New-Item -ItemType Directory -Force -Path $Dir
}

$ConfigTemplate = [System.IO.File]::ReadAllText((Join-Path $TemplateRoot 'config.toml.in'))
if ($ProjectRoot.Contains("'")) { throw 'Project path containing an apostrophe is not supported by this recovery renderer.' }
$McpBlock = ''
if (-not [string]::IsNullOrWhiteSpace($GitHubConnectorId)) {
    if ($GitHubConnectorId -notmatch '^[A-Za-z0-9_-]+$') { throw 'GitHubConnectorId contains unexpected characters.' }
    $McpBlock = @"
[mcp_servers.ensemble_github]
url = "https://mcp.openai.com/github/$GitHubConnectorId"
required = false
enabled = true
startup_timeout_sec = 20
tool_timeout_sec = 30
subagent_allowed = false
allowed_tools = ["fetch"]
"@
} else {
    Write-Output 'ACTION_REQUIRED=Reconnect GitHub integration later; recovered Codex config will contain no GitHub MCP block.'
}
$RenderedConfig = $ConfigTemplate.Replace('__PROJECT_ROOT__',$ProjectRoot).Replace('__GITHUB_MCP_BLOCK__',$McpBlock.TrimEnd())
Assert-ExactOrWrite -Path (Join-Path $AdminHome 'config.toml') -Content $RenderedConfig

foreach($Rel in @('AGENTS.md','administrator.config.toml','worker.config.toml','bin\ensemble-git-lock.ps1','agents\reviewer.toml','agents\scout.toml','agents\worker.toml')) {
    $Source = Join-Path $TemplateRoot $Rel
    $Target = Join-Path $AdminHome $Rel
    $Parent = Split-Path -Parent $Target
    $null = New-Item -ItemType Directory -Force -Path $Parent
    Assert-ExactOrWrite -Path $Target -Content ([System.IO.File]::ReadAllText($Source))
}

$AdminTemplate = [System.IO.File]::ReadAllText((Join-Path $TemplateRoot 'bin\ensemble-admin.ps1.in'))
$RenderedAdmin = $AdminTemplate.Replace('__PROJECT_ROOT__',$ProjectRoot).Replace('__CODEX_EXE__',$CodexExe).Replace('__CODEX_VERSION__',$Baseline.tools.codex.version_output)
Assert-ExactOrWrite -Path (Join-Path $AdminHome 'bin\ensemble-admin.ps1') -Content $RenderedAdmin

$WorkerTemplate = [System.IO.File]::ReadAllText((Join-Path $TemplateRoot 'bin\ensemble-worker.ps1.in'))
Assert-ExactOrWrite -Path (Join-Path $AdminHome 'bin\ensemble-worker.ps1') -Content $WorkerTemplate

$Files = [ordered]@{}
foreach($Rel in @('config.toml','administrator.config.toml','worker.config.toml','AGENTS.md','bin/ensemble-admin.ps1','bin/ensemble-worker.ps1','bin/ensemble-git-lock.ps1','agents/reviewer.toml','agents/scout.toml','agents/worker.toml')) {
    $NativeRel = $Rel.Replace('/',[IO.Path]::DirectorySeparatorChar)
    $Files[$Rel] = (Get-FileHash -LiteralPath (Join-Path $AdminHome $NativeRel) -Algorithm SHA256).Hash
}

$Manifest = [ordered]@{
    schema = 'ensemble.codex-administrator-runtime.recovered.v1'
    baseline_verified_on = $Baseline.verified_on
    recovery_baseline = 'Rylascoo/Ryladmin/recovery/RECOVERY_BASELINE.json'
    platform = [ordered]@{ os='Windows'; architecture='ARM64' }
    codex = [ordered]@{ executable=$CodexExe; version_output=$CodexVersion; sha256=$CodexHash }
    repositories = [ordered]@{
        project = [ordered]@{ path=$ProjectRoot; remote=$Baseline.repositories.project_authority }
        website = [ordered]@{ path=$WebsiteRoot; remote=$Baseline.repositories.design_authority }
        ryladmin = [ordered]@{ path=$RyladminRoot; remote=$Baseline.repositories.admin_continuity }
    }
    tooling = [ordered]@{ python_runtime=[ordered]@{ executable=$PythonExe; version_output=$PythonVersion; architecture=$PythonArch; sha256=$PythonHash } }
    files = $Files
    credentials_restored = $false
    authority_notice = 'Recovered local realization only; fresh owning-repository authority is required before work.'
}

$ManifestJson = $Manifest | ConvertTo-Json -Depth 8
Assert-ExactOrWrite -Path (Join-Path $AdminHome 'state\runtime-manifest.json') -Content $ManifestJson

if (Test-Path -LiteralPath (Join-Path $ProjectRoot '.codex\config.toml')) { throw 'Project-local .codex/config.toml exists and is not admitted by the recovered baseline.' }

Write-Output 'RECOVERY_RUNTIME_RENDER=PASS'
Write-Output 'ACTION_REQUIRED=Authenticate Codex/ChatGPT interactively; no auth material was restored.'
Write-Output 'ACTION_REQUIRED=Reauthorize Remote Desktop Commander on this machine before remote operation.'
Write-Output 'ACTION_REQUIRED=Reauthenticate dedicated Claude Pro only if Claude review capability will be used; do not create/copy an API key.'
Write-Output 'ACTION_REQUIRED=Run verify-recovery.ps1, then fresh-read Project/Website authority before resuming work.'
Write-Output 'RECOVERY_BOOTSTRAP=APPLIED_FAIL_CLOSED'
