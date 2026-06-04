$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$extensionPath = Join-Path $root "extension\webextension-mv3"
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$profileDir = Join-Path $root "chrome-profile-languagetool"

if (-not (Test-Path -LiteralPath $chrome)) {
    throw "No se encuentra Chrome en $chrome"
}

if (-not (Test-Path -LiteralPath (Join-Path $extensionPath "manifest.json"))) {
    throw "No se encuentra la extension en $extensionPath"
}

New-Item -ItemType Directory -Force -Path $profileDir | Out-Null

$processInfo = New-Object System.Diagnostics.ProcessStartInfo
$processInfo.FileName = $chrome
$processInfo.Arguments = "--user-data-dir=`"$profileDir`" --disable-extensions-except=`"$extensionPath`" --load-extension=`"$extensionPath`" https://example.com"
$processInfo.UseShellExecute = $true

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $processInfo
$null = $process.Start()
"Chrome abierto con la extension MV3 desde $extensionPath"
