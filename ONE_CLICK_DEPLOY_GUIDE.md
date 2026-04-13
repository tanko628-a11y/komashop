# 🚀 ワンクリックデプロイメント ガイド

**対象:** Windows PowerShell  
**スクリプト:** xserver-one-click-deploy.ps1  
**所要時間:** 約 5-10 分  
**自動化内容:** SSH 接続 → リポジトリクローン → デプロイメント実行

---

## ⚡ 3ステップで完了

### **ステップ 1: スクリプトをダウンロード**

リポジトリから以下のファイルをダウンロード:

```
xserver-one-click-deploy.ps1
```

**保存場所例:**
```
C:\Users\han82\Downloads\xserver-one-click-deploy.ps1
```

---

### **ステップ 2: PowerShell を実行**

**Windows スタートメニューで「PowerShell」を検索**

```
Windows PowerShell
```

をクリック（管理者権限で実行）

---

### **ステップ 3: スクリプトを実行**

PowerShell ウィンドウで以下を実行:

```powershell
# 保存したフォルダに移動
cd C:\Users\han82\Downloads

# スクリプト実行ポリシーを一時的に変更（初回のみ）
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# スクリプトを実行
.\xserver-one-click-deploy.ps1
```

---

## 📋 実行時に聞かれること

スクリプト実行後、以下を入力してください:

```
ホスト名 (例: sv1234.xserver.jp): sv1234.xserver.jp
ユーザー名 (例: han82): han82
パスワード: (入力は表示されません - Xserver のパスワードを入力)
```

---

## ✅ 自動実行される内容

```
1️⃣ Xserver に SSH 接続
   ├─ ホスト名で接続
   └─ ユーザー名・パスワルで認証

2️⃣ リポジトリをクローン
   ├─ https://github.com/tanko628-a11y/komashop.git
   └─ ブランチ: claude/review-nagi-financial-shop-5xOxg

3️⃣ 自動デプロイメント実行
   ├─ WordPress インストール位置を自動検出
   ├─ Contact Form 7 をインストール・有効化
   ├─ footer.php にコード追加
   └─ バックアップ作成

4️⃣ 完了通知
   └─ 次のステップを表示
```

---

## 🎯 実行例

```powershell
PS C:\Users\han82\Downloads> .\xserver-one-click-deploy.ps1
========================================
Xserver WordPress ワンクリックデプロイメント
========================================

Xserver 接続情報を入力してください

ホスト名 (例: sv1234.xserver.jp): sv1234.xserver.jp
ユーザー名 (例: han82): han82
パスワード: ••••••••

✓ 接続情報を確認しました
  ホスト: sv1234.xserver.jp
  ユーザー: han82

【ステップ 1】Xserver に接続中...

【実行内容】
  • リポジトリをクローン
  • 自動デプロイメントスクリプト実行
  • Contact Form 7 インストール
  • footer.php にコード追加

✓ リポジトリをクローン中...

✓ 自動デプロイメント開始

✓ Contact Form 7 をインストール・有効化しました
✓ footer.php にフッターコード追加しました
✓ バックアップ作成

========================================
ワンクリックデプロイメント完了
========================================

✅ デプロイメント処理が完了しました

【次のステップ】

1. WordPress 管理画面でプラグイン確認
   URL: https://www.komashikifx.site/wp-admin/
   確認: Contact Form 7 が有効化されているか

2. フッター表示確認
   URL: https://www.komashikifx.site/
   確認: ページ下部にフッター表示

3. テストメール送信
   URL: https://www.komashikifx.site/お問い合わせ/
   送信先: kei@komasanshop.com

4. メール受信確認
   kei@komasanshop.com に受信メールが到着
   テストメールアドレスに自動返信が到着

✓ すべての処理が完了しました！
```

---

## ⚠️ トラブルシューティング

### **「実行ポリシー」エラーが出た場合**

```powershell
# PowerShell を管理者権限で開いて実行
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# もう一度スクリプトを実行
.\xserver-one-click-deploy.ps1
```

### **SSH 接続エラーが出た場合**

**確認項目:**

1. **ホスト名が正しいか**
   ```
   Xserver サーバーパネル → サーバー情報 で確認
   例: sv1234.xserver.jp
   ```

2. **ユーザー名が正しいか**
   ```
   Xserver のユーザー名を確認
   例: han82
   ```

3. **パスワードが正しいか**
   ```
   Xserver のパスワルを確認
   （サーバーパネルと同じパスワード）
   ```

4. **SSH が有効か**
   ```
   Xserver サーバーパネル
   → サーバー管理 → SSH設定 → SSH接続が ON
   ```

### **WordPress が見つからないエラー**

スクリプトが自動的に以下を試します:
```
1. ~/public_html/wp-config.php
2. ~/public_html/wordpress/wp-config.php
3. ~/www/wp-config.php
```

見つからない場合は、Xserver ファイルマネージャーで確認してください。

### **Contact Form 7 インストール失敗**

権限の問題の可能性:

```
Xserver サーバーパネル → ファイルマネージャー
→ wp-content フォルダ → 権限変更 → 755
```

その後、スクリプトを再実行してください。

---

## 🔐 セキュリティ注意事項

⚠️ **重要:**

- パスワードは入力画面で聞かれます（スクリプトに保存されません）
- スクリプト実行後、接続情報は残りません
- PowerShell の実行ポリシーは一時的な変更です

---

## 💾 保存位置

**スクリプト:** xserver-one-click-deploy.ps1

**推奨保存場所:**
```
C:\Users\han82\Scripts\xserver-one-click-deploy.ps1
```

保存後、右クリック → 「このファイルを常に開く」で PowerShell に関連付けすれば、ダブルクリックで実行可能。

---

## 🎯 実行フロー

```
開始
  ↓
PowerShell 起動
  ↓
スクリプト実行
  ↓
接続情報入力
  ├─ ホスト名
  ├─ ユーザー名
  └─ パスワード
  ↓
Xserver に SSH 接続
  ↓
リポジトリをクローン
  ↓
デプロイメントスクリプト実行
  ├─ WordPress 検出
  ├─ Contact Form 7 インストール
  └─ footer.php 修正
  ↓
完了通知
  ↓
終了
```

---

## ✨ メリット

```
✓ 手動作業が不要
✓ SSH パス入力を自動化
✓ 5分で完全デプロイ
✓ 複数回実行可能（べき等性）
✓ エラーメッセージで対応可能
```

---

**スクリプト:** xserver-one-click-deploy.ps1  
**実行環境:** Windows PowerShell  
**対象:** Xserver ホスティング  
**作成日:** 2026-04-14
