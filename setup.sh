#!/data/data/com.termux/files/usr/bin/bash

echo -e "\e[1;32m[*] 1. تثبيت الأدوات الأساسية (PHP, MariaDB, Tmux, OpenSSL)...\e[0m"
# تثبيت الأدوات اللازمة لضمان عدم ظهور أخطاء "command not found"
pkg install php mariadb tmux openssl -y

echo -e "\e[1;32m[*] 2. تنظيف العمليات السابقة لضمان تشغيل ناجح...\e[0m"
# إنهاء أي عمليات قديمة لفتح المنافذ والقاعدة
pkill mariadb
pkill mysqld
fuser -k 8080/tcp 2>/dev/null

echo -e "\e[1;32m[*] 3. تشغيل قاعدة البيانات بوضع التوافق مع أوراكل...\e[0m"
# تفعيل وضع ORACLE ضروري لملف hr_populate.sql الخاص بك
mariadbd-safe -u root --sql-mode=ORACLE & 
sleep 8

echo -e "\e[1;32m[*] 4. حل مشكلة الصلاحيات وإنشاء القاعدة (my_website)...\e[0m"
# ضبط المستخدم ليكون بدون كلمة مرور متوافقاً مع السطر 7 في index.php
mariadb -u root <<EOF
USE mysql;
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('');
CREATE DATABASE IF NOT EXISTS my_website;
FLUSH PRIVILEGES;
EOF

echo -e "\e[1;32m[*] 5. استيراد بيانات الموظفين (HR Data)...\e[0m"
# رفع جداول البيانات إلى القاعدة الجديدة
if [ -f "hr_populate.sql" ]; then
    mariadb -u root my_website < hr_populate.sql
    echo -e "\e[1;32m[*] تم استيراد البيانات بنجاح.\e[0m"
else
    echo -e "\e[1;31m[!] تنبيه: ملف hr_populate.sql غير موجود للاستيراد.\e[0m"
fi

echo -e "\e[1;32m[*] 6. التحقق من ملف run.sh وتشغيله...\e[0m"
if [ -f "run.sh" ]; then
    chmod +x run.sh
    ./run.sh
else
    echo -e "\e[1;31m[!] تنبيه: ملف run.sh غير موجود في المجلد!\e[0m"
fi
