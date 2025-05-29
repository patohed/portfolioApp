#!/bin/bash

# Script para diagnosticar y resolver problemas específicos con Next.js en LiteSpeed
# Ejecutar como root en el servidor VPS

set -e

# Colores para mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== DIAGNÓSTICO Y SOLUCIÓN RÁPIDA PARA NEXT.JS EN LITESPEED ===${NC}"
echo "Fecha: $(date)"
echo "Hostname: $(hostname)"
echo ""

# Variables
APP_DIR="/var/www/domains/pmdevop.com/public_html"
LITESPEED_CONF="/usr/local/lsws/conf/vhosts/pmdevop.com/vhconf.conf"

# 1. Verificar estructura básica
echo -e "${YELLOW}=== VERIFICANDO ESTRUCTURA BÁSICA ===${NC}"
if [ ! -d "$APP_DIR" ]; then
  echo -e "${RED}ERROR: El directorio $APP_DIR no existe${NC}"
  exit 1
fi

cd "$APP_DIR"
echo "Directorio actual: $(pwd)"

if [ ! -f ".next/standalone/server.js" ]; then
  echo -e "${RED}ERROR: No se encontró el servidor standalone (.next/standalone/server.js)${NC}"
  echo -e "${YELLOW}¿Quieres reconstruir la aplicación? (s/n)${NC}"
  read -p ">> " respuesta
  
  if [ "$respuesta" = "s" ]; then
    echo "Reconstruyendo aplicación..."
    npm run build
    
    if [ ! -f ".next/standalone/server.js" ]; then
      echo -e "${RED}ERROR: La reconstrucción falló. Verifique los errores de build.${NC}"
      exit 1
    fi
  else
    echo "Abortando. Necesitas reconstruir la aplicación para continuar."
    exit 1
  fi
fi

# 2. Verificar procesos
echo -e "${YELLOW}=== VERIFICANDO PROCESOS ===${NC}"
echo "Procesos Node.js ejecutándose:"
ps aux | grep node
echo ""

echo "Procesos PM2:"
pm2 list
echo ""

echo "Puertos en uso:"
netstat -tulpn | grep -E ':80|:443|:3000'
echo ""

# 3. Verificar problemas específicos
echo -e "${YELLOW}=== BUSCANDO PROBLEMAS ESPECÍFICOS ===${NC}"

# 3.1 Problema de redirección a /lander
echo "Buscando reglas de redirección en LiteSpeed:"
grep -A 5 "rewrite" "$LITESPEED_CONF" || echo "No se encontraron reglas de redirección"
echo ""

# 3.2 Problema de página en blanco
echo "Verificando archivos estáticos:"
ls -la .next/static 2>/dev/null || echo "No se encontró directorio .next/static"
echo ""

# 3.3 Problema de recursos bloqueados
echo "Verificando configuración de contextos para archivos estáticos:"
grep -A 5 "context /_next/static" "$LITESPEED_CONF" || echo "No se encontró configuración para /_next/static"
grep -A 5 "context /static" "$LITESPEED_CONF" || echo "No se encontró configuración para /static"
echo ""

# 4. Solución rápida para problemas comunes
echo -e "${YELLOW}=== APLICANDO SOLUCIONES RÁPIDAS ===${NC}"

# 4.1 Reiniciar PM2 con configuración correcta
echo "Reiniciando PM2 con configuración correcta..."
cat > ecosystem.config.js << EOL
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

pm2 delete all 2>/dev/null || true
pm2 start ecosystem.config.js
pm2 save

# 4.2 Corregir la configuración de LiteSpeed para el problema de recursos bloqueados
echo "Corrigiendo configuración de LiteSpeed para recursos estáticos..."
sed -i '/context \/_next\/static {/,/}/c\
context /_next/static {\
    location             $VH_ROOT/public_html/.next/static\
    allowBrowse          1\
    expires              365d\
    extraHeaders         Header set Access-Control-Allow-Origin "*"\
    extraHeaders         Header set Cache-Control "public, max-age=31536000, immutable"\
}' "$LITESPEED_CONF"

sed -i '/context \/static {/,/}/c\
context /static {\
    location             $VH_ROOT/public_html/public\
    allowBrowse          1\
    expires              30d\
    extraHeaders         Header set Access-Control-Allow-Origin "*"\
    extraHeaders         Header set Cache-Control "public, max-age=2592000"\
}' "$LITESPEED_CONF"

# 4.3 Deshabilitar temporalmente las reglas de redirección para evitar bucles
echo "Deshabilitando temporalmente reglas de redirección..."
sed -i '/rewrite {/,/}/c\
# rewrite {\
#     enable                1\
#     rules                 <<END_RULES\
#     rewrite ^/lander(.*)$ / [R=301,L]\
#     END_RULES\
# }' "$LITESPEED_CONF"

# 4.4 Asegurarse de que el proxy está configurado correctamente
echo "Configurando proxy correctamente..."
sed -i '/context \/ {/,/}/c\
context / {\
    type                  proxy\
    handler               localhost:3000\
    addDefaultCharset     off\
    proxyWebSocket        1\
}' "$LITESPEED_CONF"

# 5. Reiniciar servicios
echo -e "${YELLOW}=== REINICIANDO SERVICIOS ===${NC}"
systemctl restart lsws
echo "LiteSpeed reiniciado"

# 6. Verificar acceso
echo -e "${YELLOW}=== VERIFICANDO ACCESO ===${NC}"
echo "Intentando acceder a localhost:3000:"
curl -I http://localhost:3000 || echo "No se pudo conectar a localhost:3000"
echo ""

# 7. Limpieza de caché
echo -e "${YELLOW}=== LIMPIANDO CACHÉ ===${NC}"
if [ -d "/tmp/lshttpd" ]; then
  echo "Limpiando caché de LiteSpeed..."
  rm -rf /tmp/lshttpd/*
fi

echo -e "${GREEN}=== DIAGNÓSTICO Y SOLUCIÓN COMPLETADOS ===${NC}"
echo ""
echo "Para verificar si se resolvieron los problemas:"
echo "1. Intenta acceder a https://pmdevop.com en modo incógnito"
echo "2. Verifica que no haya redirección a /lander"
echo "3. Verifica que la página cargue correctamente y no aparezca en blanco"
echo "4. Revisa la consola del navegador (F12) para verificar que no haya errores de recursos bloqueados"
echo ""
echo "Si sigues teniendo problemas, considera ejecutar el script de despliegue completo litespeed_optimized_deploy.sh"
echo ""
