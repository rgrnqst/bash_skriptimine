# bash_skriptimine

Roger-Romeo Arm, ITS24

Haldustegevuste automatiseerimine - BASH haldusulesanded (repo asub /root/bash_skriptimine).

## Teenuste paigaldus - apache

apache_paigaldus.sh kontrollib dpkg-query ja grep abil, kas apache2 on paigaldatud. Kui ei ole, paigaldab selle apt-get abil. Kui on, annab teada. Molemal juhul naitab teenuse staatust.

Kaivitamine (root):

    chmod +x apache_paigaldus.sh
    sh apache_paigaldus.sh

Katsed:

- katse1_paigaldamine.log - apache2 polnud paigaldatud, skript paigaldas selle
- katse2_paigaldatud.log - apache2 oli olemas, skript andis teada ja naitas staatust
- tavakasutajana kaivitades annab skript veateate ja exit code 1

## Teenuste paigaldus - php

php_paigaldus.sh kontrollib dpkg-query ja grep abil pakette apache2, php, libapache2-mod-php ja php-mysql. Puuduvad paketid paigaldab apt-get abil ja taaskaivitab apache2. Molemal juhul naitab php asukohta, versiooni, php mooduli olekut ja apache2 staatust. Ubuntu 24.04 puhul on php versioon 8.3. Konfiguratsioonifaile muuta ei olnud vaja, libapache2-mod-php lulitab mooduli ise sisse.

Kaivitamine (root):

    chmod +x php_paigaldus.sh
    sh php_paigaldus.sh

Katsed:

- php_katse1_paigaldamine.log - php paketid puudusid, skript paigaldas need
- php_katse2_paigaldatud.log - koik paketid olid olemas, skript andis teada ja naitas tulemust
- php_katse3_osaline.log - php-mysql oli eemaldatud, skript paigaldas ainult selle
- tavakasutajana kaivitades annab skript veateate ja exit code 1
- test.php kaudu vastas apache2 "php tootab, versioon 8.3.6" ja mysqli laiendus oli olemas
