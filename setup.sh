#!/data/data/com.termux/files/usr/bin/bash

echo -e "\e[1;32m[*] 1. إصلاح المكتبات وتحديث الحزم (حل مشكلة libcrypto)...\e[0m"
# التحديث الشامل يحل مشكلة CANNOT LINK EXECUTABLE
pkg update -y && pkg upgrade -y

echo -e "\e[1;32m[*] 2. تثبيت الأدوات اللازمة (PHP, MariaDB, Git, Tmux)...\e[0m"
# أضفنا tmux لحل مشكلة "command not found" و git للتأكد من وجوده
pkg install php mariadb git tmux openssl -y

echo -e "\e[1;32m[*] 3. إغلاق أي عمليات قديمة لضمان تشغيل نظيف...\e[0m"
pkill mariadb
pkill mysqld
fuser -k 8080/tcp 2>/dev/null

echo -e "\e[1;32m[*] 4. تشغيل قاعدة البيانات في الخلفية...\e[0m"
# تشغيل القاعدة مع وضع التوافق مع أوراكل لملف الـ SQL الخاص بك
mariadbd-safe -u root --sql-mode=ORACLE & 
sleep 8

echo -e "\e[1;32m[*] 5. ضبط الصلاحيات وإنشاء قاعدة البيانات (حل مشكلة Access Denied)...\e[0m"
mariadb -u root <<EOF
USE mysql;
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('');
CREATE DATABASE IF NOT EXISTS my_website;
FLUSH PRIVILEGES;
EOF

echo -e "\e[1;32m[*] 6. إعطاء صلاحية التنفيذ لملف run.sh...\e[0m"
if [ -f "run.sh" ]; then
    chmod +x run.sh
    echo -e "\e[1;32m[*] اكتمل التثبيت! جاري تشغيل المشروع الآن...\e[0m"
    ./run.sh
else
    echo -e "\e[1;31m[!] خطأ: ملف run.sh غير موجود في المجلد الحالي!\e[0m"
fi
