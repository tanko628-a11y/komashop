# 🔄 3way 同期ガイド — Google Drive + GitHub + Claude Code

**最終更新**: 2026-04-22  
**バージョン**: 1.0  
**対象**: Windows 11 + Linux（Claude Code）+ GitHub

---

## 📌 概要

このプロジェクトでは、3つのシステムで自動同期を実現しています：

| システム | 役割 | 同期方式 |
|---------|------|--------|
| **Google Drive** | 出張用セットアップファイル | Google Drive for Desktop（自動） |
| **GitHub リポジトリ** | コード・スクリプト管理 | git（手動/自動） |
| **Linux（Claude Code）** | 統合管理・自動実行 | rclone + git（30分ごと） |

---

## 🔄 同期フロー（全体像）

```
【Google Drive（出張用）】
  ↓ (Google Drive for Desktop - 自動同期)
【Windows PC】
  ├─ 自宅 PC
  └─ 出張ノート PC
    ↓ (git push - 手動)
【GitHub リポジトリ】
  ↓ (rclone sync - 30分ごと自動)
【Linux（Claude Code）】
  ├─ Google Drive ファイル (/home/user/komashop-gdrive/)
  ├─ docs/ フォルダ（統合）
  └─ スクリプト管理
    ↓ (git push - 自動)
【GitHub リポジトリ】
  ↓ (git pull - 手動)
【Web版 Claude / Windows PC】
  ↓ (Google Drive for Desktop - 自動)
【Google Drive】
  ...（ループ）
```

---

## 📂 フォルダ構造

### **GitHub リポジトリ**

```
komashop/
├── wordpress-deploy-complete.sh          ← WP-CLI スクリプト
├── xserver-one-click-deploy.ps1          ← PowerShell スクリプト（Windows）
├── COWORK_DEPLOYMENT_INSTRUCTIONS.md     ← 手動デプロイメント手順
├── COWORK_QUICK_CHECKLIST.md             ← 簡易チェックリスト
├── COWORK_DEPLOYMENT_CHECK.md            ← 確認チェックリスト
│
├── /docs/                                ← ドキュメント
│   ├── SYNC_GUIDE.md                    ← このファイル
│   ├── PROJECT_STATUS.md                ← プロジェクト状態
│   ├── TASKS.md                         ← タスク管理
│   ├── GDRIVE_SYNC_STATUS.md            ← 同期状態ログ
│   └── AI_WORKFLOW.md                   ← AI ワークフロー
│
├── /scripts/                             ← スクリプト
│   └── google-drive-sync.sh             ← Google Drive 同期スクリプト
│
└── /logs/                                ← ログファイル
    └── gdrive-sync.log                  ← 同期ログ
```

### **Google Drive**

```
凪フィナンシャル SHOP/
├── セットアップ/
│   ├── CLAUDE.md
│   ├── TRAVEL_SETUP.md
│   ├── QUICK_REFERENCE.txt
│   └── PACKING_CHECKLIST.md
│
├── スクリプト/
│   └── gen_product_images.py
│
├── 画像/
│   └── product_images/
│
└── 認証情報/              (⚠️ USB のみに保管)
    └── credentials_backup.txt
```

### **Linux ローカル**

```
/home/user/
├── komashop/                    ← GitHub リポジトリ
│   ├── docs/
│   ├── scripts/
│   ├── logs/
│   └── ...
│
└── komashop-gdrive/             ← Google Drive ローカルコピー
    ├── セットアップ/
    ├── スクリプト/
    ├── 画像/
    └── 認証情報/
```

---

## 🚀 使用方法

### **Windows（自宅PC / 出張PC）**

#### Phase 1: Google Drive for Desktop セットアップ

1. **インストール**
   ```
   https://www.google.com/drive/download/
   → Google Drive for Desktop をダウンロード
   → インストール実行
   ```

2. **同じ Google アカウントでログイン**
   ```
   メールアドレス: [あなたの Google アカウント]
   パスワード: [パスワード]
   ```

3. **同期フォルダの作成**
   ```
   C:\Users\han82\Google Drive\凪フィナンシャル SHOP\
   ```
   → 自動で同期開始

#### Phase 2: GitHub へコミット（出張完了後）

```powershell
cd C:\Users\han82\komashop

# 最新版を取得
git pull origin claude/review-nagi-financial-shop-5xOxg

# ローカル変更をコミット
git add .
git commit -m "Update: 出張で修正したファイル"

# GitHub に Push
git push origin claude/review-nagi-financial-shop-5xOxg
```

---

### **Linux（Claude Code）**

#### rclone 設定（初回のみ）

```bash
# rclone 対話設定
rclone config

# 入力内容：
# ┌─────────────────────────────────────────┐
# │ 1. "New remote" を選択                   │
# │ 2. Name: komashop-gdrive                │
# │ 3. Type: Google Drive を選択            │
# │ 4. OAuth ブラウザ認証（自動開始）       │
# │ 5. Complete setup                       │
# └─────────────────────────────────────────┘
```

#### 定期同期設定（cron）

```bash
# cron エディタを開く
crontab -e

# 以下を追加（30分ごとに同期）
*/30 * * * * /home/user/komashop/scripts/google-drive-sync.sh

# 確認
crontab -l
```

#### 手動同期実行

```bash
cd /home/user/komashop

# スクリプト実行
./scripts/google-drive-sync.sh

# ログ確認
tail -f logs/gdrive-sync.log
```

---

## ✅ 同期状態の確認

### **Windows**

```powershell
# Google Drive for Desktop が同期済みか確認
# タスクバー → Google Drive アイコン → 確認

# GitHub が最新か確認
git status
git log --oneline -5
```

### **Linux**

```bash
# 同期ログ確認
tail -20 /home/user/komashop/logs/gdrive-sync.log

# rclone 同期状態確認
rclone ls komashop-gdrive:/凪フィナンシャル\ SHOP/

# GitHub 同期状態確認
cd /home/user/komashop
git status
git log --oneline -5
```

### **GitHub（Web）**

```
https://github.com/tanko628-a11y/komashop
→ Commits タブ
→ 最新コミット確認
```

---

## 🔐 セキュリティ

### **認証情報の保管**

```
✅ USB のみに保管（オフライン）
❌ Google Drive に保存しない
❌ GitHub にコミットしない
```

### **Windows BitLocker**

```powershell
# PC 全体を暗号化（推奨）
Windows 設定 → システム → 暗号化 → BitLocker → オン
```

### **Google Drive 共有設定**

```
Google Drive → 凪フィナンシャル SHOP
→ 共有 → 「制限付き」に設定
→ 自分だけがアクセス可能
```

---

## 🆘 トラブルシューティング

### **Q1: Google Drive ファイルが同期されない**

```bash
# 原因：ネット接続、ディスク容量

【対応】
1. WiFi/VPN 接続確認
2. PC ディスク空き容量確認
3. Google Drive for Desktop を再起動
   → タスクバー → 右クリック → 終了
   → 再起動
```

### **Q2: rclone 同期が失敗した**

```bash
# 確認コマンド
rclone config show komashop-gdrive

# リセット
rclone forget komashop-gdrive
rclone config
```

### **Q3: Git Push で競合が発生した**

```bash
# 状態確認
git status

# リモート最新を取得
git fetch origin

# 差分確認
git diff origin/claude/review-nagi-financial-shop-5xOxg

# マージ
git merge origin/claude/review-nagi-financial-shop-5xOxg
```

---

## 📊 同期統計

### **自動同期スケジュール**

| システム | 頻度 | 方式 |
|---------|------|------|
| Google Drive（Windows） | リアルタイム | 自動 |
| rclone（Linux） | 30 分ごと | cron 自動 |
| GitHub Push | 手動 | 手動 |

### **ファイル数・容量**

```
docs/: 5 ファイル
scripts/: 2 ファイル
komashop-gdrive/: 50+ ファイル（Google Drive ミラー）
```

---

## 📞 参考資料

| ツール | ドキュメント |
|--------|------------|
| **Google Drive for Desktop** | https://support.google.com/drive/answer/7329379 |
| **rclone** | https://rclone.org/docs/ |
| **GitHub** | https://docs.github.com/ja |
| **cron** | `man crontab` |

---

**これで、出張中も Windows → Google Drive → Linux → GitHub の3way 同期で、常に最新のファイルを保持できます！** 🚀
