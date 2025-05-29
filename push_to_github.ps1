# Actualizar cambios en GitHub
# Script simplificado para PowerShell

Write-Host "=== ACTUALIZANDO REPOSITORIO EN GITHUB ===" -ForegroundColor Green

# 1. Verificar si hay cambios
Write-Host "Verificando cambios locales..." -ForegroundColor Yellow
git status

# 2. Confirmar con el usuario
Write-Host "¿Deseas subir todos estos cambios a GitHub? (S/N)" -ForegroundColor Yellow
$confirmar = Read-Host ">> "

if ($confirmar -ne "S" -and $confirmar -ne "s") {
    Write-Host "Operación cancelada por el usuario." -ForegroundColor Red
    exit
}

# 3. Añadir y subir los cambios
Write-Host "Añadiendo archivos modificados..." -ForegroundColor Yellow
git add .

Write-Host "Realizando commit..." -ForegroundColor Yellow
git commit -m "Añadidos scripts de despliegue optimizados para LiteSpeed y solución de problemas"

Write-Host "Subiendo cambios a GitHub..." -ForegroundColor Yellow
git push origin main

# 4. Instrucciones finales
Write-Host "=== PROCESO COMPLETADO ===" -ForegroundColor Green
Write-Host "Los cambios han sido subidos a GitHub."
Write-Host "Para aplicar estos cambios en el VPS, conéctate por SSH y ejecuta:"
Write-Host "cd /var/www/domains/pmdevop.com/public_html" -ForegroundColor Cyan
Write-Host "git pull origin main" -ForegroundColor Cyan
Write-Host "chmod +x litespeed_optimized_deploy.sh" -ForegroundColor Cyan
Write-Host "./litespeed_optimized_deploy.sh" -ForegroundColor Cyan

# Mantener la ventana abierta
Write-Host "`nPresiona cualquier tecla para salir..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
