#!/bin/bash

# Script para actualizar desde GitHub al VPS
# Ejecutar en el servidor VPS

# Colores para mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== ACTUALIZANDO DESDE GITHUB AL VPS ===${NC}"

# 1. Ir al directorio de la aplicación
APP_DIR="/var/www/domains/pmdevop.com/public_html"
cd "$APP_DIR" || { echo -e "${RED}ERROR: No se pudo acceder a $APP_DIR${NC}"; exit 1; }

echo -e "${YELLOW}Directorio actual: $(pwd)${NC}"

# 2. Guardar el archivo ecosystem.config.js actual
if [ -f "ecosystem.config.js" ]; then
  echo -e "${YELLOW}Guardando configuración de PM2 actual...${NC}"
  cp ecosystem.config.js ecosystem.config.js.bak
fi

# 3. Detener la aplicación
echo -e "${YELLOW}Deteniendo la aplicación...${NC}"
pm2 delete pmdevop 2>/dev/null || true

# 4. Actualizar desde GitHub
echo -e "${YELLOW}Actualizando desde GitHub...${NC}"
git fetch
git reset --hard origin/main

# 5. Instalar dependencias y reconstruir
echo -e "${YELLOW}Instalando dependencias...${NC}"
npm install

echo -e "${YELLOW}Reconstruyendo la aplicación...${NC}"
npm run build

# 6. Verificar si el build fue exitoso
if [ ! -d ".next/standalone" ]; then
  echo -e "${RED}ERROR: El build falló, no se encontró el directorio .next/standalone${NC}"
  exit 1
fi

# 7. Aplicar optimizaciones
echo -e "${YELLOW}Aplicando configuración de LiteSpeed...${NC}"
if [ -f "./litespeed_optimized_deploy.sh" ]; then
  chmod +x ./litespeed_optimized_deploy.sh
  ./litespeed_optimized_deploy.sh
else
  echo -e "${YELLOW}Script de optimización no encontrado, usando configuración básica...${NC}"
  
  # Reiniciar la aplicación con PM2
  echo "Reiniciando aplicación con PM2..."
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
  
  pm2 start ecosystem.config.js
  pm2 save
  
  # Reiniciar LiteSpeed
  echo "Reiniciando LiteSpeed..."
  systemctl restart lsws
fi

echo -e "${GREEN}=== ACTUALIZACIÓN COMPLETADA ===${NC}"
echo "La aplicación ha sido actualizada desde GitHub y desplegada en el VPS."
echo "Verifica que todo funcione correctamente accediendo a https://pmdevop.com"
