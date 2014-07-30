#!/bin/sh
# System + MySQL backup script
# Copyright (c) 2008 Marchost
# This script is licensed under GNU GPL version 2.0 or above
# ---------------------------------------------------------------------

#########################
######TO BE MODIFIED#####

### System Setup ###
BACKUP=YOUR_LOCAL_BACKUP_DIR

### MySQL Setup ###
MUSER="MYSQL_USER"
MPASS="MYSQL_USER_PASSWORD"
MHOST="localhost"



######DO NOT MAKE MODIFICATION BELOW#####
#########################################

### Binaries ###
TAR="$(which tar)"
GZIP="$(which gzip)"
FTP="$(which ftp)"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"

### Today + hour in 24h format ###
NOW=$(date +"%d%H")

### Create hourly dir ###

mkdir $BACKUP/$NOW

### Get all databases name ###
DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
for db in $DBS
do

  ### Create dir for each databases, backup tables in individual files ###
    mkdir $BACKUP/$NOW/$db

      for i in `echo "show tables" | $MYSQL -u $MUSER -h $MHOST -p$MPASS $db|grep -v Tables_in_`;
          do
                FILE=$BACKUP/$NOW/$db/$i.sql.gz
                    echo $i; $MYSQLDUMP --add-drop-table --allow-keywords -q -c -u $MUSER -h $MHOST -p$MPASS $db $i | $GZIP -9 > $FILE
                     
             done
done

                    


