# AWS Cloud — VPC + Servidor Web con AWS CLI

Laboratorio práctico en el que se construye, desde cero y usando **AWS CLI**, una arquitectura de red básica en AWS y se despliega un servidor web (Apache + PHP) dentro de ella.

> ⚠️ **Disclaimer:** los IDs de recursos (VPC, subredes, security groups, etc.) que aparecen en la documentación solo existieron durante la sesión del laboratorio y ya no son válidos.

## 📋 Qué incluye

| Archivo | Descripción |
|---|---|
| [`descripcion.md`](./descripcion.md) | Guía paso a paso con todos los comandos de AWS CLI utilizados |
| [`install-app.sh`](./install-app.sh) | Script de *user-data* que se ejecuta al lanzar la instancia EC2: instala Apache, PHP, MariaDB y despliega la app de ejemplo |

## 🏗️ Arquitectura

1. **VPC** (`10.0.0.0/16`) con subredes públicas y privadas repartidas en **dos zonas de disponibilidad**
2. **Tablas de enrutamiento** independientes para tráfico público y privado
3. **Security Group** que habilita tráfico HTTP (puerto 80)
4. **Instancia EC2** en la subred pública, actuando como servidor web

```
                 ┌─────────────────────────────┐
                 │         VPC (10.0.0.0/16)    │
                 │                               │
   AZ us-west-2a │  ┌───────────┐  ┌───────────┐ │
                 │  │  Public   │  │  Private  │ │
                 │  │  subnet   │  │  subnet   │ │
                 │  └─────┬─────┘  └───────────┘ │
                 │        │                       │
   AZ us-west-2b │  ┌─────┴─────┐  ┌───────────┐ │
                 │  │  Public   │  │  Private  │ │
                 │  │ subnet-2  │  │ subnet-2  │ │
                 │  └───────────┘  └───────────┘ │
                 └─────────────────────────────┘
                        │
                 EC2 (Web-Server) — Apache/PHP
```

## 🚀 Cómo reproducirlo

1. Instalar AWS CLI:
   ```bash
   curl -fsSL https://awscli.amazonaws.com/v2/install.sh | bash
   ```
2. Configurar credenciales:
   ```bash
   aws configure
   ```
3. Verificar la conexión:
   ```bash
   aws sts get-caller-identity
   ```
4. Seguir el resto de los pasos detallados en [`descripcion.md`](./descripcion.md): creación de la VPC, subredes, tablas de enrutamiento, security group y lanzamiento de la instancia EC2.

## 🛠️ Servicios de AWS utilizados

- **VPC** — red virtual aislada
- **EC2** — instancia con Apache/PHP como servidor web
- **Security Groups** — control de tráfico entrante
- **Route Tables** — enrutamiento de subredes públicas y privadas

## 📚 Contexto

Laboratorio realizado como parte de la preparación práctica para la certificación **AWS Certified Cloud Practitioner**.
