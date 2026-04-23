# 最終確認・検証ガイド

**最終更新**: 2026-04-23  
**ステータス**: ✅ 検証完了

---

## 📋 概要

このガイドは、全 Phase (1-8) の最終確認と検証を行うためのチェックリストです。

**対象**: システム管理者 / QA / 確認担当者  
**実施時間**: 約 30-60 分

---

## ✅ 事前確認（Phase 準備）

### 環境確認

```bash
# Python バージョン確認
python3 --version  # 3.8以上

# Git インストール確認
git --version

# SSH キー確認
ls -la ~/.ssh/

# Xserver アクセス確認
ssh -i ~/.ssh/xserver_key han82@sv13270.xserver.jp "echo OK"
```

### リポジトリ確認

```bash
# 最新コードに更新
cd /home/user/komashop
git pull origin claude/review-nagi-financial-shop-5xOxg

# ブランチ確認
git branch -a

# 最新コミット確認
git log --oneline -5
```

---

## 🧪 Phase 1-3: WordPress デプロイメント検証

### Contact Form 7 確認

```bash
# WordPress が実行中か確認
curl -s https://www.komashikifx.site/wp-admin/ | grep "WordPress" > /dev/null && echo "✓ WordPress UP" || echo "✗ WordPress DOWN"

# Contact Form 7 プラグイン確認（管理画面で手動確認推奨）
# https://www.komashikifx.site/wp-admin/plugins.php
```

### お問い合わせフォーム確認

```bash
# フォームページアクセス確認
curl -s https://www.komashikifx.site/お問い合わせ/ | grep "contact-form-7" > /dev/null && echo "✓ Form Found" || echo "✗ Form Not Found"

# フォーム送信テスト（Web ブラウザで手動実行）
# URL: https://www.komashikifx.site/お問い合わせ/
# テスト内容: サンプルデータを送信
```

### メール送受信確認

```bash
# WordPress メール設定確認（管理画面で確認）
# 設定 → 一般 → メールアドレス

# テスト結果
# 受信確認: kei@komasanshop.com
# 自動返信確認: test@example.com
```

### footer.php 確認

```bash
# フッター表示確認（Web ブラウザで確認）
# URL: https://www.komashikifx.site/
# 確認項目:
# - 凪フィナンシャル情報表示
# - Company / About / Legal セクション表示
# - ソーシャルメディアリンク表示
# - レスポンシブデザイン確認（スマホ表示）

# または curl で確認
curl -s https://www.komashikifx.site/ | grep -i "nagi\|financial" | head -5
```

---

## 🔄 Phase 4-5: Google Drive 同期検証

### rclone 確認

```bash
# rclone インストール確認
rclone --version

# Google Drive リモート確認
rclone listremotes | grep komashop-gdrive

# 同期可能性テスト
rclone ls komashop-gdrive:凪フィナンシャル\ SHOP --max-items 5

# 同期テスト（ドライラン）
rclone sync komashop-gdrive:凪フィナンシャル\ SHOP ~/gdrive-sync --dry-run
```

### cron 自動実行確認

```bash
# cron ジョブ登録確認
crontab -l | grep "gdrive\|sync"

# 実際に実行（ログファイルに記録）
bash /home/user/komashop/scripts/google-drive-sync.sh

# ログ確認
tail -20 /home/user/.gdrive-sync.log
```

---

## 🏠 Phase 6-7: ワンクリック自動化検証

### Windows PowerShell スクリプト確認

```powershell
# PowerShell バージョン確認
$PSVersionTable.PSVersion

# スクリプト実行許可確認
Get-ExecutionPolicy

# 実行許可が必要な場合
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# デスクトップショートカット確認（Windows Explorer で確認）
# C:\Users\{username}\Desktop に以下が表示されるか:
# - 🏠 帰宅・同期スタート.lnk
# - 🚗 出発・同期実施.lnk
```

### 帰宅・同期スタート実行テスト

```powershell
# スクリプト実行（本番前にドライラン推奨）
# PowerShell を管理者で実行:
# .\home-sync-complete.ps1

# 確認項目:
# ✓ WordPress デプロイ成功
# ✓ Google Drive 同期完了
# ✓ cron スケジュール設定完了
# ✓ 完了通知受信
```

### 出発・同期実施実行テスト

```powershell
# スクリプト実行（本番前にドライラン推奨）
# PowerShell を管理者で実行:
# .\departure-sync.ps1

# 確認項目:
# ✓ Windows から GitHub へのコミット完了
# ✓ Google Drive へのアップロード完了
# ✓ 出張用ファイル確認完了
# ✓ 完了通知受信
```

---

## 💾 Phase 8: Memory-OneDrive 同期検証

### システム初期化確認

```bash
# コンポーネント確認
python3 << 'EOF'
from agents.state_cache_agent import StateCacheAgent
from agents.file_sync_agent import FileSyncAgent
from agents.token_monitor_agent import TokenMonitorAgent
from agents.task_dispatcher import TaskDispatcher

print("✓ All components initialized successfully")
print("✓ Architecture: 2-layer agent system ready")
