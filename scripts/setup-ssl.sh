#!/bin/bash

# Configuración
DOMAIN=$1
EMAIL=$2

# Verificar argumentos
if [ -z "$DOMAIN" ] || [ -z "$EMAIL" ]; then
    echo "Uso: $0 <dominio> <email>"
    echo "Ejemplo: $0 ejemplo.com admin@ejemplo.com"
    exit 1
fi

# Instalar Certbot si no está instalado
if ! command -v certbot &> /dev/null; then
    echo "Instalando Certbot..."
    sudo apt update
    sudo apt install -y certbot python3-certbot-nginx
fi

# Obtener certificado SSL
echo "Obteniendo certificado SSL para $DOMAIN..."
sudo certbot --nginx \
    --non-interactive \
    --agree-tos \
    --email "$EMAIL" \
    --domains "$DOMAIN,www.$DOMAIN" \
    --redirect

# Verificar instalación
if [ $? -eq 0 ]; then
    echo "Certificado SSL instalado correctamente"
    echo "Configurando renovación automática..."
    
    # Verificar la renovación automática
    sudo certbot renew --dry-run
    
    # Agregar hook para recargar Nginx después de la renovación
    echo '#!/bin/bash' | sudo tee /etc/letsencrypt/renewal-hooks/post/nginx-reload.sh
    echo 'nginx -t && systemctl reload nginx' | sudo tee -a /etc/letsencrypt/renewal-hooks/post/nginx-reload.sh
    sudo chmod +x /etc/letsencrypt/renewal-hooks/post/nginx-reload.sh
    
    echo "Configuración completa"
else
    echo "Error al instalar el certificado SSL"
    exit 1
fi
