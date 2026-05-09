#!/data/data/com.termux/files/usr/bin/bash

echo -e "\e[1;32m[*] تثبيت الأدوات الأساسية (PHP, MariaDB, Tmux, OpenSSL)...\e[0m"
# تثبيت الأدوات فقط بدون تحديث النظام كاملاً
pkg install php mariadb tmux openssl -y

echo -e "\e[1;32m[*] تنظيف العمليات السابقة لضمان تشغيل ناجح...\e[0m"
pkill mariadb
pkill mysqld
fuser -k 8080/tcp 2>/dev/null

echo -e "\e[1;32m[*] تشغيل قاعدة البيانات (MariaDB) بوضع التوافق مع أوراكل...\e[0m"
# استخدام وضع ORACLE ضروري لملف hr_populate.sql الخاص بك
mariadbd-safe -u root --sql-mode=ORACLE & 
sleep 8

echo -e "\e[1;32m[*] حل مشكلة الصلاحيات وإنشاء القاعدة (my_website)...\e[0m"
mariadb -u root <<EOF
USE mysql;
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('');
CREATE DATABASE IF NOT EXISTS my_website;
FLUSH PRIVILEGES;
EOF

echo -e "\e[1;32m[*] التحقق من ملف run.sh وتشغيله...\e[0m"
if [ -f "run.sh" ]; then
    chmod +x run.sh
    ./run.sh
else
    echo -e "\e[1;31m[!] تنبيه: ملف run.sh غير موجود في المجلد!\e[0m"
fi
