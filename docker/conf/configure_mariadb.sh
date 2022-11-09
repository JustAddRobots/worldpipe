#!/usr/bin/env bash

# Remove anonymous user
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "DROP USER IF EXISTS ''@'localhost'"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "DROP USER IF EXISTS ''@'$(hostname)'"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "DROP USER IF EXISTS ''@'$(hostname).local'"

# Remove test database
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "DROP DATABASE IF EXISTS test"

# Create admin user
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER IF NOT EXISTS '$MYSQL_ADMIN_USER'@'localhost' IDENTIFIED BY '$MYSQL_ADMIN_PASSWORD'"

# Create teamcity user
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER IF NOT EXISTS '$MYSQL_TEAMCITY_USER'@'localhost' IDENTIFIED BY '$MYSQL_TEAMCITY_PASSWORD'"

# Create teamcity database
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS teamcity COLLATE utf8mb4_bin"

# Grant privileges
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON teamcity.* TO '$MYSQL_TEAMCITY_USER'@'localhost'"
