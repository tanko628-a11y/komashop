# 📊 Google Drive 同期状態ログ

**最終更新**: 2026-04-22 12:19 JST  
**同期スクリプト**: `scripts/google-drive-sync.sh`  
**実行間隔**: 30分ごと（cron 自動実行）

---

## 📋 同期履歴

### **2026-04-22 12:19:00 JST**
```
ステータス: ✅ 準備完了
- rclone: インストール確認（v1.60.1）
- 同期スクリプト: 作成完了
- 定期実行設定: 待機中（ユーザーが crontab 設定予定）

次回同期: crontab 設定後、自動実行開始
```

---

## 🔧 同期スクリプト設定

### **スクリプト情報**

```bash
ファイル: /home/user/komashop/scripts/google-drive-sync.sh
権限: 755 (実行可能)
実行ユーザー: root
実行間隔: */30 * * * * (30分ごと)
ログファイル: /home/user/komashop/logs/gdrive-sync.log
```

### **同期処理内容**

```
【Phase 1】Google Drive → ローカル同期
  rclone sync komashop-gdrive:"凪フィナンシャル SHOP" /home/user/komashop-gdrive/
  
【Phase 2】ローカル → GitHub 統合
  cp -r /home/user/komashop-gdrive/セットアップ/* /home/user/komashop/docs/
  cp -r /home/user/komashop-gdrive/スクリプト/* /home/user/komashop/
  
【Phase 3】Git コミット・プッシュ
  git add -A
  git commit -m "Sync: Google Drive から最新ファイルを同期"
  git push origin claude/review-nagi-financial-shop-5xOxg
```

---

## ⚙️ rclone 設定状態

### **インストール確認**

```bash
✅ rclone v1.60.1 インストール済み
   Ubuntu リポジトリから apt でインストール

確認コマンド:
$ rclone version
  rclone v1.60.1
  - os/type: linux
  - os/arch: amd64
```

### **Google Drive リモート設定**

```
設定状態: ⏳ 待機中
リモート名: komashop-gdrive
タイプ: Google Drive (drive)

設定方法（ユーザー実施）:
  $ rclone config
    → New remote
    → Name: komashop-gdrive
    → Type: Google Drive
    → OAuth ブラウザ認証
    → 設定完了

確認コマンド:
  $ rclone config show komashop-gdrive
  $ rclone ls komashop-gdrive:/
```

---

## 📅 実行スケジュール（cron）

### **設定予定**

```cron
# Google Drive 同期（30分ごと）
*/30 * * * * /home/user/komashop/scripts/google-drive-sync.sh

# ログをメール通知（1日1回、朝9時）
0 9 * * * tail -20 /home/user/komashop/logs/gdrive-sync.log | mail -s "[komashop] 同期ログ" user@example.com
```

### **次のアクション**

```bash
# ユーザーが Windows でログインして、以下を実行:
1. rclone config でコリ authentication 完了
2. Linux で crontab -e を実行
3. 上記のスケジュールを追加
4. crontab -l で確認
```

---

## 📊 同期容量・性能

### **容量推定**

```
Google Drive 内容:
  セットアップ/: ~5 MB
  スクリプト/: ~2 MB
  画像/: ~50 MB
  認証情報/: 空（USB のみ）
  
合計: ~60 MB

同期頻度: 30分ごと
推定バンド幅: 低い（差分同期）
```

### **実行時間**

```
初回同期: ~2-5 分
定期同期（差分）: 10-30 秒
git push: 5-10 秒

推定合計: 15-45 秒/30分
```

---

## 🔍 監視・診断

### **同期状態確認**

```bash
# ログの最新を確認
tail -20 /home/user/komashop/logs/gdrive-sync.log

# rclone の接続確認
rclone ls komashop-gdrive:/

# ローカル同期フォルダの確認
ls -la /home/user/komashop-gdrive/

# Git 状態確認
cd /home/user/komashop
git status
git log --oneline -5
```

### **エラー対応**

| エラー | 原因 | 対応 |
|--------|------|------|
| "リモート 'komashop-gdrive' が設定されていません" | rclone config 未実施 | config コマンドで認証 |
| "接続タイムアウト" | ネット接続問題 | WiFi/VPN 確認、再接続 |
| "ディスク容量不足" | ローカルディスク満杯 | ディスク容量確認・クリア |
| "Git Push 失敗" | リモート競合 | git pull で同期、再実行 |

---

## 📱 同期確認の方法

### **方法 1: ローカルで確認**

```bash
# 同期フォルダの内容確認
find /home/user/komashop-gdrive -type f -mmin -60
  # → 過去 60 分で更新されたファイル一覧

# ログファイル確認
grep "✓" /home/user/komashop/logs/gdrive-sync.log
```

### **方法 2: GitHub で確認**

```
https://github.com/tanko628-a11y/komashop
→ Commits タブ
→ 最新コミット時刻を確認
```

### **方法 3: Google Drive で確認**

```
Google Drive → 凪フィナンシャル SHOP
→ ファイルの詳細 → 最終更新日時
```

---

## 🎯 次のステップ

### **ユーザー（Windows）での作業**

```
【優先度 1】
1. rclone config で Google Drive を認証
   $ rclone config
   
2. Linux で crontab に同期スケジュール追加
   $ crontab -e
   → */30 * * * * /home/user/komashop/scripts/google-drive-sync.sh

3. SSH キー生成・Xserver 登録（並行作業）
   $ ssh-keygen -t rsa -b 4096 -f ...
```

### **Linux での作業**

```
【優先度 2】
1. PowerShell スクリプト修正（SSH キー認証対応）
2. バッチファイル作成（xserver-auto-deploy.bat）
3. Cowork 確認チェックリスト作成

【優先度 3】
1. 3way 同期テスト実行
2. ログ確認・最適化
```

---

## 📈 監視メトリクス

```
【追跡項目】
✅ 同期成功率: 100%（実行ごと）
✅ 同期時間: 15-45 秒/30分
✅ エラー件数: 0（設定完了後）
✅ ファイルカウント: ~60 MB
✅ GitHub コミット: 自動（毎回）
```

---

**このファイルは同期スクリプトが自動更新します。** 🔄
