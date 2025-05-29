# Despliegue sin Docker en VPS para pmdevop.com

Este documento proporciona instrucciones para desplegar la aplicación Next.js directamente en un VPS sin utilizar Docker, específicamente para el dominio pmdevop.com.

## Requisitos previos

- Un servidor VPS con Ubuntu/Debian
- Acceso SSH al servidor
- Dominio pmdevop.com configurado para apuntar a tu VPS
- Git instalado en el servidor

## Pasos para el despliegue

### 1. Configuración inicial del servidor

Conéctate a tu VPS mediante SSH:

```bash
ssh usuario@ip_del_servidor
```

Actualiza el sistema:

```bash
sudo apt-get update
sudo apt-get upgrade -y
```

### 2. Despliegue de la aplicación

Clona este repositorio en tu VPS o sube los scripts de despliegue:

```bash
git clone https://github.com/patohed/portfolioApp.git
cd portfolioApp/scripts
```

Edita los scripts `deploy-without-docker.sh` y `setup-ssl-without-docker.sh` para actualizar:
- El dominio: Cambia `tudominio.com` por tu dominio real
- El correo electrónico: Para el certificado SSL
- La URL del repositorio: Si es diferente

Haz que los scripts sean ejecutables:

```bash
chmod +x deploy-without-docker.sh
chmod +x setup-ssl-without-docker.sh
```

Ejecuta el script de despliegue:

```bash
./deploy-without-docker.sh
```

### 3. Configurar SSL (opcional pero recomendado)

Ejecuta el script para configurar SSL:

```bash
./setup-ssl-without-docker.sh
```

## Estructura de la aplicación desplegada

- La aplicación se instalará en `/var/www/domains/pmdevop.com/public_html`
- Nginx servirá la aplicación en el puerto 80/443
- PM2 gestionará el proceso de Node.js con el nombre "pmdevop"

## Mantenimiento

### Actualizar la aplicación

Para actualizar la aplicación cuando hayas realizado cambios en el repositorio:

```bash
cd /var/www/domains/pmdevop.com/public_html
git pull
npm install
npm run build
pm2 restart pmdevop
```

### Verificar el estado

Para verificar el estado de la aplicación:

```bash
pm2 status pmdevop
```

### Logs

Para ver los logs de la aplicación:

```bash
pm2 logs pmdevop
```

## Solución de problemas

Si la aplicación no responde:

1. Verifica el estado de PM2: `pm2 status`
2. Verifica los logs: `pm2 logs portfolio`
3. Verifica el estado de Nginx: `sudo systemctl status nginx`
4. Verifica los logs de Nginx: `sudo cat /var/log/nginx/error.log`
