param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Project","Website")]
    [string]$Lane,
    [Parameter(Mandatory=$true)][string]$WorktreePath,
    [Parameter(Mandatory=$true)][string]$StartGate
)

$ErrorActionPreference = "Stop"
while (-not (Test-Path -LiteralPath $StartGate -PathType Leaf)) {
    Start-Sleep -Milliseconds 25
}

& 'C:\Users\Wiryl\.codex-ensemble\bin\ensemble-admin.ps1' `
    -Lane $Lane -WorktreePath $WorktreePath `
    --config 'model_reasoning_effort="high"' exec -
exit $LASTEXITCODE
