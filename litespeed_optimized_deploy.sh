#!/bin/bash

# Script para desplegar correctamente la aplicación Next.js en LiteSpeed
# Este script resuelve los problemas de redirección a /lander y páginas en blanco
# Ejecutar como root en el servidor VPS

set -e

# Colores para mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Despliegue optimizado para Next.js en LiteSpeed ===${NC}"

# Variables de configuración
APP_DIR="/var/www/domains/pmdevop.com/public_html"
DOMAIN="pmdevop.com"
LITESPEED_CONF="/usr/local/lsws/conf/vhosts/$DOMAIN/vhconf.conf"

# 1. Detener todos los procesos existentes
echo -e "${YELLOW}Deteniendo procesos existentes...${NC}"
pm2 delete all 2>/dev/null || true

# 2. Verificar estructura y preparar directorios
echo -e "${YELLOW}Verificando estructura de directorios...${NC}"
mkdir -p "$APP_DIR"
chown -R www-data:www-data "$(dirname "$APP_DIR")"

# 3. Navegar al directorio de la aplicación
cd "$APP_DIR"
echo -e "${YELLOW}Directorio actual: $(pwd)${NC}"

# 4. Verificar si package.json existe
if [ ! -f "package.json" ]; then
  echo -e "${RED}ERROR: package.json no existe. El código fuente no está correctamente desplegado.${NC}"
  echo -e "${YELLOW}¿Deseas clonar el repositorio? (s/n)${NC}"
  read -p ">> " respuesta
  
  if [ "$respuesta" = "s" ]; then
    echo -e "${YELLOW}Clonando repositorio...${NC}"
    # Limpiamos el directorio antes de clonar
    rm -rf "$APP_DIR"/*
    git clone https://github.com/tuusuario/turepo.git .
  else
    echo -e "${RED}Abortando. Por favor, sube el código fuente manualmente.${NC}"
    exit 1
  fi
fi

# 5. Instalar dependencias y construir
echo -e "${YELLOW}Instalando dependencias...${NC}"
npm install

echo -e "${YELLOW}Construyendo la aplicación...${NC}"
npm run build

# Verificar que la construcción fue exitosa
if [ ! -d ".next/standalone" ]; then
  echo -e "${RED}ERROR: La construcción falló. Verifique los errores anteriores.${NC}"
  exit 1
fi

echo -e "${YELLOW}Copiando archivos estáticos...${NC}"
# Asegúrate de que el servidor standalone tenga acceso a los archivos estáticos
cp -r public .next/standalone/
mkdir -p .next/standalone/.next
cp -r .next/static .next/standalone/.next/

# 6. Configurar LiteSpeed correctamente
echo -e "${YELLOW}Configurando LiteSpeed...${NC}"
cat > "$LITESPEED_CONF" << 'EOL'
docRoot                   $VH_ROOT/public_html
vhDomain                  pmdevop.com,www.pmdevop.com
adminEmails               admin@pmdevop.com
enableGzip                1

index {
    useServer             0
    indexFiles            index.html
    autoIndex             0
}

# Configuración de proxy clara y directa
context / {
    type                  proxy
    handler               localhost:3000
    addDefaultCharset     off
    proxyWebSocket        1
}

# Configuración óptima para archivos estáticos
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

# Solo cuando la aplicación esté funcionando correctamente, habilitaremos 
# la redirección para evitar bucles
# rewrite {
#     enable                1
#     rules                 <<END_RULES
#     rewrite ^/lander(.*)$ / [R=301,L]
#     END_RULES
# }

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

# 7. Configurar y arrancar PM2
echo -e "${YELLOW}Configurando PM2...${NC}"
cat > "$APP_DIR/ecosystem.config.js" << EOL
module.exports = {
  apps: [{
    name: 'pmdevop',
    script: '.next/standalone/server.js',
    cwd: '${APP_DIR}',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    }
  }]
}
EOL

# Configurar los permisos
echo -e "${YELLOW}Configurando permisos...${NC}"
chown -R www-data:www-data "$APP_DIR"
chmod -R 755 "$APP_DIR"

# Iniciar la aplicación con PM2
echo -e "${YELLOW}Iniciando aplicación con PM2...${NC}"
pm2 start "$APP_DIR/ecosystem.config.js"
pm2 save
pm2 startup

# 8. Reiniciar LiteSpeed
echo -e "${YELLOW}Reiniciando LiteSpeed...${NC}"
systemctl restart lsws

# 9. Verificar servicios
echo -e "${YELLOW}Verificando servicios...${NC}"
echo "Estado de LiteSpeed:"
systemctl status lsws | grep -E 'Active|running|exited|failed'
echo ""
echo "Estado de PM2:"
pm2 status
echo ""

# 10. Realizar pruebas
echo -e "${YELLOW}Probando conexión local:${NC}"
curl -I http://localhost:3000
echo ""

echo -e "${GREEN}=== Despliegue completado ===${NC}"
echo -e "${GREEN}Tu aplicación debería estar disponible en https://$DOMAIN${NC}"
echo ""
echo -e "${YELLOW}Consideraciones importantes:${NC}"
echo "1. Si la redirección a /lander persiste, verifica en el navegador en modo incógnito"
echo "2. Cuando la aplicación funcione correctamente, descomenta la sección 'rewrite' en el archivo de configuración"
echo "3. Para aplicar las redirecciones después: sudo systemctl restart lsws"
echo ""
