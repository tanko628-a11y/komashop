#!/bin/bash

# Discord 進捗報告スクリプト
# 凪フィナンシャル SHOP フッター・Contact Form 7 実装
# 実行: 毎日朝6時

WEBHOOK_URL="https://discord.com/api/webhooks/1488527371161178112/HC0-LmOUZknN87KnuYk0NapMqJWFI6jRfizlvmsR68hmQ5gVehKRvCAvR2N2ZGu95h0s"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# ========================================
# 進捗確認関数
# ========================================

check_footer_status() {
    if grep -q "site-footer" /var/www/html/wp-content/themes/*/footer.php 2>/dev/null; then
        echo "✅ フッター実装: 完了"
        return 0
    else
        echo "⏳ フッター実装: 未実装"
        return 1
    fi
}

check_contact_form_status() {
    if grep -q "nagi_contact_form_configured" /var/www/html/wp-content/plugins/contact-form-7/* 2>/dev/null; then
        echo "✅ Contact Form 7: 設定完了"
        return 0
    else
        echo "⏳ Contact Form 7: 設定中"
        return 1
    fi
}

check_mail_config_status() {
    if grep -q "kei@komasanshop.com" /var/www/html/wp-content/plugins/contact-form-7/* 2>/dev/null; then
        echo "✅ メール設定: kei@komasanshop.com に配置"
        return 0
    else
        echo "⏳ メール設定: 未設定"
        return 1
    fi
}

check_recaptcha_status() {
    if grep -q "recaptcha" /var/www/html/wp-content/plugins/contact-form-7/* 2>/dev/null; then
        echo "✅ reCAPTCHA v3: 実装済み"
        return 0
    else
        echo "⏳ reCAPTCHA v3: 設定待ち"
        return 1
    fi
}

check_test_status() {
    # テストメールログを確認
    if tail -20 /var/log/mail.log 2>/dev/null | grep -q "kei@komasanshop.com"; then
        echo "✅ テストメール: 受信確認"
        return 0
    else
        echo "⏳ テストメール: 未実施"
        return 1
    fi
}

# ========================================
# Discord メッセージ作成
# ========================================

create_discord_message() {

    # 進捗情報取得
    FOOTER=$(check_footer_status)
    CONTACT_FORM=$(check_contact_form_status)
    MAIL=$(check_mail_config_status)
    RECAPTCHA=$(check_recaptcha_status)
    TEST=$(check_test_status)

    # メッセージ本文
    MESSAGE=$(cat <<EOF
{
  "username": "凪フィナンシャル 自動報告",
  "avatar_url": "https://www.komashikifx.site/logo.png",
  "embeds": [
    {
      "title": "🌅 朝6時 進捗報告",
      "description": "WordPress フッター・Contact Form 7 実装状況",
      "color": 3066993,
      "fields": [
        {
          "name": "📅 報告日時",
          "value": "${TIMESTAMP}",
          "inline": false
        },
        {
          "name": "🏗️ フッター実装",
          "value": "${FOOTER}",
          "inline": true
        },
        {
          "name": "📧 Contact Form 7",
          "value": "${CONTACT_FORM}",
          "inline": true
        },
        {
          "name": "✉️ メール送信先",
          "value": "${MAIL}",
          "inline": true
        },
        {
          "name": "🔐 reCAPTCHA v3",
          "value": "${RECAPTCHA}",
          "inline": true
        },
        {
          "name": "🧪 テスト実施",
          "value": "${TEST}",
          "inline": true
        }
      ],
      "footer": {
        "text": "凪フィナンシャル 自動進捗報告システム",
        "icon_url": "https://www.komashikifx.site/favicon.ico"
      },
      "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)"
    }
  ]
}
EOF
)

    echo "$MESSAGE"
}

# ========================================
# Discord に送信
# ========================================

send_to_discord() {

    MESSAGE=$(create_discord_message)

    # cURL で POST
    curl -X POST \
        -H "Content-Type: application/json" \
        -d "$MESSAGE" \
        "$WEBHOOK_URL"

    if [ $? -eq 0 ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ Discord 報告送信完了"
        exit 0
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ❌ Discord 報告送信失敗"
        exit 1
    fi
}

# ========================================
# 実行
# ========================================

send_to_discord
