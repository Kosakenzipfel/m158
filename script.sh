#!/bin/bash

# Docker Compose ausführen
docker-compose up -d

# Warten, bis die Container gestartet sind
sleep 10

# MySQL-Dump erstellen
sudo mysqldump --password='Riethuesli>12345' moodle > dump.sql

# Dump in den MariaDB-Container laden
docker cp dump.sql dockercompose_mariadb_1:/

sleep 300

docker exec -i dockercompose_mariadb_1 bash -c "mysql -u root --password=root -e 'DROP DATABASE moodle; CREATE DATABASE moodle;'"

# In den MariaDB-Container wechseln und den Dump importieren
docker exec -i dockercompose_mariadb_1 mysql -u root --password=root moodle < ./dump.sql

# Aufräumen: Lokalen Dump entfernen
rm dump.sql
