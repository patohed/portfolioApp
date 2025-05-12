#!/bin/bash

# Configuración
ALERT_EMAIL="admin@yourdomain.com"
LOG_FILE="/var/log/portfolio/monitoring.log"
THRESHOLD_CPU=80
THRESHOLD_MEMORY=80
THRESHOLD_DISK=90

# Crear directorio de logs si no existe
mkdir -p "$(dirname "$LOG_FILE")"

# Función para enviar alertas
send_alert() {
    echo "[$(date)] ALERT: $1" >> "$LOG_FILE"
    echo "$1" | mail -s "Portfolio Monitor Alert" "$ALERT_EMAIL"
}

# Verificar CPU
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1)
if [ "$CPU_USAGE" -gt "$THRESHOLD_CPU" ]; then
    send_alert "High CPU usage: $CPU_USAGE%"
fi

# Verificar memoria
MEMORY_USAGE=$(free | grep Mem | awk '{print ($3/$2 * 100)}' | cut -d. -f1)
if [ "$MEMORY_USAGE" -gt "$THRESHOLD_MEMORY" ]; then
    send_alert "High memory usage: $MEMORY_USAGE%"
fi

# Verificar espacio en disco
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | cut -d% -f1)
if [ "$DISK_USAGE" -gt "$THRESHOLD_DISK" ]; then
    send_alert "High disk usage: $DISK_USAGE%"
fi

# Verificar si la aplicación está funcionando
if ! curl -s http://localhost:3000/api/health > /dev/null; then
    send_alert "Application is not responding"
    # Intentar reiniciar la aplicación
    pm2 restart portfolio
fi

# Registrar estado normal
echo "[$(date)] Status check completed - All systems normal" >> "$LOG_FILE"
