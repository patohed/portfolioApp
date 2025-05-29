#!/bin/bash

# Script para configurar SSL con Let's Encrypt sin Docker
# Autor: GitHub Copilot
# Fecha: Mayo 2025

set -e

# Colores para mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Configurando SSL con Let's Encrypt ===${NC}"

# Variables (ajusta según tu entorno)
DOMAIN="tudominio.com" # Cambia esto a tu dominio real
EMAIL="tu@email.com" # Cambia esto a tu email

# 1. Instalar Certbot
echo -e "${YELLOW}Instalando Certbot...${NC}"
sudo apt-get update
sudo apt-get install -y certbot python3-certbot-nginx

# 2. Obtener certificado SSL con Nginx plugin
echo -e "${YELLOW}Obteniendo certificado SSL para $DOMAIN...${NC}"
sudo certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos --email "$EMAIL"

# 3. Configurar renovación automática
echo -e "${YELLOW}Configurando renovación automática de SSL...${NC}"
sudo systemctl status certbot.timer

# 4. Probar la renovación
echo -e "${YELLOW}Probando renovación (simulación)...${NC}"
sudo certbot renew --dry-run

echo -e "${GREEN}=== Configuración SSL completada correctamente ===${NC}"
echo -e "${GREEN}Tu aplicación ahora debería estar disponible en https://$DOMAIN${NC}"
