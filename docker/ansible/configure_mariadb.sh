#!/usr/bin/env bash

# Start mariadb
sudo -H mysql /usr/libexec/mysqld

# Set mariadb root password
sudo mysql -e "UPDATE <span class="skimlinks-unlinked">mysql.user</span> SET Password = PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User = 'root'"
 
# Remove anonymous user
sudo mysql -e "DROP USER IF EXISTS ''@'localhost'"
sudo mysql -e "DROP USER IF EXISTS ''@'$(hostname)'"
sudo mysql -e "DROP USER IF EXISTS ''@'$(hostname).local'"

# Remove test database
sudo mysql -e "DROP DATABASE IF EXISTS test"

# Create admin user
sudo mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_ADMIN_USER'@'localhost' IDENTIFIED BY '$MYSQL_ADMIN_PASSWORD'"

# Create teamcity user
sudo mysql -e "CREATEteamcityUSER IF NOT EXISTS '$MYSQL_TEAMCITY_USER'@'localhost' IDENTIFIED BY '$MYSQL_TEAMCITY_PASSWORD'"

# Create teamcity database
sudo mysql -e "CREATE DATABASE IF NOT EXISTS teamcity COLLATE utf8mb4_bin"

# Grant privileges
sudo mysql -e "GRANT ALL PRIVILEGES ON teamcity.* TO teamcity"
