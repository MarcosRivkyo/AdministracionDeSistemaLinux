#!/bin/bash

# Definir el directorio de origen y destino
ORIGEN_1="/sftp/"
ORIGEN_2="/home/"
ORIGEN_3="/etc/apache2/"

DESTINO="marcos@192.168.1.75:/var/backups/DIAserver/"

# Fecha para crear un archivo único
FECHA=$(date +%Y%m%d%H%M)

# Realizar la copia de seguridad
rsync -az --delete $ORIGEN_1 ${DESTINO}users_data_backup-$FECHA
rsync -az --delete $ORIGEN_2 ${DESTINO}users_home_backup-$FECHA
rsync -az --delete $ORIGEN_3 ${DESTINO}server_config_backup-$FECHA

# Mantener un log de las copias de seguridad
logger -t backup-script "Copia de seguridad realizada el $FECHA en $DESTINO"

