#!/bin/bash

# Configuración
BACKUP_DIR="/var/backups/portfolio"
DATE=$(date +"%Y%m%d_%H%M%S")
MAX_BACKUPS=7

# Crear directorio de respaldo si no existe
mkdir -p "$BACKUP_DIR"

# Respaldar archivos de configuración
tar -czf "$BACKUP_DIR/config_$DATE.tar.gz" \
    --exclude="node_modules" \
    --exclude=".next" \
    .env \
    nginx/ \
    certbot/ \
    docker-compose.yml

# Respaldar los volúmenes de Docker
docker run --rm \
    -v portfolio_certbot:/certbot \
    -v "$BACKUP_DIR:/backup" \
    alpine tar -czf "/backup/volumes_$DATE.tar.gz" /certbot

# Eliminar respaldos antiguos
cd "$BACKUP_DIR" || exit
ls -t config_*.tar.gz | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm
ls -t volumes_*.tar.gz | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm

echo "Backup completed: config_$DATE.tar.gz and volumes_$DATE.tar.gz"
