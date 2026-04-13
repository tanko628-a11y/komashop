#!/bin/bash

# Cron ジョブセットアップスクリプト
# 毎日朝6時に Discord へ進捗報告を送信

SCRIPT_PATH="/home/user/komashop/discord-progress-report.sh"
CRON_SCHEDULE="0 6 * * *"  # 毎日朝6時

echo "=========================================="
echo "Cron ジョブセットアップ"
echo "=========================================="
echo ""

# スクリプトに実行権限を付与
chmod +x "$SCRIPT_PATH"
echo "✓ スクリプトに実行権限付与: $SCRIPT_PATH"
echo ""

# 既存の cron ジョブを確認
echo "【現在の Cron ジョブ】"
crontab -l 2>/dev/null || echo "(Cron ジョブなし)"
echo ""

# 新しい cron ジョブを追加
(crontab -l 2>/dev/null; echo "$CRON_SCHEDULE $SCRIPT_PATH >> /var/log/nagi-discord-report.log 2>&1") | crontab -

if [ $? -eq 0 ]; then
    echo "✅ Cron ジョブ追加完了"
    echo ""
    echo "【設定内容】"
    echo "Schedule: $CRON_SCHEDULE (毎日朝6時)"
    echo "Script:   $SCRIPT_PATH"
    echo "Log:      /var/log/nagi-discord-report.log"
    echo ""
    echo "【検証】"
    crontab -l | grep discord-progress-report
    echo ""
    echo "=========================================="
    echo "✅ セットアップ完了"
    echo "=========================================="
else
    echo "❌ Cron ジョブ追加失敗"
    exit 1
fi
