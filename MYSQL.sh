#!/bin/bash

# Variables
Contrasena="1234"
DB_NAME="lamp_db"
DB_USER="fabio"
APACHE_IP="192.168.57.10"

# Actualizar paquetes e instalar MARIADB
sudo apt-get update
sudo apt-get install -y mariadb-server mariadb-client git
# Configurar MySQL para permitir conexiones remotas
sudo sed -i "s/bind-address.*/bind-address = 192.168.57.11/" /etc/mysql/mariadb.conf.d/50-server.cnf
sudo systemctl restart mariadb

# Crear base de datos y usuario para la VM Apache
sudo mariadb -u root -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
sudo mariadb -u root -e "CREATE USER IF NOT EXISTS '$DB_USER'@'$APACHE_IP' IDENTIFIED BY '$Contrasena';"
sudo mariadb -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$APACHE_IP';"
sudo mariadb -u root -e "FLUSH PRIVILEGES;"

