#!/bin/sh
set -e

# Create required directories
mkdir -p /srv/projects/mi-portfolio
mkdir -p /srv/projects/mi-portfolio/nginx
mkdir -p /srv/projects/mi-portfolio/certbot/conf
mkdir -p /srv/projects/mi-portfolio/certbot/www

# Copy configuration files if they exist
if [ -f "/app/nginx/portfolio.conf" ]; then
  cp /app/nginx/portfolio.conf /srv/projects/mi-portfolio/nginx/
fi

# Execute command passed to docker-compose
exec "$@"
