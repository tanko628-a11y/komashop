# 🔧 Google Drive 同期セットアップ完全ガイド

**対象**: Linux 環境での rclone + cron 設定  
**所要時間**: 10-15分  
**前提条件**: 
- Linux（Claude Code）環境へのアクセス
- Google アカウント
- GitHub リポジトリへのアクセス

---

## 📋 事前準備

### 確認項目

```bash
# 1. rclone がインストール済みか確認
rclone version
# 出力例: rclone v1.60.1

# 2. リポジトリがクローンされているか確認
cd /home/user/komashop
git status
# 出力例: On branch claude/review-nagi-financial-shop-5xOxg

# 3. google-drive-sync.sh が存在するか確認
ls -la scripts/google-drive-sync.sh
# 出力例: -rwxr-xr-x ... scripts/google-drive-sync.sh
```

---

## 🔑 Step 1: rclone Google Drive 認証設定

### 1.1 rclone config 起動

```bash
rclone config
```

### 1.2 インタラクティブ設定

以下のようなメニューが表示されます。各ステップで指定値を入力してください：

```
e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q> 
```

**ここで `n` を入力して新規リモート作成**

```
name> komashop-gdrive
```

**リモート名に `komashop-gdrive` を入力**

```
Type of storage to configure.
Choose a number from below, or type in your own value
...
 9 / Google Drive
    \ (drive)
...
Storage> 9
```

**Google Drive を選択（数字 `9` または `drive` を入力）**

```
Google Application Client Id
Leave blank normally.
client_id> 
```

**そのままエンター（空白のまま）**

```
Google Application Client Secret
Leave blank normally.
client_secret> 
```

**そのままエンター（空白のまま）**

```
Scope that rclone should use when requesting access from Google Drive.
...
scope> 1
```

**デフォルト `1` を選択（フルアクセス）**

```
ID of the root folder of the Google Drive to use.
Leave blank normally to access 'My Drive'.
root_folder_id> 
```

**そのままエンター（空白のまま）**

```
Service Account Credentials JSON file path.
Leave blank normally.
Needed only if you want use SA instead of interactive login.
service_account_file> 
```

**そのままエンター（空白のまま）**

```
Edit advanced config? (y/n)
y) Yes
n) No (default)
y/n> n
```

**`n` を選択（詳細設定は不要）**

```
Use auto config?
 * Say Y if not sure
 * Say N if you are working on a remote computer
y) Yes (default)
n) No
y/n> y
```

**`y` を選択（ブラウザで認証開始）**

### 1.3 ブラウザ認証

上記で `y` を選択すると、ブラウザが自動的に開きます。

1. **Google ログイン画面**が表示されます
   - 自分の Google アカウントでログイン

2. **アクセス許可画面**が表示されます
   - 「許可」をクリック
   - rclone が Google Drive へのアクセスを要求します

3. **認証完了メッセージ**が表示されます
   - "Success! All done. Please go back to rclone."

4. **ブラウザを閉じて、ターミナルに戻ります**

### 1.4 設定確認

```
Remote config
--------------------
[komashop-gdrive]
type = drive
client_id = [自動取得]
client_secret = [自動取得]
token = {"access_token":"...", ...}
--------------------
y) Yes this is OK (default)
e) Edit this remote
d) Delete this remote
y/e/d> y
```

**`y` を選択して設定完了**

```
Current remotes:

Name                 Type
----                 ----
komashop-gdrive      drive

e) Edit existing remote
n) New remote
...
q) Quit config
e/n/d/r/c/s/q> q
```

**`q` を選択して rclone config を終了**

---

## 🧪 Step 2: Google Drive 同期テスト

### 2.1 接続確認

```bash
# Google Drive のルート確認
rclone ls komashop-gdrive:/

# 出力例:
#      123  凪フィナンシャル SHOP
#       45  その他フォルダ
```

### 2.2 フォルダ確認

```bash
# "凪フィナンシャル SHOP" フォルダ内容確認
rclone ls "komashop-gdrive:/凪フィナンシャル SHOP"

# 出力例:
#      1234  セットアップ/CLAUDE.md
#       567  スクリプト/gen_product_images.py
#      ...
```

### 2.3 初回同期テスト実行

```bash
# Google Drive → ローカル同期（テスト実行）
rclone sync "komashop-gdrive:/凪フィナンシャル SHOP" /home/user/komashop-gdrive/ --dry-run -v

# --dry-run: 実際には同期しない（テスト実行）
# -v: 詳細ログを表示
```

**ドライラン出力例**:
```
2026/04/23 12:30:00 NOTICE: No changes detected, nothing to transfer
```

### 2.4 実際に同期実行

```bash
# ドライランで問題がなければ、実際に同期
rclone sync "komashop-gdrive:/凪フィナンシャル SHOP" /home/user/komashop-gdrive/ -v

# 完了例:
# 2026/04/23 12:30:05 NOTICE: Local file system at /home/user/komashop-gdrive: 
# 15 files copied to /home/user/komashop-gdrive/
```

### 2.5 同期ファイル確認

```bash
# ローカルフォルダ確認
ls -la /home/user/komashop-gdrive/

# 出力例:
# drwxr-xr-x セットアップ/
# drwxr-xr-x スクリプト/
# drwxr-xr-x 画像/
# -rw-r--r-- README.txt
```

---

## ⏰ Step 3: cron スケジュール設定

### 3.1 crontab 起動

```bash
crontab -e
```

**初回実行時にエディタを選択**:
```
no crontab for user - using an empty one

Select an editor.  To change later, run 'select-editor'.
  1. /bin/nano
  2. /usr/bin/vim.tiny
  3. /usr/bin/vim

Choose 1-3 [1]:
```

**推奨: `1` (nano) を選択** - 簡単です

### 3.2 crontab エントリ追加

nano エディタが開きます。以下をファイルの末尾に追加：

```cron
# Google Drive 同期（30分ごと）
*/30 * * * * /home/user/komashop/scripts/google-drive-sync.sh >> /home/user/komashop/logs/gdrive-sync.log 2>&1

# ログローテーション（毎日 00:00 に実行）
0 0 * * * find /home/user/komashop/logs -name "gdrive-sync.log*" -mtime +30 -delete

# 同期ログメール通知（毎日 09:00）
0 9 * * * tail -50 /home/user/komashop/logs/gdrive-sync.log | mail -s "[komashop] 同期ログ" $(whoami)@localhost
```

### 3.3 ファイル保存

**nano エディタで**:
- `Ctrl + O` - 保存確認
- `Enter` - ファイル名確認
- `Ctrl + X` - 終了

### 3.4 crontab 確認

```bash
crontab -l
```

**確認出力例**:
```
# Google Drive 同期（30分ごと）
*/30 * * * * /home/user/komashop/scripts/google-drive-sync.sh >> /home/user/komashop/logs/gdrive-sync.log 2>&1

# ログローテーション（毎日 00:00 に実行）
0 0 * * * find /home/user/komashop/logs -name "gdrive-sync.log*" -mtime +30 -delete

# 同期ログメール通知（毎日 09:00）
0 9 * * * tail -50 /home/user/komashop/logs/gdrive-sync.log | mail -s "[komashop] 同期ログ" root@localhost
```

---

## 🔍 Step 4: 動作確認

### 4.1 手動実行テスト

```bash
# スクリプトに実行権限があるか確認
ls -la /home/user/komashop/scripts/google-drive-sync.sh
# 出力例: -rwxr-xr-x (x があるなら OK)

# なければ実行権限追加
chmod +x /home/user/komashop/scripts/google-drive-sync.sh

# スクリプト手動実行（テスト）
/home/user/komashop/scripts/google-drive-sync.sh
```

### 4.2 ログ確認

```bash
# ログファイル作成確認
ls -la /home/user/komashop/logs/

# ログ内容確認
tail -20 /home/user/komashop/logs/gdrive-sync.log

# 出力例:
# 【ステップ 1】Google Drive → ローカル同期
# 2026-04-23 12:35:00 ✓ 同期完了: 0 ファイル変更
# 【ステップ 2】ローカル → GitHub 統合
# 2026-04-23 12:35:05 ✓ ファイルコピー完了
# 【ステップ 3】Git コミット・プッシュ
# 2026-04-23 12:35:10 ✓ push 完了
```

### 4.3 Git コミット確認

```bash
# GitHub にプッシュされたか確認
git log --oneline -5

# 出力例:
# abc1234 Sync: Google Drive から最新ファイルを同期
# def5678 feat: Add SSH key auth scripts
# ...
```

### 4.4 cron ログ確認（Linux システムログ）

```bash
# 最後の cron 実行ログ確認
grep CRON /var/log/syslog | tail -10

# 出力例:
# Apr 23 12:30:01 server CRON[12345]: (root) CMD (/home/user/komashop/scripts/google-drive-sync.sh >> ...)
# Apr 23 12:30:05 server CRON[12346]: (CRON) info (No MTA installed, discarding output)
```

---

## 🐛 トラブルシューティング

### Q: "rclone: command not found"

```
A: rclone がインストールされていません。インストール:
   apt update && apt install rclone
```

### Q: "GoogleAuth: User authentication required"

```
A: ブラウザ認証ステップで問題が発生しています:
   1. rclone config で設定をリセット: rclone config delete komashop-gdrive
   2. もう一度 rclone config で再設定
   3. ブラウザ認証画面で「許可」をクリック
```

### Q: "リモート 'komashop-gdrive' が見つかりません"

```
A: rclone 設定が保存されていません:
   rclone config show komashop-gdrive
   # 出力がなければ、rclone config で再設定
```

### Q: "同期に失敗しました"

```
A: Google Drive 側のファイルサイズが大きすぎる可能性:
   1. rclone ls で確認: rclone ls komashop-gdrive:/ --max-depth 2
   2. 大きなファイルは手動で除外
   3. スクリプト内のシンク除外パターンを修正:
      rclone sync ... --exclude '画像/*.jpg'
```

### Q: "cron が実行されていない"

```
A: cron サービスが起動していない:
   # cron サービス確認
   systemctl status cron
   
   # サービス開始
   systemctl start cron
   
   # 自動起動設定
   systemctl enable cron
```

### Q: "ログファイルが作成されない"

```
A: ログディレクトリが存在しません:
   mkdir -p /home/user/komashop/logs
   chmod 755 /home/user/komashop/logs
```

---

## 📊 同期状態監視

### 日次確認

```bash
# 毎日確認するコマンド
echo "=== 最新同期ログ ==="
tail -30 /home/user/komashop/logs/gdrive-sync.log

echo ""
echo "=== GitHub 最新コミット ==="
git log --oneline -3

echo ""
echo "=== Google Drive ローカルフォルダサイズ ==="
du -sh /home/user/komashop-gdrive/
```

### 週次確認

```bash
# Google Drive との同期ファイル数
echo "=== 同期ファイル統計 ==="
find /home/user/komashop-gdrive -type f | wc -l
echo "ファイル数"

# ディスク容量確認
df -h /home/user
```

---

## 📈 パフォーマンス最適化

### 同期頻度の調整

**現在: 30分ごと**

```cron
# 15分ごと（より高速同期）
*/15 * * * * /home/user/komashop/scripts/google-drive-sync.sh >> ...

# 1時間ごと（低トラフィック）
0 * * * * /home/user/komashop/scripts/google-drive-sync.sh >> ...

# 営業時間のみ（9:00 - 18:00 平日）
*/30 9-18 * * 1-5 /home/user/komashop/scripts/google-drive-sync.sh >> ...
```

### 除外ファイル設定

大きなファイルやバイナリを除外:

```bash
# スクリプト内で除外パターン指定
rclone sync "komashop-gdrive:/凪フィナンシャル SHOP" /home/user/komashop-gdrive/ \
  --exclude '画像/*.mp4' \
  --exclude '*.zip' \
  --exclude '.DS_Store'
```

---

## ✅ セットアップ完了チェックリスト

- [ ] `rclone version` で rclone がインストール確認
- [ ] `rclone config` で Google Drive 認証完了
- [ ] `rclone ls komashop-gdrive:/` で Google Drive 接続確認
- [ ] `/home/user/komashop-gdrive/` フォルダに同期ファイル確認
- [ ] `crontab -l` で cron スケジュール登録確認
- [ ] `ls -la /home/user/komashop/logs/gdrive-sync.log` でログ作成確認
- [ ] スクリプト手動実行で ✓ 同期完了メッセージ確認
- [ ] `git log` で GitHub へのプッシュ確認
- [ ] `/home/user/komashop-gdrive/` に Google Drive ファイルが存在確認

---

## 🎉 完了！

セットアップが完了しました。これで以下が自動実行されます：

✅ **Google Drive** → **ローカルストレージ** 同期（30分ごと）  
✅ **ローカルストレージ** → **GitHub** プッシュ（30分ごと）  
✅ **ログファイル** 自動作成・ローテーション  
✅ **エラー通知** メール送信（毎日 09:00）  

---

**最終更新**: 2026-04-23  
**対応 rclone バージョン**: 1.60.1 以上
