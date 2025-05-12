#!/bin/bash

# Configuración
PORTFOLIO_DIR="/var/www/portfolio"
LOG_FILE="/var/log/portfolio/security_check.log"

# Crear directorio de logs si no existe
mkdir -p "$(dirname "$LOG_FILE")"

# Función para registrar resultados
log_result() {
    echo "[$(date)] $1" >> "$LOG_FILE"
}

# Verificar permisos de archivos
check_permissions() {
    log_result "Verificando permisos de archivos..."
    
    # Verificar .env
    if [ -f "$PORTFOLIO_DIR/.env" ]; then
        if [ "$(stat -c %a $PORTFOLIO_DIR/.env)" != "600" ]; then
            log_result "ALERTA: Permisos incorrectos en .env"
            chmod 600 "$PORTFOLIO_DIR/.env"
        fi
    fi
    
    # Verificar permisos de directorios
    find "$PORTFOLIO_DIR" -type d -exec chmod 755 {} \;
    find "$PORTFOLIO_DIR" -type f -exec chmod 644 {} \;
    
    # Dar permisos de ejecución a scripts
    chmod +x "$PORTFOLIO_DIR/scripts/"*.sh
}

# Verificar configuración de Nginx
check_nginx() {
    log_result "Verificando configuración de Nginx..."
    nginx -t >> "$LOG_FILE" 2>&1
}

# Verificar archivos sensibles
check_sensitive_files() {
    log_result "Verificando archivos sensibles..."
    
    # Buscar archivos que no deberían estar en producción
    find "$PORTFOLIO_DIR" -type f \( \
        -name "*.log" -o \
        -name "*.bak" -o \
        -name "*.tmp" -o \
        -name ".git*" -o \
        -name ".env.local" -o \
        -name ".env.development" \
    \) -print >> "$LOG_FILE"
}

# Verificar dependencias de seguridad
check_dependencies() {
    log_result "Verificando dependencias..."
    cd "$PORTFOLIO_DIR" || exit
    npm audit >> "$LOG_FILE" 2>&1
}

# Ejecutar todas las verificaciones
log_result "Iniciando verificación de seguridad..."
check_permissions
check_nginx
check_sensitive_files
check_dependencies
log_result "Verificación de seguridad completada"

# Mostrar resultados
echo "Verificación de seguridad completada. Ver resultados en: $LOG_FILE"
