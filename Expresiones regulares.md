
# Guía Práctica de Expresiones Regulares y Configuración para .htaccess

Aprende a manejar expresiones regulares y configuraciones avanzadas en Apache.

---

## 1. Conceptos Básicos de Expresiones Regulares

- `.`: Coincide con cualquier carácter excepto un salto de línea.
- `^`: Indica el inicio de una cadena.
- `$`: Indica el final de una cadena.
- `*`: Cero o más repeticiones.
- `+`: Una o más repeticiones.
- `?`: Cero o una repetición (opcional).
- `{n,m}`: Entre *n* y *m* repeticiones.
- `[]`: Define un conjunto de caracteres. Ejemplo: `[abc]` coincide con **a**, **b** o **c**.
- `|`: Alternativa. Ejemplo: `a|b` coincide con **a** o **b**.
- `()` Agrupamiento para aplicar operadores o capturar coincidencias.

---

## 2. Uso de Expresiones con % en .htaccess

Apache permite usar variables especiales que comienzan con `%` para trabajar con valores dinámicos del entorno o el servidor.

### Variables del Entorno Comunes

- `%{HTTP_HOST}`: Dominio en la solicitud.
- `%{REQUEST_URI}`: Ruta y archivo solicitados (sin parámetros).
- `%{QUERY_STRING}`: Parámetros en la URL (después de `?`).
- `%{REMOTE_ADDR}`: Dirección IP del visitante.
- `%{HTTP_USER_AGENT}`: Navegador del usuario.
- `%{HTTPS}`: Indica si la solicitud usa HTTPS (`on` o vacío).

---

## 3. Ejemplos Prácticos de Configuración

### 3.1 Redirección de HTTP a HTTPS

```apache
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}/$1 [R=301,L]
```

### 3.2 Bloquear Acceso por IP

```apache
RewriteEngine On
RewriteCond %{REMOTE_ADDR} ^192\.168\.1\.[0-9]+$
RewriteRule ^ - [F,L]
```

### 3.3 Bloquear Acceso por Extensión

```apache
RewriteEngine On
RewriteRule \.(exe|bat|sh|php)$ - [F,L]
```

### 3.4 Redirección de URLs Antiguas

```apache
RewriteEngine On
RewriteRule ^antigua-pagina\.html$ /nueva-pagina.html [R=301,L]
```

---

## 4. Herramientas para Probar Expresiones Regulares

- [Regex101](https://regex101.com): Analizador interactivo para probar expresiones regulares.
- [htaccess Tester](https://htaccess.madewithlove.com/): Herramienta para probar configuraciones .htaccess.

---

Este documento cubre los conceptos más comunes y avanzados para manejar expresiones regulares y variables dinámicas en `.htaccess`.
