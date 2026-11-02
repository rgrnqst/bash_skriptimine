#!/bin/sh
# php_paigaldus.sh
# Autor: Roger-Romeo Arm, ITS24
# Kontrollib, kas php ja veebiserveri jaoks vajalikud paketid on paigaldatud.
# Puuduvad paketid paigaldab. Molemal juhul naitab php asukohta, versiooni,
# php mooduli olekut ja apache2 teenuse staatust.
# Kaivitamine root kasutajana: sh php_paigaldus.sh

# apache2 - veebiserver, mille sees php tootab
# php - php interpretaator
# libapache2-mod-php - apache2 moodul php failide tootlemiseks
# php-mysql - php uhendus mysql andmebaasiga
PAKETID="apache2 php libapache2-mod-php php-mysql"

# Paigaldamiseks on vaja root oigusi (UID 0)
if [ "$(id -u)" -ne 0 ]; then
    echo "Viga: kaivita root kasutajana (sudo sh $0)"
    exit 1
fi

# dpkg-query annab paigaldatud paketi olekuks "install ok installed".
# grep -q ei valjasta midagi, ainult exit code: 0 = leitud, 1 = ei leitud.
# 2>/dev/null peidab veateate, kui paketti pole kunagi olnud.
PUUDU=""
for PAKETT in $PAKETID; do
    if dpkg-query -W -f='${Status}' "$PAKETT" 2>/dev/null | grep -q "ok installed"; then
        echo "$PAKETT on juba paigaldatud."
    else
        echo "$PAKETT ei ole paigaldatud."
        PUUDU="$PUUDU $PAKETT"
    fi
done

# Kui midagi puudub, uuendame paketinimekirja ja paigaldame ainult puuduvad
if [ -n "$PUUDU" ]; then
    echo "Paigaldan:$PUUDU"
    export DEBIAN_FRONTEND=noninteractive   # apt ei kusi midagi
    apt-get update -q
    # $PUUDU on jutumarkideta, et iga pakett oleks eraldi argument
    if apt-get install -y -q $PUUDU; then
        echo "Paketid paigaldati edukalt."
        # apache2 laeb php mooduli alles taaskaivitusel
        systemctl restart apache2
    else
        echo "Viga: paigaldamine ebaonnestus."
        exit 1
    fi
fi

# Molemal juhul naitame tulemust
which php
php -v | head -n 1

# apache2ctl -M loetleb laaditud moodulid, php moodul peab nende seas olema
if apache2ctl -M 2>/dev/null | grep -q php; then
    echo "php moodul on apache2 sees laaditud."
else
    echo "Viga: php moodul ei ole apache2 sees laaditud."
    exit 1
fi
systemctl status apache2 --no-pager
