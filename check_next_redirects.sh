#!/bin/bash

# Script para verificar y corregir redirecciones en la aplicación Next.js
# Ejecutar este script en el servidor VPS como root

echo "=== VERIFICACIÓN DE REDIRECCIONES EN NEXT.JS ==="
APP_DIR="/var/www/domains/pmdevop.com/public_html"

cd $APP_DIR
echo "Directorio actual: $(pwd)"

# Verificar si hay redirecciones en el código
echo "=== BUSCANDO REDIRECCIONES EN EL CÓDIGO ==="

echo "Buscando redirect a /lander en los archivos de la aplicación..."
grep -r --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" "redirect.*lander" .
grep -r --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" "push.*lander" .
echo ""

echo "Buscando middleware de redirección..."
if [ -f "./middleware.ts" ] || [ -f "./middleware.js" ]; then
  echo "Middleware encontrado, verificando contenido:"
  cat ./middleware.ts 2>/dev/null || cat ./middleware.js 2>/dev/null
else
  echo "No se encontró archivo de middleware."
fi
echo ""

# Verificar archivos de rutas
echo "=== VERIFICANDO ARCHIVOS DE RUTAS ==="
if [ -d "./app" ]; then
  echo "Estructura de directorios App Router encontrada"
  
  # Verificar rutas principales
  echo "Verificando archivos de rutas principales..."
  find ./app -type f -name "page.tsx" -o -name "page.js" -o -name "route.js" -o -name "route.ts" | head -n 10
  
  # Verificar si existe /lander como ruta
  if [ -d "./app/lander" ]; then
    echo "¡ENCONTRADO! Directorio /app/lander existe. Esto podría ser parte del problema."
    echo "Contenido del directorio /app/lander:"
    ls -la ./app/lander
    
    echo "Contenido de los archivos de ruta en /app/lander:"
    cat ./app/lander/page.tsx 2>/dev/null || cat ./app/lander/page.js 2>/dev/null || echo "No se encontró archivo page.js/tsx"
    cat ./app/lander/route.tsx 2>/dev/null || cat ./app/lander/route.js 2>/dev/null || echo "No se encontró archivo route.js/tsx"
  else
    echo "No se encontró directorio /app/lander."
  fi
fi

if [ -d "./pages" ]; then
  echo "Estructura de directorios Pages Router encontrada"
  
  # Verificar si existe /lander como página
  if [ -f "./pages/lander.js" ] || [ -f "./pages/lander.tsx" ] || [ -d "./pages/lander" ]; then
    echo "¡ENCONTRADO! Página o directorio /lander existe. Esto podría ser parte del problema."
    
    if [ -f "./pages/lander.js" ]; then
      echo "Contenido de pages/lander.js:"
      cat ./pages/lander.js
    fi
    
    if [ -f "./pages/lander.tsx" ]; then
      echo "Contenido de pages/lander.tsx:"
      cat ./pages/lander.tsx
    fi
    
    if [ -d "./pages/lander" ]; then
      echo "Contenido del directorio pages/lander:"
      ls -la ./pages/lander
    fi
  else
    echo "No se encontró página /lander."
  fi
fi

# Verificar archivos de configuración
echo "=== VERIFICANDO ARCHIVOS DE CONFIGURACIÓN ==="

if [ -f "./next.config.js" ] || [ -f "./next.config.ts" ]; then
  echo "Archivo de configuración Next.js encontrado:"
  cat ./next.config.js 2>/dev/null || cat ./next.config.ts 2>/dev/null
else
  echo "No se encontró archivo next.config.js/ts."
fi

echo ""
echo "=== RECOMENDACIÓN ==="
echo "Si encontraste redirecciones a /lander en el código, considera las siguientes opciones:"
echo "1. Modificar el código para eliminar la redirección"
echo "2. Crear una página en /lander que redirija automáticamente a la página principal"
echo "3. Configurar middleware para manejar esta ruta específica"
echo ""
echo "Ejemplo de una página que redirecciona (crear en pages/lander.js o app/lander/page.js):"
echo '---'
echo 'export default function LanderRedirect() {'
echo '  useEffect(() => {'
echo '    window.location.href = "/";'
echo '  }, []);'
echo '  return <div>Redirecting...</div>;'
echo '}'
echo '---'
echo ""
echo "Ejemplo de middleware para redireccionar /lander a / (crear en middleware.js):"
echo '---'
echo 'import { NextResponse } from "next/server";'
echo 'export function middleware(request) {'
echo '  if (request.nextUrl.pathname === "/lander") {'
echo '    return NextResponse.redirect(new URL("/", request.url));'
echo '  }'
echo '  return NextResponse.next();'
echo '}'
echo '---'
echo ""
