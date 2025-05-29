#!/bin/bash

# Script para solucionar todos los problemas de despliegue
# Ejecutar este script en el servidor VPS como root

echo "=== INICIANDO SOLUCIÓN COMPLETA ==="
echo "Fecha y hora: $(date)"
echo "Hostname: $(hostname)"
echo ""

# 1. Detener todos los procesos existentes
echo "=== DETENIENDO PROCESOS EXISTENTES ==="
pm2 delete all
echo ""

# 2. Verificar la estructura de directorios y corregir permisos
echo "=== VERIFICANDO ESTRUCTURA DE DIRECTORIOS ==="
APP_DIR="/var/www/domains/pmdevop.com/public_html"

if [ ! -d "$APP_DIR" ]; then
  echo "ERROR: El directorio $APP_DIR no existe"
  exit 1
fi

cd $APP_DIR
echo "Directorio actual: $(pwd)"
echo "Contenido del directorio:"
ls -la
echo ""

# 3. Verificar si .next/standalone existe
echo "=== VERIFICANDO ESTRUCTURA DE LA APLICACIÓN ==="
if [ ! -d ".next/standalone" ]; then
  echo "ERROR: El directorio .next/standalone no existe"
  echo "Necesitamos reconstruir la aplicación..."
  
  # Verificar si package.json existe
  if [ ! -f "package.json" ]; then
    echo "ERROR: package.json no existe. El código fuente no está correctamente desplegado."
    echo "Asegúrate de subir todo el código fuente a $APP_DIR"
    exit 1
  fi
  
  echo "Instalando dependencias..."
  npm install
  
  echo "Construyendo la aplicación..."
  npm run build
  
  if [ ! -d ".next/standalone" ]; then
    echo "ERROR: Fallo al construir la aplicación. El directorio .next/standalone no fue creado."
    exit 1
  fi
fi

echo "Contenido del directorio .next:"
ls -la .next
echo ""
echo "Contenido del directorio .next/standalone:"
ls -la .next/standalone
echo ""

# 4. Corrigiendo permisos
echo "=== CORRIGIENDO PERMISOS ==="
chown -R www-data:www-data $APP_DIR
chmod -R 755 $APP_DIR
echo ""

# 5. Configurando LiteSpeed correctamente
echo "=== CONFIGURANDO LITESPEED ==="
cat > /usr/local/lsws/conf/vhosts/pmdevop.com/vhconf.conf << 'EOL'
docRoot                   $VH_ROOT/public_html
vhDomain                  pmdevop.com,www.pmdevop.com
adminEmails               admin@pmdevop.com
enableGzip                1

index {
    useServer             0
    indexFiles            index.html
    autoIndex             0
}

# Limpiamos todas las reglas de rewrite para evitar redirecciones infinitas
# Podemos agregarlas de nuevo cuando todo funcione
# rewrite {
#     enable                1
#     rules                 <<END_RULES
#     rewrite ^/lander(.*)$ / [R=301,L]
#     END_RULES
# }

# Configuración de proxy simple y efectiva
context / {
    type                  proxy
    handler               localhost:3000
    addDefaultCharset     off
    proxyWebSocket        1
}

# Configuración para servir archivos estáticos
context /_next/static {
    location             $VH_ROOT/public_html/.next/static
    allowBrowse          1
    expires              365d
    headers              AccessControlAllowOrigin *
}

context /static {
    location             $VH_ROOT/public_html/public
    allowBrowse          1
    expires              30d
    headers              AccessControlAllowOrigin *
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

# 6. Reiniciando LiteSpeed
echo "=== REINICIANDO LITESPEED ==="
systemctl restart lsws
echo ""

# 7. Configurando y reiniciando la aplicación con PM2
echo "=== CONFIGURANDO PM2 ==="
cd $APP_DIR

# Verificar que ecosystem.config.js exista
if [ ! -f "ecosystem.config.js" ]; then
  echo "Creando archivo ecosystem.config.js..."
  cat > ecosystem.config.js << 'EOL'
module.exports = {
  apps: [{
    name: 'pmdevop',
    script: '.next/standalone/server.js',
    cwd: '/var/www/domains/pmdevop.com/public_html',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    }
  }]
}
EOL
fi

# Iniciando la aplicación con PM2
echo "Iniciando aplicación con PM2..."
pm2 start ecosystem.config.js
pm2 save
pm2 startup
echo ""

# 8. Verificando que todo funcione
echo "=== VERIFICANDO SERVICIOS ==="
echo "Estado de LiteSpeed:"
systemctl status lsws | grep -E 'Active|running|exited|failed'
echo ""
echo "Estado de PM2:"
pm2 status
echo ""
echo "Verificando que la aplicación esté escuchando en el puerto 3000:"
netstat -tulpn | grep :3000
echo ""
echo "Intentando acceder a la aplicación localmente:"
curl -I http://localhost:3000
echo ""

# 9. Limpiando caché del servidor
echo "=== LIMPIANDO CACHÉ ==="
if [ -d "/tmp/lshttpd" ]; then
  echo "Limpiando caché de LiteSpeed..."
  rm -rf /tmp/lshttpd/*
fi
echo ""

echo "=== SOLUCIÓN COMPLETA APLICADA ==="
echo "Ahora deberías poder acceder a tu sitio en https://pmdevop.com sin redirecciones a /lander"
echo "Si el problema persiste, intenta acceder en modo incógnito para evitar caché del navegador"
echo ""
echo "Consideraciones adicionales:"
echo "1. Si sigues teniendo problemas, verifica si hay alguna regla en un nivel superior (hosting/proveedor)"
echo "2. Verifica que no haya redirecciones a nivel de aplicación en el código Next.js"
echo "3. Considera usar herramientas como curl o wget para probar sin caché del navegador"
echo ""
