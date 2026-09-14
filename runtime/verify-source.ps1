[CmdletBinding()]
param([string]$InstalledRoot='')
$ErrorActionPreference='Stop'
$Here=$PSScriptRoot
$Current=Join-Path $Here 'current'
$ManifestPath=Join-Path $Here 'CURRENT_SOURCE_MANIFEST.json'
if(-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)){ throw 'Runtime source manifest missing.' }
$Manifest=Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json
$Expected=@($Manifest.files.PSObject.Properties.Name | Sort-Object)
$Actual=@(Get-ChildItem -LiteralPath $Current -Recurse -File | ForEach-Object { $_.FullName.Substring($Current.Length+1).Replace('\','/') } | Sort-Object)
if(($Expected -join "`n") -ne ($Actual -join "`n")){ throw 'runtime/current file set differs from source manifest.' }
foreach($prop in $Manifest.files.PSObject.Properties){
  $rel=$prop.Name; $source=Join-Path $Current ($rel -replace '/','\')
  $hash=(Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
  $bytes=(Get-Item -LiteralPath $source).Length
  if($hash -ne $prop.Value.sha256 -or $bytes -ne $prop.Value.bytes){ throw "Source integrity drift: $rel" }
}
Write-Output "SOURCE_FILE_COUNT=$($Expected.Count)"
Write-Output 'SOURCE_HASHES=PASS'
$Forbidden=@('auth.json','sessions','scratch','browser','plugins','.sandbox','.sandbox-secrets','installation_id')
foreach($rel in $Forbidden){ if(Test-Path -LiteralPath (Join-Path $Current $rel)){ throw "Forbidden private runtime state present: $rel" } }
if(@(Get-ChildItem -LiteralPath $Current -Recurse -File -Filter '*.sqlite').Count -ne 0){ throw 'SQLite/private state must not be stored in runtime/current.' }
$ParseErrors=@()
foreach($f in Get-ChildItem -LiteralPath $Current -Recurse -File -Filter '*.ps1'){
  $tokens=$null; $errors=$null
  [Management.Automation.Language.Parser]::ParseFile($f.FullName,[ref]$tokens,[ref]$errors) | Out-Null
  $ParseErrors += @($errors)
}
if($ParseErrors.Count -ne 0){ throw "PowerShell source parse errors: $($ParseErrors.Count)" }
Write-Output 'PRIVATE_STATE_EXCLUSION=PASS'
Write-Output 'POWERSHELL_PARSE=PASS'
if($InstalledRoot){
  $InstalledBase=(Resolve-Path -LiteralPath $InstalledRoot).Path
  foreach($prop in $Manifest.files.PSObject.Properties){
    $rel=$prop.Name; $InstalledFile=Join-Path $InstalledBase ($rel -replace '/','\')
    if(-not (Test-Path -LiteralPath $InstalledFile -PathType Leaf)){ throw "Installed runtime file missing: $rel" }
    if((Get-FileHash -LiteralPath $InstalledFile -Algorithm SHA256).Hash -ne $prop.Value.sha256){ throw "Installed runtime differs from canonical source: $rel" }
  }
  Write-Output 'INSTALLED_BYTE_IDENTITY=PASS'
}
Write-Output 'RYLADMIN_RUNTIME_SOURCE_VERIFY=PASS'
