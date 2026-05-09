#!/bin/bash

SESSION="my_project"

echo "--- جاري تنظيف العمليات القديمة لضمان تشغيل ناجح ---"

# 1. إغلاق أي نسخة سابقة من PHP و MariaDB و tmux
pkill -f php
pkill -f mariadb
pkill -f mysqld
tmux kill-session -t $SESSION 2>/dev/null

# انتظر ثانية لضمان تحرر المنافذ (Ports)
sleep 1

echo "--- جاري تشغيل بيئة العمل الجديدة ---"

# 2. إنشاء جلسة tmux جديدة في الخلفية
tmux new-session -d -s $SESSION

# 3. تشغيل MariaDB في القسم الأول (يسار)
tmux send-keys -t $SESSION.0 'mariadbd-safe -u root' C-m

# 4. تقسيم الشاشة أفقياً لإنشاء قسم ثانٍ (يمين)
tmux split-window -h -t $SESSION

# 5. تشغيل خادم PHP في القسم الثاني (يمين)
# أضفنا sleep 3 ليعطي وقتاً كافياً لـ MariaDB لتبدأ العمل
tmux send-keys -t $SESSION.1 'sleep 3 && php -S 127.0.0.1:8080' C-m

# 6. الدخول إلى الجلسة
echo "✅ تم التجهيز! جاري الدخول إلى واجهة التحكم..."
tmux attach-session -t $SESSION

