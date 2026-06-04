$ErrorActionPreference = "Stop"

$body = "language=es&text=Esto es una prueva con un error."
$response = Invoke-WebRequest `
    -Uri "http://localhost:8081/v2/check" `
    -Method Post `
    -ContentType "application/x-www-form-urlencoded" `
    -Body $body

$json = $response.Content | ConvertFrom-Json
"Servidor OK. Coincidencias detectadas: $($json.matches.Count)"
$json.matches | Select-Object -First 5 `
    @{Name="Regla"; Expression={$_.rule.id}},
    @{Name="Mensaje"; Expression={$_.message}},
    @{Name="Sugerencias"; Expression={($_.replacements | Select-Object -First 3 -ExpandProperty value) -join ", "}} |
    Format-Table -AutoSize
