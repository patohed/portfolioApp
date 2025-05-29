#!/bin/bash

# Script para configurar correctamente las reglas de redirección de LiteSpeed
# Ejecutar como root (sudo bash fix-redirect.sh)

# 1. Crear archivo de configuración de LiteSpeed actualizado
cat > /usr/local/lsws/conf/vhosts/pmdevop.com/vhconf.conf << 'EOF'
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
EOF

# 2. Reiniciar LiteSpeed
systemctl restart lsws

# 3. Reiniciar la aplicación Next.js con PM2
cd /var/www/domains/pmdevop.com/public_html
pm2 delete pmdevop
pm2 start ecosystem.config.js
pm2 save

echo "Configuración completada. Verifique que la redirección ahora funcione correctamente."
