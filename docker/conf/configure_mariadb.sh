#!/usr/bin/env bash

echo "Remove anonymous user..."
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "DROP USER IF EXISTS ''@'localhost'"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "DROP USER IF EXISTS ''@'$(hostname)'"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "DROP USER IF EXISTS ''@'$(hostname).local'"

echo "Remove test database..."
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "DROP DATABASE IF EXISTS test"

echo "Create admin user..."
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER IF NOT EXISTS '$MYSQL_ADMIN_USER'@'localhost' IDENTIFIED BY '$MYSQL_ADMIN_PASSWORD'"

echo "Create teamcity user..."
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER IF NOT EXISTS '$MYSQL_TEAMCITY_USER'@'localhost' IDENTIFIED BY '$MYSQL_TEAMCITY_PASSWORD'"

echo "Create teamcity database..."
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS teamcity COLLATE utf8mb4_bin"

echo "Grant privileges..."
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON teamcity.* TO '$MYSQL_TEAMCITY_USER'@'localhost'"

echo "Flush privileges..."
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES"
