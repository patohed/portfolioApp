#!/bin/bash

# Configuración
BACKUP_DIR="/var/backups/portfolio"
APP_DIR="/var/www/portfolio"
DATE=$(date +"%Y%m%d_%H%M%S")
MAX_BACKUPS=7

# Crear directorio de respaldo si no existe
mkdir -p "$BACKUP_DIR"

# Crear respaldo
tar -czf "$BACKUP_DIR/portfolio_$DATE.tar.gz" \
    --exclude="node_modules" \
    --exclude=".next" \
    "$APP_DIR"

# Crear respaldo de variables de entorno
cp "$APP_DIR/.env" "$BACKUP_DIR/env_$DATE.backup"

# Eliminar respaldos antiguos (mantener solo los últimos MAX_BACKUPS)
cd "$BACKUP_DIR" || exit
ls -t portfolio_*.tar.gz | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm
ls -t env_*.backup | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm

# Imprimir confirmación
echo "Backup completed: portfolio_$DATE.tar.gz"
echo "Env backup completed: env_$DATE.backup"
