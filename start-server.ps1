$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$serverDir = Join-Path $root "server\LanguageTool-6.6"
$jarPath = Join-Path $serverDir "languagetool-server.jar"
$pidFile = Join-Path $root "server\languagetool-server.pid"
$outLog = Join-Path $root "server\languagetool-server.out.log"
$errLog = Join-Path $root "server\languagetool-server.err.log"
$javaPath = (Get-Command java).Source

if (-not (Test-Path -LiteralPath $jarPath)) {
    throw "No se encuentra $jarPath. Descarga/descomprime LanguageTool primero."
}

$existing = Get-NetTCPConnection -LocalPort 8081 -State Listen -ErrorAction SilentlyContinue
if ($existing) {
    "LanguageTool parece estar escuchando ya en http://localhost:8081"
    return
}

$processInfo = New-Object System.Diagnostics.ProcessStartInfo
$processInfo.FileName = $javaPath
$processInfo.Arguments = "-jar `"$jarPath`" --port 8081 --allow-origin"
$processInfo.WorkingDirectory = $serverDir
$processInfo.UseShellExecute = $true
$processInfo.CreateNoWindow = $true

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $processInfo
$null = $process.Start()

$process.Id | Set-Content -LiteralPath $pidFile -Encoding ASCII
"LanguageTool arrancado en http://localhost:8081 con PID $($process.Id)"
