#!/bin/bash

# Script de diagnóstico completo para problemas de página en blanco y redirección
# Ejecutar como root en el servidor VPS

echo "=== DIAGNÓSTICO COMPLETO DEL SERVIDOR ==="
echo "Fecha y hora: $(date)"
echo "Hostname: $(hostname)"
echo "IP: $(hostname -I | awk '{print $1}')"
echo ""

# 1. Verificar recursos del sistema
echo "=== RECURSOS DEL SISTEMA ==="
echo "Memoria disponible:"
free -h
echo ""
echo "Uso de disco:"
df -h
echo ""
echo "Carga del sistema:"
uptime
echo ""

# 2. Verificar procesos y puertos
echo "=== PROCESOS Y PUERTOS ==="
echo "Procesos Node.js ejecutándose:"
ps aux | grep node
echo ""
echo "Procesos PM2 ejecutándose:"
pm2 list
echo ""
echo "Puertos en uso:"
netstat -tulpn | grep -E ':80|:443|:3000'
echo ""

# 3. Verificar configuración de LiteSpeed
echo "=== CONFIGURACIÓN DE LITESPEED ==="
echo "Estado de LiteSpeed:"
systemctl status lsws | grep -E 'Active|running|exited|failed'
echo ""
echo "Configuración de host virtual:"
cat /usr/local/lsws/conf/vhosts/pmdevop.com/vhconf.conf
echo ""

# 4. Revisar reglas de redirección
echo "=== REGLAS DE REDIRECCIÓN ==="
grep -r -A 10 "rewrite" /usr/local/lsws/conf/vhosts/pmdevop.com/
echo ""

# 5. Verificar logs
echo "=== LOGS ==="
echo "Últimas 20 líneas del log de errores de LiteSpeed:"
tail -n 20 /usr/local/lsws/logs/error.log
echo ""
echo "Últimas 20 líneas del log de PM2:"
pm2 logs --lines 20
echo ""

# 6. Verificar configuración DNS
echo "=== CONFIGURACIÓN DNS ==="
echo "Resolución DNS para pmdevop.com:"
nslookup pmdevop.com
echo ""
echo "Ping a pmdevop.com:"
ping -c 4 pmdevop.com
echo ""

# 7. Prueba de conectividad
echo "=== PRUEBA DE CONECTIVIDAD ==="
echo "Intentando conectar a localhost:3000:"
curl -I http://localhost:3000
echo ""
echo "Intentando conectar a la URL pública:"
curl -I http://pmdevop.com
echo ""

# 8. Solución recomendada
echo "=== SOLUCIÓN RECOMENDADA ==="
echo "Basado en los diagnósticos anteriores, intentemos una solución definitiva:"
echo ""
echo "1. Deteniendo todos los procesos de Next.js/PM2:"
pm2 delete all
echo ""

echo "2. Reinstalando la aplicación desde cero:"
cd /var/www/domains/pmdevop.com/public_html
git pull origin main
npm install
npm run build
echo ""

echo "3. Creando configuración de LiteSpeed limpia y definitiva:"
cat > /tmp/vhconf_clean.conf << 'EOL'
docRoot                   $VH_ROOT/public_html
vhDomain                  pmdevop.com,www.pmdevop.com
adminEmails               admin@pmdevop.com
enableGzip                1

index {
    useServer             0
    indexFiles            index.html
    autoIndex             0
}

# Sin reglas de redirección por ahora, para evitar bucles
# rewrite {
#    enable                1
#    rules                 <<END_RULES
#    rewrite ^/lander(.*)$ / [R=301,L]
#    END_RULES
# }

# Configuración de proxy clara y simple
context / {
    type                  proxy
    handler               localhost:3000
    addDefaultCharset     off
    proxyWebSocket        1
}

# Configuración de archivos estáticos
context /_next/static {
    location             $VH_ROOT/public_html/.next/static
    allowBrowse          1
    expires              365d
}

context /static {
    location             $VH_ROOT/public_html/public
    allowBrowse          1
    expires              30d
}

errorlog $SERVER_ROOT/logs/$VH_NAME/error.log {
    useServer             1
    logLevel              ERROR
    rollingSize           10M
}

accesslog $SERVER_ROOT/logs/$VH_NAME/access.log {
    useServer             0
    logFormat             "%h %l %u %t \"%r\" %>s %b"
    logHeaders            5
    rollingSize           10M
    keepDays              10
}

extrapaths {
    path                 logs/$VH_NAME/
}
EOL
echo ""

echo "¿Quieres aplicar esta solución limpia? (s/n)"
read -p ">> " respuesta

if [ "$respuesta" = "s" ]; then
    echo "Aplicando solución..."
    
    # Actualizar configuración de LiteSpeed
    cp /tmp/vhconf_clean.conf /usr/local/lsws/conf/vhosts/pmdevop.com/vhconf.conf
    systemctl restart lsws
    
    # Iniciar la aplicación con PM2
    cd /var/www/domains/pmdevop.com/public_html
    pm2 start ecosystem.config.js
    pm2 save
    
    echo ""
    echo "Solución aplicada. Verificando estado:"
    systemctl status lsws | grep Active
    pm2 status
    
    echo ""
    echo "Intenta acceder a https://pmdevop.com ahora sin /lander"
    echo "Si sigues teniendo problemas, considera estas opciones adicionales:"
    echo "1. Verificar si hay reglas de redirección a nivel de hosting/servidor"
    echo "2. Probar con un servidor Nginx en lugar de LiteSpeed"
    echo "3. Verificar si hay problemas de caché del navegador (prueba en modo incógnito)"
else
    echo "Solución no aplicada. Puedes ejecutar este script nuevamente cuando estés listo."
fi

echo ""
echo "=== FIN DEL DIAGNÓSTICO ==="
