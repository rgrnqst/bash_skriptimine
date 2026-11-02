#!/bin/sh
# php_paigaldus.sh
# Autor: Roger-Romeo Arm, ITS24
# Kontrollib, kas php ja veebiserveri jaoks vajalikud paketid on paigaldatud.

# apache2 - veebiserver, mille sees php tootab
# php - php interpretaator
# libapache2-mod-php - apache2 moodul php failide tootlemiseks
# php-mysql - php uhendus mysql andmebaasiga
PAKETID="apache2 php libapache2-mod-php php-mysql"

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
