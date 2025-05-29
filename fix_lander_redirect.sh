#!/bin/bash

# Script para solucionar el problema de redirección a /lander
# Ejecutar en el servidor VPS como root

echo "Iniciando configuración..."

# 1. Actualizar configuración de LiteSpeed
echo "Creando configuración de LiteSpeed..."
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

context / {
    type                  proxy
    handler               localhost:3000
    addDefaultCharset     off
}

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

# 2. Aplicar configuración
echo "Aplicando configuración..."
cp /tmp/vhconf.conf /usr/local/lsws/conf/vhosts/pmdevop.com/vhconf.conf

# 3. Reiniciar LiteSpeed
echo "Reiniciando LiteSpeed..."
systemctl restart lsws

# 4. Actualizar la aplicación
echo "Reiniciando la aplicación con PM2..."
cd /var/www/domains/pmdevop.com/public_html
pm2 delete pmdevop
pm2 start ecosystem.config.js
pm2 save

# 5. Verificar estado
echo "Verificando estado de los servicios..."
echo "==== Estado de LiteSpeed ===="
systemctl status lsws | grep Active
echo "==== Estado de PM2 ===="
pm2 status

echo "¡Configuración completada! Verifica que la redirección funcione correctamente."
