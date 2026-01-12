#!/bin/bash

# صدمة - سكريبت النشر على GitHub Pages
# Sodfa - GitHub Pages Deployment Script

echo "🚀 بدء نشر صدمة على GitHub Pages..."
echo ""

# التحقق من وجود الملف
if [ ! -f "index.html" ]; then
    echo "❌ خطأ: ملف index.html غير موجود!"
    exit 1
fi

# طلب اسم المستخدم والمستودع
read -p "أدخل اسم مستخدم GitHub الخاص بك: " GH_USER
read -p "أدخل اسم المستودع (مثال: sodfa-chat): " REPO_NAME

echo ""
echo "📤 جاري رفع الملفات إلى GitHub..."

# تهيئة Git إذا لم يكن موجوداً
if [ ! -d ".git" ]; then
    git init
    git add .
    git commit -m "Initial commit - صدمة chat app"
fi

# إضافة المستودع البعيد
git remote remove origin 2>/dev/null
git remote add origin "https://github.com/$GH_USER/$REPO_NAME.git"

# طلب التوكن
echo ""
echo "🔑 تحتاج إلى Personal Access Token من GitHub:"
echo "   اذهب إلى: https://github.com/settings/tokens"
echo "   أنشئ توكن جديد مع صلاحية: repo, workflow"
read -s -p "أدخل التوكن هنا: " GH_TOKEN

echo ""
echo "📤 جاري رفع الملفات..."

# استخدام التوكن في URL
git credential-cache store <<EOF
protocol=https
host=github.com
username=$GH_USER
password=$GH_TOKEN
EOF

# رفع الملفات
git push -u origin main 2>/dev/null || git push -u origin master

echo ""
echo "✅ تم رفع الملفات بنجاح!"
echo ""
echo "⚙️ جاري تفعيل GitHub Pages..."

# تفعيل GitHub Pages (يتطلب GitHub CLI)
if command -v gh &> /dev/null; then
    gh repo view "$GH_USER/$REPO_NAME" --json isPublic 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "✅ المستودع موجود"
        echo ""
        echo "📋 للتفعيل اليدوي:"
        echo "   1. اذهب إلى: https://github.com/$GH_USER/$REPO_NAME/settings/pages"
        echo "   2. اختر Source: main (or master)"
        echo "   3. اضغط Save"
        echo ""
        echo "🌐 رابط التطبيق سيكون:"
        echo "   https://$GH_USER.github.io/$REPO_NAME/"
    fi
else
    echo "📋 للتفعيل اليدوي:"
    echo "   1. اذهب إلى: https://github.com/$GH_USER/$REPO_NAME/settings/pages"
    echo "   2. اختر Source: main (or master)"
    echo "   3. اضغط Save"
    echo ""
    echo "🌐 رابط التطبيق سيكون:"
    echo "   https://$GH_USER.github.io/$REPO_NAME/"
fi

echo ""
echo "🎉 تم الانتهاء! يمكن استخدام التطبيق خلال دقائق."
