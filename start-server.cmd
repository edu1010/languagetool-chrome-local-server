@echo off
setlocal

set "ROOT=%~dp0"
set "SERVER_DIR=%ROOT%server\LanguageTool-6.6"
set "JAR=%SERVER_DIR%\languagetool-server.jar"

if not exist "%JAR%" (
  echo No se encuentra "%JAR%".
  echo Ejecuta primero:
  echo   powershell -ExecutionPolicy Bypass -File "%ROOT%install-server.ps1"
  exit /b 1
)

netstat -ano -p TCP | findstr /R /C:":8081 .*LISTENING" >nul 2>nul
if %ERRORLEVEL% EQU 0 (
  echo LanguageTool ya parece estar escuchando en http://localhost:8081
  exit /b 0
)

where java >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
  echo No se encuentra java en PATH.
  echo Instala Java o usa el script PowerShell si ya tienes Java configurado ahi.
  exit /b 1
)

pushd "%SERVER_DIR%" >nul
start "LanguageTool Server" /min java -jar "%JAR%" --port 8081 --allow-origin
popd >nul

echo LanguageTool arrancando en http://localhost:8081
echo Espera unos segundos y prueba con:
echo   powershell -ExecutionPolicy Bypass -File "%ROOT%test-server.ps1"

endlocal
