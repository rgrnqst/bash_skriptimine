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

## Teenuste paigaldus - mysql

mysql_paigaldus.sh paigaldab Oracle MySQL Server 8.0 ametlikust APT repositooriumist (mysql-apt-config 0.8.40). Enne kontrollib dpkg-query ja grep abil abipakette ja serverit, olemasolevat uuesti ei paigalda. Kusimustele annab vastused debconf-set-selections abil: serveri versioon, tools keelamine, root parool ja autentimine. Seejarel kaivitab teenuse, lulitab automaatkaivituse sisse, loob faili /root/.my.cnf oigustega 600 ja kontrollib tulemust. Parooli skript ekraanile ei naita.

Kaivitamine (root):

    chmod +x mysql_paigaldus.sh
    bash mysql_paigaldus.sh

Katsed:

- mysql_katse1_paigaldamine.log - mysql puudus, skript paigaldas Oracle MySQL 8.0.46, teenus on active ja enabled, mysql kask tootab ilma parooli sisestamata
- mysql_katse2_paigaldatud.log - kordusel oli koik olemas, skript ei paigaldanud midagi uuesti
- mysql_katse3_mycnf.log - ilma .my.cnf failita tuli Access denied (root parool on maaratud), skript loi faili uuesti
- tavakasutajana kaivitades annab skript veateate ja exit code 1
- mysql-apt-config jatab mysql.list faili ka mysql-tools rea, aga tools pakette ei paigaldatud
