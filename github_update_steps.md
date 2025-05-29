# Comandos para subir todos los cambios a GitHub

## 1. Verificar los archivos nuevos y modificados

Para ver qué archivos se han creado o modificado:

```powershell
git status
```

## 2. Subir todos los cambios con un solo comando

```powershell
# Agregar todos los archivos nuevos y modificados
git add .

# Crear un commit con un mensaje descriptivo
git commit -m "Añadidos scripts de despliegue optimizados para LiteSpeed y solución de problemas"

# Subir los cambios a GitHub
git push origin main
```

## 3. Verificar que los cambios se subieron correctamente

Puedes verificar que los cambios se subieron correctamente visitando tu repositorio en GitHub:

```
https://github.com/TU_USUARIO/TU_REPOSITORIO
```

## 4. Comandos para ejecutar en el VPS después de la actualización

Una vez que los cambios estén en GitHub, conéctate al VPS por SSH y ejecuta:

```bash
# Ir al directorio de la aplicación
cd /var/www/domains/pmdevop.com/public_html

# Actualizar desde GitHub
git pull origin main

# Hacer ejecutables los scripts
chmod +x litespeed_optimized_deploy.sh quick_fix.sh check_next_redirects.sh fix_blocked_resources.sh update_from_github.sh

# Ejecutar el script de despliegue optimizado
./litespeed_optimized_deploy.sh
```

## 5. Verificar que la aplicación funciona correctamente

Visita tu sitio web en modo incógnito para verificar:
- No hay redirección a /lander
- La página no está en blanco
- No hay errores de recursos bloqueados en la consola del navegador

Si encuentras algún problema:
```bash
# Para problemas específicos
./quick_fix.sh

# Para un diagnóstico completo
./full_diagnostic.sh
```
