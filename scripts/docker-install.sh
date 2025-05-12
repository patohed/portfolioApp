#!/bin/bash

# Colores para mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Iniciando instalación del portfolio con Docker...${NC}"

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Instalando Docker...${NC}"
    curl -fsSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    sudo systemctl start docker
fi

# Verificar si Docker Compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}Instalando Docker Compose...${NC}"
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Crear directorios necesarios
echo -e "${YELLOW}Creando estructura de directorios...${NC}"
mkdir -p certbot/conf
mkdir -p certbot/www
mkdir -p nginx/logs

# Copiar configuración de Nginx si no existe
if [ ! -f nginx/portfolio.conf ]; then
    cp nginx/portfolio.conf.example nginx/portfolio.conf
fi

# Crear archivo .env si no existe
if [ ! -f .env ]; then
    echo -e "${YELLOW}Creando archivo .env...${NC}"
    cp .env.example .env
    echo "Por favor, edita el archivo .env con tus valores"
fi

# Construir y levantar los contenedores
echo -e "${YELLOW}Construyendo y levantando contenedores...${NC}"
docker-compose up -d --build

# Configurar renovación automática de certificados SSL
echo -e "${YELLOW}Configurando renovación automática de SSL...${NC}"
echo "0 0 * * * docker-compose run --rm certbot renew && docker-compose kill -s SIGHUP nginx" | sudo tee -a /etc/crontab > /dev/null

echo -e "${GREEN}¡Instalación completada!${NC}"
echo -e "${YELLOW}Pasos siguientes:${NC}"
echo "1. Editar el archivo .env con tus variables de entorno"
echo "2. Configurar el dominio en nginx/portfolio.conf"
echo "3. Obtener certificado SSL ejecutando:"
echo "   docker-compose run --rm certbot certonly --webroot -w /var/www/certbot -d tudominio.com"
echo "4. Reiniciar los contenedores: docker-compose restart"
