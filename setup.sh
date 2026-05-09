#!/data/data/com.termux/files/usr/bin/bash

echo -e "\e[1;32m[*] تحديث الحزم وتثبيت PHP و MariaDB (موافقة تلقائية)...\e[0m"
# الموافقة التلقائية على كل التحديثات والتحميلات
pkg update -y && pkg upgrade -y
pkg install php mariadb -y

echo -e "\e[1;32m[*] جاري تشغيل قاعدة البيانات لضبط الإعدادات...\e[0m"
mysqld_safe -u root & 
sleep 5

echo -e "\e[1;32m[*] جاري ضبط مستخدم root وكلمة المرور الفارغة...\e[0m"
mariadb -u root <<EOF
use mysql;
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('');
CREATE DATABASE IF NOT EXISTS my_website;
FLUSH PRIVILEGES;
EOF

echo -e "\e[1;32m[*] إعطاء صلاحية التنفيذ لملف run.sh الموجود مسبقاً...\e[0m"
chmod +x run.sh

echo -e "\e[1;32m[*] اكتمل التثبيت والإعداد! جاري تشغيل run.sh الآن...\e[0m"
./run.sh
