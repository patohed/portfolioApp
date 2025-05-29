#!/bin/bash

# Script para solucionar el problema de recursos bloqueados
# Ejecutar como root en el servidor VPS

echo "Iniciando diagnóstico de problemas con recursos bloqueados..."

# 1. Verificar directorios y permisos
echo "Verificando directorios y permisos..."
cd /var/www/domains/pmdevop.com/public_html
find .next -type d -exec chmod 755 {} \;
find .next -type f -exec chmod 644 {} \;
find public -type d -exec chmod 755 {} \;
find public -type f -exec chmod 644 {} \;

# 2. Verificar la configuración de LiteSpeed
echo "Verificando la configuración de LiteSpeed..."
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

context /_next/image {
    type                 proxy
    handler              localhost:3000
    addDefaultCharset    off
    extraHeaders         Header set Access-Control-Allow-Origin "*"
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

# 3. Aplicar configuración
echo "Aplicando configuración..."
cp /tmp/vhconf.conf /usr/local/lsws/conf/vhosts/pmdevop.com/vhconf.conf

# 4. Reconstruir la aplicación para generar nuevos recursos estáticos
echo "Reconstruyendo la aplicación..."
npm run build

# 5. Reiniciar servicios
echo "Reiniciando servicios..."
systemctl restart lsws
pm2 delete pmdevop
pm2 start ecosystem.config.js
pm2 save

# 6. Verificar estado
echo "Verificando estado de los servicios..."
systemctl status lsws | grep Active
pm2 status

echo "¡Diagnóstico completado! Por favor, verifica que la página cargue correctamente."
echo "Nota: Si el problema persiste, intenta acceder al sitio desde un navegador sin bloqueador de anuncios o extensiones."
