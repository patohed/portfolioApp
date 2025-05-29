#!/bin/bash

# Crear archivo de configuración actualizado
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

# Aplicar configuración y reiniciar servicios
cp /tmp/vhconf.conf /usr/local/lsws/conf/vhosts/pmdevop.com/vhconf.conf
systemctl restart lsws
cd /var/www/domains/pmdevop.com/public_html
pm2 delete pmdevop
pm2 start ecosystem.config.js
pm2 save

# Verificar estado
echo "==== Estado de LiteSpeed ===="
systemctl status lsws | grep Active
echo "==== Estado de PM2 ===="
pm2 status
echo "==== Configuración aplicada exitosamente ===="
