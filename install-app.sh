#!/bin/bash
# 1. Actualizar el gestor de paquetes
dnf update -y

# 2. Instalar Apache, PHP y el cliente MariaDB compatible con MySQL
dnf install -y httpd php php-mysqlnd mariadb105

# 3. Descargar los archivos del laboratorio
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-RESTRT-1/267-lab-NF-build-vpc-web-server/s3/lab-app.zip
unzip lab-app.zip -d /var/www/html/

# 4. Encender y habilitar el servidor web Apache usando systemctl (El estándar moderno)
systemctl start httpd
systemctl enable httpd