#!/bin/bash
# mysql_paigaldus.sh
# Autor: Roger-Romeo Arm, ITS24
# Paigaldab Oracle MySQL Server 8.0 ametlikust APT repositooriumist ilma
# kusimusteta (debconf-set-selections), kaivitab teenuse, loob root
# kasutajale .my.cnf faili ja kontrollib tulemust.
# Kaivitamine root kasutajana: bash mysql_paigaldus.sh

# set -e lopetab skripti kohe, kui moni kask annab vea
set -e
# apt ja dpkg ei kusi paigaldamise ajal midagi
export DEBIAN_FRONTEND=noninteractive

# Oracle APT repositooriumi konfiguratsioonipakett
CONF_PAKETT="mysql-apt-config_0.8.40-1_all.deb"
CONF_URL="https://dev.mysql.com/get/$CONF_PAKETT"
# MySQL root parool (laboriparool, sama mis juhendis)
ROOT_PAROOL="qwerty"
MY_CNF="/root/.my.cnf"

# dpkg-query annab paigaldatud paketi olekuks "install ok installed".
# grep -q ei valjasta midagi, ainult exit code: 0 = leitud, 1 = ei leitud.
# 2>/dev/null peidab veateate, kui paketti pole kunagi olnud.
on_paigaldatud() {
    dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "ok installed"
}

# Paigaldamiseks on vaja root oigusi (UID 0)
if [ "$(id -u)" -ne 0 ]; then
    echo "Viga: kaivita root kasutajana (sudo bash $0)"
    exit 1
fi

# 1. Abipaketid
# wget - konfiguratsioonipaketi allalaadimine
# ca-certificates - HTTPS uhenduse usaldamine
# gnupg - repositooriumi votmete kontroll
# debconf-utils - debconf vastuste haldamine
PUUDU=""
for PAKETT in wget ca-certificates gnupg debconf-utils; do
    if on_paigaldatud "$PAKETT"; then
        echo "$PAKETT on juba paigaldatud."
    else
        echo "$PAKETT ei ole paigaldatud."
        PUUDU="$PUUDU $PAKETT"
    fi
done

if [ -n "$PUUDU" ]; then
    echo "Paigaldan:$PUUDU"
    apt-get update -q
    # $PUUDU on jutumarkideta, et iga pakett oleks eraldi argument
    apt-get install -y -q $PUUDU
fi

# 2. MySQL server
# Oracle repositooriumi serveripakett on mysql-community-server
if on_paigaldatud mysql-community-server; then
    echo "MySQL server on juba paigaldatud."
else
    echo "MySQL server ei ole paigaldatud."
fi
