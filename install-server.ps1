$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$serverRoot = Join-Path $root "server"
$zipPath = Join-Path $serverRoot "LanguageTool-stable.zip"
$serverDir = Join-Path $serverRoot "LanguageTool-6.6"

New-Item -ItemType Directory -Force -Path $serverRoot | Out-Null

if (-not (Test-Path -LiteralPath $zipPath)) {
    "Descargando LanguageTool estable..."
    curl.exe -L --fail --retry 3 -o $zipPath "https://languagetool.org/download/LanguageTool-stable.zip"
}

if (-not (Test-Path -LiteralPath $serverDir)) {
    "Descomprimiendo servidor..."
    Expand-Archive -LiteralPath $zipPath -DestinationPath $serverRoot -Force
}

"Servidor instalado en $serverDir"
