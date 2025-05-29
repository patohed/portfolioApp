#!/bin/bash

# Script para actualizar el repositorio en GitHub
# Ejecutar en tu máquina local antes de desplegar al VPS

# Colores para mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== ACTUALIZANDO REPOSITORIO EN GITHUB ===${NC}"

# 1. Verificar si hay cambios
echo -e "${YELLOW}Verificando cambios locales...${NC}"
git status

# 2. Preguntar por un mensaje de commit
echo -e "${YELLOW}Ingresa un mensaje para el commit:${NC}"
read -p ">> " commit_message

if [ -z "$commit_message" ]; then
  commit_message="Actualización de scripts de despliegue y configuración para LiteSpeed"
  echo -e "${YELLOW}Usando mensaje por defecto: ${commit_message}${NC}"
fi

# 3. Añadir todos los cambios
echo -e "${YELLOW}Añadiendo archivos modificados...${NC}"
git add .

# 4. Realizar commit
echo -e "${YELLOW}Realizando commit...${NC}"
git commit -m "$commit_message"

# 5. Push a GitHub
echo -e "${YELLOW}Subiendo cambios a GitHub...${NC}"
git push origin main

echo -e "${GREEN}=== PROCESO COMPLETADO ===${NC}"
echo "Los cambios han sido subidos a GitHub."
echo "Ahora puedes desplegar los cambios en el VPS ejecutando:"
echo "./litespeed_optimized_deploy.sh"
