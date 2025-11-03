#!/bin/bash

# Variables
Contrasena="1234"
MARIADB_IP="192.168.57.11"

# Actualizar paquetes e instalar Apache, PHP, Git y cliente MySQL
sudo apt-get update
sudo apt-get install -y apache2 php libapache2-mod-php php-mysql git mariadb-client
# Copiar y configurar virtual host
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/practica.conf
sudo sed -i 's|/var/www/html|/var/www/html/practica/src|g' /etc/apache2/sites-available/practica.conf
sudo a2dissite 000-default.conf
sudo a2ensite practica.conf
sudo systemctl restart apache2

# Clonar el repositorio
sudo git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /var/www/html/practica

# Configurar config.php con la IP de la VM MySQL
sudo sed -i "s|define('DB_HOST', '.*');|define('DB_HOST', '$MARIADB_IP');|" /var/www/html/practica/src/config.php
sudo sed -i "s|define('DB_NAME', '.*');|define('DB_NAME', 'lamp_db');|" /var/www/html/practica/src/config.php
sudo sed -i "s|define('DB_USER', '.*');|define('DB_USER', 'fabio');|" /var/www/html/practica/src/config.php
sudo sed -i "s|define('DB_PASSWORD', '.*');|define('DB_PASSWORD', '$Contrasena');|" /var/www/html/practica/src/config.php

# Importar base de datos desde la VM MySQL
mariadb -h $MARIADB_IP -u fabio -p$Contrasena lamp_db < /var/www/html/practica/db/database.sql

# Limpiar archivos innecesarios
sudo rm /var/www/html/practica/README.md
sudo rm -R /var/www/html/practica/db

