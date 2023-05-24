#!/bin/bash

# Docker Compose ausführen
docker-compose up -d

#10 Sekunden warten, bis die Container gestartet sind, sodass der Dump erstellt werden kann
sleep 10

# MySQL-Dump erstellen aus alter Moodle-Datenbank
sudo mysqldump --password='Riethuesli>12345' moodle > dump.sql

# Dump in den neu erstellten MariaDB-Container laden
docker cp dump.sql dockercompose_mariadb_1:/

#5 Minuten warten, bis die Container eine Verbindung haben
sleep 300

#im neu erstellten Datenbankcontainer die Datenbank "moodle" erstellen
docker exec -i dockercompose_mariadb_1 bash -c "mysql -u root --password=root -e 'DROP DATABASE moodle; CREATE DATABASE moodle;'"

# Im  MariaDB-Container einen Befehl ausführen, um den oben erstellten Dump zu importieren
docker exec -i dockercompose_mariadb_1 mysql -u root --password=root moodle < ./dump.sql

# Aufräumen: Lokalen Dump löschen
rm dump.sql
