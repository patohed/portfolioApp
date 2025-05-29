#!/bin/bash

# Script para verificar y configurar correctamente el proxy inverso en LiteSpeed
# Ejecutar como root en el servidor VPS

echo "=== Verificando la configuración del proxy inverso en LiteSpeed ==="

# 1. Verificar la configuración actual
echo "Configuración actual de LiteSpeed:"
cat /usr/local/lsws/conf/vhosts/pmdevop.com/vhconf.conf

# 2. Verificar si la aplicación está corriendo en el puerto 3000
echo "Verificando si la aplicación está escuchando en el puerto 3000:"
netstat -tulpn | grep :3000

# 3. Verificar la configuración del proxy en LiteSpeed
echo "Verificando la configuración del proxy:"
grep -A 5 "context /" /usr/local/lsws/conf/vhosts/pmdevop.com/vhconf.conf

# 4. Crear una configuración actualizada para LiteSpeed con proxy correcto
echo "Creando configuración actualizada para LiteSpeed..."
cat > /tmp/vhconf.conf << 'EOL'
docRoot                   $VH_ROOT/public_html
vhDomain                  pmdevop.com,www.pmdevop.com
adminEmails               admin@pmdevop.com
enableGzip                1

index {
    useServer             0
    indexFiles            index.html
    autoIndex             0
}

rewrite {
    enable                1
    rules                 <<END_RULES
    rewrite ^/lander(.*)$ / [R=301,L]
    END_RULES
}

# Configuración de proxy principal - crucial para redirigir puerto 80 → 3000
context / {
    type                  proxy
    handler               localhost:3000
    addDefaultCharset     off
    # Configuración importante para el proxy inverso
    location              $VH_ROOT/public_html
    extraHeaders          Header set X-Proxied-By "LiteSpeed"
    # Asegurar que las cookies y encabezados se pasen correctamente
    proxyWebSocket        1
}

context /_next/static {
    location             $VH_ROOT/public_html/.next/static
    allowBrowse          1
    expires              365d
    extraHeaders         Header set Access-Control-Allow-Origin "*"
    extraHeaders         Header set Cache-Control "public, max-age=31536000, immutable"
}

context /static {
    location             $VH_ROOT/public_html/public
    allowBrowse          1
    expires              30d
    extraHeaders         Header set Access-Control-Allow-Origin "*"
    extraHeaders         Header set Cache-Control "public, max-age=2592000"
}

# Importante para las imágenes de Next.js
context /_next/image {
    type                 proxy
    handler              localhost:3000
    addDefaultCharset    off
    extraHeaders         Header set Access-Control-Allow-Origin "*"
}

# Para otros recursos de Next.js
context /_next {
    type                 proxy
    handler              localhost:3000
    addDefaultCharset    off
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

# 5. Aplicar la configuración actualizada
echo "¿Deseas aplicar esta configuración? (s/n)"
read -p ">> " respuesta

if [ "$respuesta" = "s" ]; then
    echo "Aplicando configuración actualizada..."
    cp /tmp/vhconf.conf /usr/local/lsws/conf/vhosts/pmdevop.com/vhconf.conf
    systemctl restart lsws
    
    echo "Reiniciando la aplicación Next.js..."
    cd /var/www/domains/pmdevop.com/public_html
    pm2 delete pmdevop
    pm2 start ecosystem.config.js
    pm2 save
    
    echo "¡Configuración aplicada correctamente!"
    echo "Verificando estado de los servicios:"
    systemctl status lsws | grep Active
    pm2 status
else
    echo "Configuración no aplicada. Puedes aplicarla manualmente con:"
    echo "cp /tmp/vhconf.conf /usr/local/lsws/conf/vhosts/pmdevop.com/vhconf.conf"
    echo "systemctl restart lsws"
fi

echo "=== Verificación del proxy inverso completada ==="
