#!/bin/bash
set -e

# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuración
DEPLOY_USER="root"
DEPLOY_HOST="216.246.113.209"
DEPLOY_PORT="12141"
DEPLOY_PATH="/srv/projects/mi-portfolio"
ENV_FILE=".env"

# Verificar archivo .env
if [ ! -f "$ENV_FILE" ]; then
    echo -e "${RED}Error: Archivo .env no encontrado${NC}"
    echo "Por favor, cree un archivo .env con la variable SERVER=su_contraseña"
    exit 1
fi

# Leer contraseña del archivo .env
SERVER_PASSWORD=$(grep "SERVER=" "$ENV_FILE" | cut -d '=' -f2-)

if [ -z "$SERVER_PASSWORD" ]; then
    echo -e "${RED}Error: Variable SERVER no encontrada en .env${NC}"
    exit 1
fi

echo -e "${YELLOW}Preparando archivos para el despliegue...${NC}"

# Crear archivo tar excluyendo archivos innecesarios
echo -e "${GREEN}Creando archivo de despliegue...${NC}"
tar czf deploy.tar.gz \
    --exclude='node_modules' \
    --exclude='.git' \
    --exclude='.next' \
    --exclude='deploy.tar.gz' \
    --exclude='.env' \
    .

# Crear archivo de comandos para plink
echo "cd $DEPLOY_PATH && \
    tar xzf deploy.tar.gz && \
    rm deploy.tar.gz && \
    docker compose down && \
    docker compose build --no-cache && \
    docker compose up -d && \
    docker system prune -f" > remote_commands.txt

# Transferir archivos usando pscp
echo -e "${YELLOW}Transfiriendo archivos al servidor...${NC}"
echo y | pscp -P "$DEPLOY_PORT" -pw "$SERVER_PASSWORD" deploy.tar.gz "$DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH/"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Archivos transferidos exitosamente${NC}"
else
    echo -e "${RED}Error al transferir archivos${NC}"
    rm deploy.tar.gz
    rm remote_commands.txt
    exit 1
fi

echo -e "${YELLOW}Ejecutando comandos de despliegue...${NC}"
cat remote_commands.txt | plink -P "$DEPLOY_PORT" -pw "$SERVER_PASSWORD" "$DEPLOY_USER@$DEPLOY_HOST"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Despliegue completado exitosamente${NC}"
else
    echo -e "${RED}Error durante el despliegue${NC}"
    rm deploy.tar.gz
    rm remote_commands.txt
    exit 1
fi

# Limpiar archivos locales
rm deploy.tar.gz
rm remote_commands.txt

echo -e "${GREEN}¡Despliegue completado!${NC}"
echo -e "${YELLOW}Verificando estado de los contenedores...${NC}"

# Verificar estado de los contenedores
echo "docker compose ps" | plink -P "$DEPLOY_PORT" -pw "$SERVER_PASSWORD" "$DEPLOY_USER@$DEPLOY_HOST"
