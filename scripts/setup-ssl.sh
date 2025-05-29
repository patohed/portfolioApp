#!/bin/bash

# Configuración
DOMAIN="pmdevop.com"
EMAIL="patriciomillan10@gmail.com"
DEPLOY_PATH="/srv/projects/mi-portfolio"

# Instalar Certbot si no está instalado
if ! command -v certbot &> /dev/null; then
    echo "Instalando Certbot..."
    apt update
    apt install -y certbot
fi

# Detener contenedores
cd $DEPLOY_PATH
docker-compose down

# Obtener certificado SSL
echo "Obteniendo certificado SSL para $DOMAIN..."
certbot certonly --standalone \
    -d $DOMAIN \
    -d www.$DOMAIN \
    --email $EMAIL \
    --agree-tos \
    --non-interactive \
    --preferred-challenges http

# Crear directorio para certificados en el proyecto
mkdir -p $DEPLOY_PATH/certs
cp -L /etc/letsencrypt/live/$DOMAIN/fullchain.pem $DEPLOY_PATH/certs/
cp -L /etc/letsencrypt/live/$DOMAIN/privkey.pem $DEPLOY_PATH/certs/

# Configurar renovación automática
echo "Configurando renovación automática..."
RENEWAL_SCRIPT="/etc/letsencrypt/renewal-hooks/deploy/copy-certs.sh"
cat > $RENEWAL_SCRIPT << 'EOF'
#!/bin/bash
cp -L /etc/letsencrypt/live/pmdevop.com/fullchain.pem /srv/projects/mi-portfolio/certs/
cp -L /etc/letsencrypt/live/pmdevop.com/privkey.pem /srv/projects/mi-portfolio/certs/
cd /srv/projects/mi-portfolio && docker-compose restart nginx
EOF

chmod +x $RENEWAL_SCRIPT

# Reiniciar contenedores
cd $DEPLOY_PATH
docker-compose up -d

echo "Configuración SSL completada exitosamente"
