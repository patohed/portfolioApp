#!/bin/bash

# Script para desplegar la aplicación Next.js sin Docker
# Autor: GitHub Copilot
# Fecha: Mayo 2025

set -e

# Colores para mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Iniciando despliegue de la aplicación Next.js sin Docker ===${NC}"

# Variables (ajusta según tu entorno)
APP_DIR="/var/www/portfolioApp"
REPO_URL="https://github.com/patohed/portfolioApp.git"
NGINX_CONF="/etc/nginx/sites-available/portfolio"
DOMAIN="tudominio.com" # Cambia esto a tu dominio real

# 1. Actualizar el sistema
echo -e "${YELLOW}Actualizando el sistema...${NC}"
sudo apt-get update
sudo apt-get upgrade -y

# 2. Instalar Node.js si no está instalado
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}Instalando Node.js y npm...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# 3. Instalar PM2 globalmente si no está instalado
if ! command -v pm2 &> /dev/null; then
    echo -e "${YELLOW}Instalando PM2...${NC}"
    sudo npm install -g pm2
fi

# 4. Instalar Nginx si no está instalado
if ! command -v nginx &> /dev/null; then
    echo -e "${YELLOW}Instalando Nginx...${NC}"
    sudo apt-get install -y nginx
fi

# 5. Clonar o actualizar el repositorio
if [ -d "$APP_DIR" ]; then
    echo -e "${YELLOW}Actualizando el repositorio existente...${NC}"
    cd "$APP_DIR"
    git pull
else
    echo -e "${YELLOW}Clonando el repositorio...${NC}"
    sudo mkdir -p "$APP_DIR"
    sudo git clone "$REPO_URL" "$APP_DIR"
    cd "$APP_DIR"
fi

# 6. Instalar dependencias
echo -e "${YELLOW}Instalando dependencias...${NC}"
npm install

# 7. Construir la aplicación
echo -e "${YELLOW}Construyendo la aplicación...${NC}"
npm run build

# 8. Configurar Nginx
echo -e "${YELLOW}Configurando Nginx...${NC}"
if [ ! -f "$NGINX_CONF" ]; then
    echo -e "${YELLOW}Creando configuración de Nginx...${NC}"
    sudo tee "$NGINX_CONF" > /dev/null << EOF
server {
    listen 80;
    server_name $DOMAIN;
    root $APP_DIR;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

    # Habilitar el sitio
    sudo ln -s "$NGINX_CONF" /etc/nginx/sites-enabled/
    sudo nginx -t && sudo systemctl restart nginx
fi

# 9. Configurar PM2 para gestionar la aplicación
echo -e "${YELLOW}Configurando PM2...${NC}"
cd "$APP_DIR"
pm2 delete portfolio 2>/dev/null || true
pm2 start npm --name "portfolio" -- start
pm2 save
pm2 startup

echo -e "${GREEN}=== Despliegue completado correctamente ===${NC}"
echo -e "${GREEN}Tu aplicación debería estar disponible en http://$DOMAIN${NC}"
echo -e "${YELLOW}Para configurar SSL, ejecuta el script setup-ssl.sh${NC}"
