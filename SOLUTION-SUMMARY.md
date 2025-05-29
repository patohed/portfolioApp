# Solución de Problemas para Next.js en LiteSpeed

Este documento resume todos los archivos creados para solucionar los problemas de despliegue de la aplicación Next.js en un servidor LiteSpeed.

## Problemas Solucionados

1. **Redirección persistente a `/lander`**
2. **Página en blanco al acceder al sitio**
3. **Errores de recursos bloqueados (`ERR_BLOCKED_BY_CLIENT`)**
4. **Configuración incorrecta del proxy inverso**

## Archivos Creados

### Scripts Principales

| Archivo | Descripción |
|---------|-------------|
| `litespeed_optimized_deploy.sh` | Script completo de despliegue optimizado para LiteSpeed |
| `quick_fix.sh` | Solución rápida para problemas comunes sin redeployment completo |
| `check_next_redirects.sh` | Analiza el código para buscar redirecciones a `/lander` |
| `deployment_fix.sh` | Script de solución completa para todos los problemas |

### Scripts de Actualización

| Archivo | Descripción |
|---------|-------------|
| `update_github.sh` | Script bash para actualizar el repositorio en GitHub |
| `update_github.ps1` | Script PowerShell para actualizar el repositorio en GitHub |
| `update_from_github.sh` | Script para actualizar el VPS desde GitHub |
| `push_to_github.ps1` | Script PowerShell simplificado para subir cambios |

### Archivos de Configuración

| Archivo | Descripción |
|---------|-------------|
| `ecosystem.config.js` | Configuración actualizada de PM2 para usar servidor standalone |
| `start-server.js` | Script mejorado para iniciar la aplicación (detecta standalone) |

### Documentación

| Archivo | Descripción |
|---------|-------------|
| `DEPLOYMENT-INSTRUCTIONS.md` | Instrucciones detalladas de despliegue |
| `github_update_steps.md` | Pasos para actualizar el repositorio en GitHub |

## Próximos Pasos

1. **Subir los cambios a GitHub**:
   - Ejecuta `push_to_github.ps1` para subir todos los cambios

2. **Actualizar el VPS**:
   - Conéctate al VPS por SSH
   - Ejecuta:
     ```bash
     cd /var/www/domains/pmdevop.com/public_html
     git pull origin main
     chmod +x litespeed_optimized_deploy.sh
     ./litespeed_optimized_deploy.sh
     ```

3. **Verificar la aplicación**:
   - Visita https://pmdevop.com en modo incógnito
   - Verifica que no haya redirección a `/lander`
   - Verifica que la página no esté en blanco
   - Verifica que no haya errores de recursos bloqueados

## Mantenimiento Futuro

Para futuras actualizaciones, simplemente:

1. Haz tus cambios en el código
2. Ejecuta `push_to_github.ps1` para subir los cambios a GitHub
3. Ejecuta `update_from_github.sh` en el VPS para aplicar los cambios
