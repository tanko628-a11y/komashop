# 統合セットアップ・チェックリスト

**最終更新**: 2026-04-23  
**ステータス**: ✅ 全 Phase 実装完了

---

## 📋 概要

このドキュメントは、プロジェクト全体の統合セットアップと最終確認を行うための完全なチェックリストです。

**対象**: 初期セットアップ・システム管理者  
**実施時間**: 約 1-2 時間  
**難易度**: 中級

---

## 🎯 全体進捗

```
Phase 1-3: WordPress          ████████████████████░ 90% ✅
Phase 4-5: Google Drive       ████████████████████░ 100% ✅
Phase 6-7: 自動化            ████████████████████░ 100% ✅
Phase 8: Memory-Sync          ████████████████████░ 100% ✅
─────────────────────────────────────────────────
全体                          ██████████████████░░░ 90%
```

---

## 🔧 前提条件チェック

### システム要件

- [ ] Linux サーバー (Claude Code / Ubuntu 20.04+)
- [ ] Python 3.8 以上
- [ ] Git 2.0 以上
- [ ] Bash / Zsh シェル
- [ ] インターネット接続

**確認**:
```bash
python3 --version  # 3.8以上
git --version      # 2.0以上
uname -a           # OS確認
```

### Windows システム要件（オプション）

- [ ] Windows 11
- [ ] PowerShell 5.0 以上
- [ ] GitHub Desktop（オプション）
- [ ] SSH キー生成機能

**確認**:
```powershell
$PSVersionTable.PSVersion  # 5.0以上
```

### Xserver アクセス

- [ ] SSH キー用意（またはパスワード）
- [ ] ホスト名: sv13270.xserver.jp
- [ ] ユーザー名: han82
- [ ] WordPress インストール確認: ~/public_html/

**確認**:
```bash
ssh han82@sv13270.xserver.jp "ls ~/public_html/wp-config.php"
```

---

## 📦 リポジトリセットアップ

### ステップ 1: クローン

```bash
# リポジトリクローン
git clone https://github.com/tanko628-a11y/komashop.git
cd komashop

# ブランチ確認
git branch -a
git checkout claude/review-nagi-financial-shop-5xOxg
```

- [ ] リポジトリクローン完了
- [ ] ブランチ切り替え完了
- [ ] ファイル確認完了（`ls -la`）

### ステップ 2: 初期化

```bash
# ディレクトリ構造確認
tree -L 2 --ignore '__pycache__'

# 期待:
# komashop/
# ├── sync_manager.py
# ├── agents/
# ├── docs/
# ├── scripts/
# └── README.md
```

- [ ] ディレクトリ構造確認完了

### ステップ 3: 環境変数設定

```bash
# .bashrc または .bash_profile に以下を追加:
export WP_USER="golden_admin"
export WP_PASS_URANAI="<app-password>"
export WP_PASS="<standard-password>"
export OPENAI_API_KEY="<openai-api-key>"
export DISCORD_WEBHOOK_URANAI="<discord-webhook>"

# 反映
source ~/.bashrc
```

**確認**:
```bash
echo $WP_USER
echo $OPENAI_API_KEY | cut -c1-8
```

- [ ] 環境変数設定完了
- [ ] 環境変数確認完了

---

## 💾 Phase 1-3: WordPress デプロイメント

### 確認項目

```bash
# WordPress 稼働確認
curl -I https://www.komashikifx.site/ | head -1

# Contact Form 7 確認（Web ブラウザで）
# https://www.komashikifx.site/wp-admin/plugins.php

# お問い合わせフォーム確認（Web ブラウザで）
# https://www.komashikifx.site/お問い合わせ/

# footer 確認（Web ブラウザで）
# https://www.komashikifx.site/ （ページ下部を確認）
```

### チェックリスト

- [ ] WordPress サイトが稼働
- [ ] Contact Form 7 プラグインがインストール・有効化
- [ ] お問い合わせフォームが表示・機能
- [ ] footer.php コードが追加されている
- [ ] メール送受信機能が動作

---

## 🔄 Phase 4-5: Google Drive 同期

### ステップ 1: rclone セットアップ

```bash
# インストール
curl https://rclone.org/install.sh | sudo bash

# バージョン確認
rclone --version
```

- [ ] rclone インストール完了

### ステップ 2: Google Drive 認証

```bash
# 設定開始
rclone config

# 入力内容:
# n - 新規リモート
# komashop-gdrive - リモート名
# drive - Google Drive
# (ブラウザで OAuth2 認証)
# q - 完了

# 確認
rclone listremotes | grep komashop-gdrive
```

- [ ] Google Drive 認証完了

### ステップ 3: 同期テスト

```bash
# テスト実行
mkdir -p ~/gdrive-sync
rclone sync komashop-gdrive:凪フィナンシャル\ SHOP ~/gdrive-sync --dry-run

# 実行
rclone sync komashop-gdrive:凪フィナンシャル\ SHOP ~/gdrive-sync
```

- [ ] 同期テスト成功

### ステップ 4: cron 登録

```bash
# crontab 編集
crontab -e

# 追加:
*/30 * * * * /home/user/komashop/scripts/google-drive-sync.sh >> /home/user/.gdrive-sync.log 2>&1

# 確認
crontab -l
```

- [ ] cron ジョブ登録完了

---

## 🏠 Phase 6-7: Windows 自動化（オプション）

### ステップ 1: SSH キー生成（Windows）

```powershell
# PowerShell 実行
ssh-keygen -t rsa -b 4096 -f "$env:USERPROFILE\.ssh\xserver_key"

# パスフレーズ: (空でOK)

# 確認
Get-Item $env:USERPROFILE\.ssh\xserver_key
```

- [ ] SSH キー生成完了

### ステップ 2: Xserver 公開キー登録

```
Xserver サーバーパネル
→ SSH 設定
→ 公開キー追加
→ $env:USERPROFILE\.ssh\xserver_key.pub の内容を貼り付け
```

- [ ] Xserver に公開キー登録完了

### ステップ 3: SSH 接続テスト

```powershell
ssh -i "$env:USERPROFILE\.ssh\xserver_key" han82@sv13270.xserver.jp "echo OK"
```

- [ ] SSH 接続テスト成功

### ステップ 4: PowerShell スクリプト実行

```powershell
# 実行許可
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 帰宅・同期スタート実行
.\home-sync-complete.ps1

# 出発・同期実施実行
.\departure-sync.ps1
```

- [ ] PowerShell スクリプト実行可能

---

## 💾 Phase 8: Memory-OneDrive 同期

### ステップ 1: システム初期化

```bash
# 確認
python3 sync_manager.py --status

# 出力:
# OneDrive file exists: False
# Local file exists: False
# (初期状態が表示される)
```

- [ ] システム初期化確認完了

### ステップ 2: cron 登録

```bash
# crontab 編集
crontab -e

# 追加:
0 * * * * python3 /home/user/komashop/sync_manager.py >> /home/user/.memory-sync.log 2>&1

# 確認
crontab -l | grep sync_manager
```

- [ ] cron ジョブ登録完了

### ステップ 3: 手動テスト

```bash
# 同期実行
python3 sync_manager.py

# ログ確認
tail -20 ~/.claude/sync_log.txt

# キャッシュ確認
cat ~/.claude/sync_cache.json | jq .
```

- [ ] 手動同期実行完了
- [ ] ログ生成確認

### ステップ 4: トークン予算確認

```bash
# トークン使用量確認
python3 << 'EOF'
from agents.token_monitor_agent import TokenMonitorAgent
m = TokenMonitorAgent()
m.print_summary()
