#!/bin/sh
# apache_paigaldus.sh - versioon 1: ainult paigalduse kontroll
TEENUS=apache2
dpkg-query -W -f='${Status}' "$TEENUS" 2>/dev/null | grep -q "ok installed"
if [ $? -eq 0 ]; then
    echo "$TEENUS on paigaldatud"
else
    echo "$TEENUS ei ole paigaldatud"
fi
