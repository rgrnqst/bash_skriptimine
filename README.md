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
