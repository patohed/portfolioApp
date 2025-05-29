# Instrucciones de Despliegue para pmdevop.com

Este documento explica cómo desplegar correctamente la aplicación Next.js en un servidor VPS con LiteSpeed.

## Descripción de los Scripts

### Scripts para actualización:

1. **update_github.sh**
   - Actualiza el repositorio en GitHub
   - Debe ejecutarse en tu máquina local

2. **update_from_github.sh**
   - Actualiza el servidor VPS desde GitHub
   - Debe ejecutarse en el servidor VPS

### Scripts para solución de problemas:

1. **litespeed_optimized_deploy.sh**
   - Script completo de despliegue optimizado para LiteSpeed
   - Configura correctamente la aplicación Next.js con output: 'standalone'
   - Configura LiteSpeed para manejar correctamente el proxy y archivos estáticos

2. **quick_fix.sh**
   - Solución rápida para problemas comunes
   - No realiza un despliegue completo, solo corrige configuraciones

3. **check_next_redirects.sh**
   - Analiza la aplicación para encontrar redirecciones a /lander en el código

## Proceso de Actualización

### Paso 1: Actualizar GitHub

En tu máquina local:

```bash
# Hacer que el script sea ejecutable (solo necesario la primera vez)
chmod +x update_github.sh

# Ejecutar el script
./update_github.sh
```

### Paso 2: Actualizar el VPS

En el servidor VPS:

```bash
# Hacer que el script sea ejecutable (solo necesario la primera vez)
chmod +x update_from_github.sh

# Ejecutar el script
./update_from_github.sh
```

## Solución de Problemas Comunes

### Problema: Redirección a /lander

Si la aplicación sigue redirigiendo a /lander:

1. Verifica si hay redirecciones en el código:
   ```bash
   ./check_next_redirects.sh
   ```

2. Aplica la solución rápida:
   ```bash
   ./quick_fix.sh
   ```

### Problema: Página en blanco

Si la aplicación muestra una página en blanco:

1. Verifica que la aplicación esté corriendo:
   ```bash
   pm2 status
   ```

2. Verifica los logs:
   ```bash
   pm2 logs pmdevop
   ```

3. Aplica un despliegue completo:
   ```bash
   ./litespeed_optimized_deploy.sh
   ```

### Problema: Recursos bloqueados (ERR_BLOCKED_BY_CLIENT)

1. Verifica la configuración de LiteSpeed:
   ```bash
   cat /usr/local/lsws/conf/vhosts/pmdevop.com/vhconf.conf
   ```

2. Asegúrate de que las cabeceras CORS estén correctamente configuradas:
   ```bash
   ./fix_blocked_resources.sh
   ```

## Configuración de Nginx (alternativa)

Si decides usar Nginx en lugar de LiteSpeed, hemos incluido una configuración de Nginx en el directorio `nginx/`:

- `nginx/portfolio.conf`: Configuración optimizada para Next.js
