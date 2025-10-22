# 📘 Apuntes del módulo SRI — Administración de Sistemas Informáticos en Red

**Repositorio educativo interactivo** diseñado para el módulo **Servicios en Red (SRI)** del ciclo formativo de **ASIR**.  
Incluye apuntes, prácticas y ejemplos listos para ejecutar directamente en la nube mediante **GitHub Codespaces** o entornos Docker.

---

## 🚀 Descripción general

Este repositorio contiene material didáctico y técnico sobre los principales **servicios de red** vistos en el módulo SRI:

- 🌐 Servidores web y proxy (Apache, Nginx, Squid)
- 📧 Servidores de correo (Postfix, Dovecot)
- 🧩 Servidores DNS (BIND, CoreDNS)
- 🖧 DHCP, NFS, Samba y otros servicios de red
- 🐳 Prácticas con **Docker Compose** para simular entornos reales

Todo el contenido está pensado para **ejecución directa en la nube** (Codespaces o Gitpod) sin necesidad de instalación local.

---

## 🧠 Objetivos de aprendizaje

1. Comprender la instalación y configuración de los servicios de red más comunes.  
2. Desplegar servicios en entornos virtualizados o contenedorizados.  
3. Analizar logs, registros DNS y configuraciones.  
4. Trabajar de forma práctica en un entorno seguro y reproducible.

---

## ☁️ Ejecución en GitHub Codespaces

Puedes abrir este repositorio directamente en un entorno listo para usar:

[![Abrir en GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/)

Una vez dentro del Codespace:

```bash
# Clonar el repositorio
git clone https://github.com/<tu-usuario>/<nombre-repo>.git
cd <nombre-repo>

# Lanzar los servicios de práctica
docker compose up -d
```

> 💡 Todos los ejemplos incluyen archivos `docker-compose.yaml` preconfigurados para cada práctica.

---

## 🧩 Estructura del repositorio

```bash
├── docs/                # Documentación teórica y guías rápidas
├── talleres/            # Ejercicios prácticos por tema
│   ├── dns/             # Ejemplo de servidor CoreDNS
│   ├── web/             # Configuración Apache/Nginx
│   └── correo/          # Postfix/Dovecot
├── scripts/             # Utilidades y automatización
└── README.md            # Este fichero
```

---

## 🧾 Ejemplo destacado: Servidor CoreDNS

En el subdirectorio `practicas/dns/` encontrarás una guía completa para desplegar un servidor **CoreDNS** usando Docker Compose.  
Incluye:
- Explicación paso a paso.
- Archivos de configuración (`docker-compose.yaml`, `Corefile`, `db.tierramedia.jc`).
- Pruebas DNS y comandos básicos.

📘 [Ver guía completa de CoreDNS](./talleres/dns/CoreDNS/docker/README.md)

---

## 💻 Requisitos mínimos

- Navegador moderno (Chrome, Firefox, Edge...)
- Cuenta en GitHub con Codespaces habilitado
- (Opcional) Docker local si deseas ejecutar los ejemplos en tu máquina

---

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Puedes:
- Proponer nuevos ejemplos de servicios.
- Mejorar documentación o diagramas.
- Añadir scripts de automatización o tests.

Para contribuir:
```bash
git fork <repo>
git clone <tu-fork>
# crear rama de trabajo
git checkout -b mejora-documentacion
```

---

## 📜 Licencia

Este proyecto está licenciado bajo la **Creative Commons BY-NC-SA 4.0**.  
Puedes usar, adaptar y compartir el material citando la autoría de **Germán López Castro** y manteniendo la misma licencia.

---

### 🧑‍💻 Autor

**Germán López Castro**  

---

> ✨ *Repositorio educativo interactivo para el aprendizaje práctico de los servicios de red en ASIR.*

