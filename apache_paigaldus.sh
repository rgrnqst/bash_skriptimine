#!/bin/sh
# apache_paigaldus.sh
# Autor: Roger-Romeo Arm, ITS24
# Kontrollib, kas veebiserver apache2 on paigaldatud.
# Kui ei ole, paigaldab selle. Kui on, annab teada ja naitab teenuse staatust.
# Kaivitamine root kasutajana: sh apache_paigaldus.sh

TEENUS=apache2

# Paigaldamiseks on vaja root oigusi (UID 0)
if [ "$(id -u)" -ne 0 ]; then
    echo "Viga: kaivita root kasutajana (sudo sh $0)"
    exit 1
fi

# dpkg-query annab paigaldatud paketi olekuks "install ok installed".
# grep -q ei valjasta midagi, ainult exit code: 0 = leitud, 1 = ei leitud.
# 2>/dev/null peidab veateate, kui paketti pole kunagi olnud.
dpkg-query -W -f='${Status}' "$TEENUS" 2>/dev/null | grep -q "ok installed"
OLEK=$?

if [ "$OLEK" -eq 0 ]; then
    # Teenus on olemas - anname teada ja naitame staatust
    echo "$TEENUS on juba paigaldatud."
    systemctl status "$TEENUS" --no-pager
else
    # Teenust ei ole - uuendame paketinimekirja ja paigaldame
    echo "$TEENUS ei ole paigaldatud, paigaldan..."
    export DEBIAN_FRONTEND=noninteractive   # apt ei kusi midagi
    apt-get update -q
    if apt-get install -y -q "$TEENUS"; then
        echo "$TEENUS paigaldati edukalt."
        systemctl status "$TEENUS" --no-pager
    else
        echo "Viga: $TEENUS paigaldamine ebaonnestus."
        exit 2
    fi
fi
