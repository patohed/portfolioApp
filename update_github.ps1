# Script para actualizar el repositorio en GitHub desde Windows
# Ejecutar en PowerShell

Write-Host "=== ACTUALIZANDO REPOSITORIO EN GITHUB ===" -ForegroundColor Green

# 1. Verificar si hay cambios
Write-Host "Verificando cambios locales..." -ForegroundColor Yellow
git status

# 2. Preguntar por un mensaje de commit
Write-Host "Ingresa un mensaje para el commit:" -ForegroundColor Yellow
$commit_message = Read-Host ">> "

if ([string]::IsNullOrEmpty($commit_message)) {
  $commit_message = "Actualización de scripts de despliegue y configuración para LiteSpeed"
  Write-Host "Usando mensaje por defecto: $commit_message" -ForegroundColor Yellow
}

# 3. Añadir todos los cambios
Write-Host "Añadiendo archivos modificados..." -ForegroundColor Yellow
git add .

# 4. Realizar commit
Write-Host "Realizando commit..." -ForegroundColor Yellow
git commit -m $commit_message

# 5. Push a GitHub
Write-Host "Subiendo cambios a GitHub..." -ForegroundColor Yellow
git push origin main

Write-Host "=== PROCESO COMPLETADO ===" -ForegroundColor Green
Write-Host "Los cambios han sido subidos a GitHub."
Write-Host "Ahora puedes desplegar los cambios en el VPS ejecutando:"
Write-Host "./litespeed_optimized_deploy.sh"

# Mantener la ventana abierta
Write-Host "`nPresiona cualquier tecla para salir..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
