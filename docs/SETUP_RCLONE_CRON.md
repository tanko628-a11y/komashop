# Google Drive 同期セットアップ: rclone + cron

**最終更新**: 2026-04-23  
**ステータス**: ✅ 設定ガイド完成

---

## 📋 概要

このガイドは、Google Drive と Linux サーバー間の自動同期を設定します。

**同期対象**: Google Drive 凪フィナンシャル SHOP フォルダ  
**同期頻度**: 30分ごと（カスタマイズ可能）  
**実行環境**: Linux (Claude Code / Xserver)

---

## 🚀 セットアップ手順

### ステップ 1: rclone インストール

```bash
# インストール
curl https://rclone.org/install.sh | sudo bash

# バージョン確認
rclone version
```

### ステップ 2: Google Drive 認証設定

```bash
# rclone 設定開始
rclone config

# 対話的に入力
n  # 新しいリモートを作成
komashop-gdrive  # リモート名（任意）
drive  # ストレージタイプ: Google Drive
# OAuth2 認証: ブラウザで認証ページが開く
# 承認 → コードをコピー → 貼り付け
q  # 設定完了
```

**注**: 認証時にブラウザが開きます。Google アカウントでサインイン・承認してください。

### ステップ 3: 同期テスト

```bash
# リストアップ
rclone ls komashop-gdrive:凪フィナンシャル\ SHOP

# ローカルへの同期テスト
mkdir -p ~/gdrive-sync
rclone sync komashop-gdrive:凪フィナンシャル\ SHOP ~/gdrive-sync --dry-run

# 確認後、実行
rclone sync komashop-gdrive:凪フィナンシャル\ SHOP ~/gdrive-sync
```

### ステップ 4: cron 自動実行設定

```bash
# crontab 編集
crontab -e

# 以下の行を追加:

# ========== Google Drive 同期 ==========
# 30分ごとに実行
*/30 * * * * /home/user/komashop/scripts/google-drive-sync.sh >> /home/user/.gdrive-sync.log 2>&1

# ========== Memory-OneDrive 同期 ==========
# 1時間ごとに実行
0 * * * * python3 /home/user/komashop/sync_manager.py >> /home/user/.memory-sync.log 2>&1

# ファイル保存
```

### ステップ 5: 確認

```bash
# cron ジョブ確認
crontab -l

# ログファイル確認
tail -20 /home/user/.gdrive-sync.log
tail -20 /home/user/.memory-sync.log
```

---

## 🔧 カスタマイズ

### 同期頻度の変更

crontab 内の時間設定を変更:

```bash
# 毎時間
0 * * * * /path/to/google-drive-sync.sh

# 15分ごと
*/15 * * * * /path/to/google-drive-sync.sh

# 毎日 午前3時
0 3 * * * /path/to/google-drive-sync.sh

# 平日 18時
0 18 * * 1-5 /path/to/google-drive-sync.sh
```

### ローカル同期パスの変更

```bash
# .bashrc または .bash_profile に設定
export GDRIVE_LOCAL_PATH="/path/to/local/folder"
export GDRIVE_REMOTE="komashop-gdrive"
export GDRIVE_FOLDER="凪フィナンシャル SHOP"
```

### リモート設定の確認

```bash
# 設定一覧表示
rclone config show

# 特定リモートの詳細表示
rclone config show komashop-gdrive
```

---

## 🔍 トラブルシューティング

### rclone インストールエラー

```bash
# 手動インストール
wget https://downloads.rclone.org/v1.60.1/rclone-v1.60.1-linux-amd64.zip
unzip rclone-v1.60.1-linux-amd64.zip
sudo cp rclone-v1.60.1-linux-amd64/rclone /usr/local/bin/
```

### Google Drive 認証エラー

```bash
# 認証削除・再設定
rclone config delete komashop-gdrive
rclone config  # 再度設定

# または
rclone auth komashop-gdrive  # 再認証
```

### cron が実行されない

```bash
# cron デーモン確認
sudo systemctl status cron  # Debian/Ubuntu
sudo systemctl status crond  # RHEL/CentOS

# 開始
sudo systemctl start cron

# ログ確認
sudo journalctl -u cron -n 50  # 最新 50 行
```

### 同期が遅い

```bash
# ログを確認
tail -100 /home/user/.gdrive-sync.log

# 手動実行でテスト
time rclone sync komashop-gdrive:凪フィナンシャル\ SHOP ~/gdrive-sync

# 帯域制限を追加（必要に応じて）
rclone sync komashop-gdrive:... ~/gdrive-sync --bwlimit=10M
```

---

## 📊 監視

### ログ監視スクリプト

```bash
#!/bin/bash
# gdrive-sync-monitor.sh

echo "=== Google Drive Sync Status ==="
echo ""
echo "Last Sync (Google Drive):"
tail -1 /home/user/.gdrive-sync.log
echo ""
echo "Last Sync (Memory-OneDrive):"
tail -1 /home/user/.memory-sync.log
echo ""
echo "Cron Jobs:"
crontab -l | grep -E "gdrive|sync_manager"
```

実行:
```bash
chmod +x gdrive-sync-monitor.sh
./gdrive-sync-monitor.sh
```

### 定期レポート

```bash
#!/bin/bash
# weekly-sync-report.sh

DATE=$(date +"%Y-%m-%d")
echo "=== Sync Report - $DATE ===" >> ~/sync-report.log
echo "" >> ~/sync-report.log

echo "Google Drive Syncs (last 7 days):" >> ~/sync-report.log
grep "$(date -d '7 days ago' +%Y-%m-%d)" /home/user/.gdrive-sync.log | wc -l >> ~/sync-report.log

echo "Memory Syncs (last 7 days):" >> ~/sync-report.log
grep "$(date -d '7 days ago' +%Y-%m-%d)" /home/user/.memory-sync.log | wc -l >> ~/sync-report.log

echo "" >> ~/sync-report.log
```

crontab に追加:
```bash
# 毎週日曜 0時
0 0 * * 0 /home/user/weekly-sync-report.sh
```

---

## ✅ チェックリスト

- ✅ rclone インストール確認
- ✅ Google Drive 認証完了
- ✅ 同期テスト成功
- ✅ cron ジョブ登録
- ✅ ログファイル確認

---

## 📞 サポート

### よくある質問

**Q: Google Drive の特定フォルダだけ同期できるか？**  
A: `rclone ls` で パスを指定: `rclone sync komashop-gdrive:フォルダ/サブフォルダ ~/local/path`

**Q: 同期が失敗したら？**  
A: ログを確認: `tail -50 /home/user/.gdrive-sync.log`

**Q: 双方向同期できるか？**  
A: `rclone sync` は一方向です。`rclone bisync` で双方向同期（実験的機能）

**Q: 大容量ファイルは？**  
A: rclone は大容量対応。帯域制限: `--bwlimit=10M`

---

**セットアップ完了日**: 2026-04-23  
**ステータス**: ✅ 運用中
