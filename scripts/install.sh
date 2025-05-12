#!/bin/bash

# Colores para mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Iniciando instalación del portfolio...${NC}"

# Actualizar sistema
echo -e "${YELLOW}Actualizando sistema...${NC}"
sudo apt update && sudo apt upgrade -y

# Instalar dependencias
echo -e "${YELLOW}Instalando dependencias...${NC}"
sudo apt install -y nginx certbot python3-certbot-nginx mailutils

# Instalar Node.js 20.x
echo -e "${YELLOW}Instalando Node.js...${NC}"
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Instalar PM2
echo -e "${YELLOW}Instalando PM2...${NC}"
sudo npm install -g pm2

# Crear directorios necesarios
echo -e "${YELLOW}Creando estructura de directorios...${NC}"
sudo mkdir -p /var/www/portfolio
sudo mkdir -p /var/log/portfolio
sudo mkdir -p /var/backups/portfolio

# Configurar permisos
echo -e "${YELLOW}Configurando permisos...${NC}"
sudo chown -R $USER:$USER /var/www/portfolio
sudo chown -R $USER:$USER /var/log/portfolio
sudo chown -R $USER:$USER /var/backups/portfolio

# Configurar Nginx
echo -e "${YELLOW}Configurando Nginx...${NC}"
sudo cp nginx/portfolio.conf /etc/nginx/sites-available/portfolio
sudo ln -s /etc/nginx/sites-available/portfolio /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# Configurar tareas programadas
echo -e "${YELLOW}Configurando tareas programadas...${NC}"
(crontab -l 2>/dev/null; echo "0 3 * * * /var/www/portfolio/scripts/backup.sh") | crontab -
(crontab -l 2>/dev/null; echo "*/5 * * * * /var/www/portfolio/scripts/monitor.sh") | crontab -

# Hacer ejecutables los scripts
chmod +x scripts/*.sh

# Instalar dependencias del proyecto
echo -e "${YELLOW}Instalando dependencias del proyecto...${NC}"
npm ci

# Construir la aplicación
echo -e "${YELLOW}Construyendo la aplicación...${NC}"
npm run build

# Iniciar la aplicación con PM2
echo -e "${YELLOW}Iniciando la aplicación...${NC}"
pm2 start ecosystem.config.json

# Guardar configuración de PM2
pm2 save

# Configurar inicio automático de PM2
pm2 startup

echo -e "${GREEN}¡Instalación completada!${NC}"
echo -e "${YELLOW}No olvides:${NC}"
echo "1. Configurar las variables de entorno en .env"
echo "2. Configurar el dominio en Nginx"
echo "3. Obtener certificado SSL con: sudo certbot --nginx -d tudominio.com"
