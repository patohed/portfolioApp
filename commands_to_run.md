# Comandos para subir al VPS

## Preparación en Windows (PowerShell)

# Primero, verifica el estado actual de los archivos
git status

# Añade todos los archivos nuevos y modificados
git add .

# Realiza un commit con un mensaje descriptivo
git commit -m "Añadir scripts para solucionar problemas de despliegue en LiteSpeed"

# Sube los cambios a GitHub
git push origin main

## Comandos para ejecutar en el VPS (SSH)

# Navega al directorio de la aplicación
cd /var/www/domains/pmdevop.com/public_html

# Asegúrate de obtener los últimos cambios
git pull

# Haz ejecutables los scripts
chmod +x litespeed_optimized_deploy.sh quick_fix.sh check_next_redirects.sh update_from_github.sh

# Ejecuta el script de diagnóstico rápido primero
./quick_fix.sh

# Si el problema persiste, ejecuta el script de despliegue completo
./litespeed_optimized_deploy.sh

# Verifica el estado de la aplicación
pm2 status
systemctl status lsws
curl -I http://localhost:3000
