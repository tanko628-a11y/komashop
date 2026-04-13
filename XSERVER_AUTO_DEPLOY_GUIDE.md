# 🚀 Xserver 自動デプロイメント ガイド

**対象:** Xserver ホスティング  
**実装内容:** Contact Form 7 + WordPress フッター自動インストール  
**実行環境:** Xserver SSH 接続

---

## 📋 前提条件

### **必須**
- [ ] Xserver アカウントにログイン可能
- [ ] サーバーパネルにアクセス可能
- [ ] SSH 接続が有効化されている

### **確認事項**
```
Xserver サーバーパネル
→ サーバー情報
→ ホスト名・ユーザー名・パスワード を確認
```

---

## 🔧 ステップ 1: SSH 接続設定を確認

### **1-1. Xserver サーバーパネルにログイン**

```
URL: https://www.xserver.ne.jp/
```

### **1-2. SSH 設定を確認**

```
左メニュー → サーバー管理
→ SSH接続設定
```

**以下を確認:**
- [ ] SSH接続 が「ON」になっているか
- ホスト名（例: sv1234.xserver.jp）
- ユーザー名（例: xxx）
- ポート（デフォルト: 22）

---

## 💻 ステップ 2: ローカル PC から SSH 接続

### **Windows (PowerShell) の場合**

```powershell
# SSH で Xserver に接続
ssh -p 22 ユーザー名@ホスト名

# 例:
# ssh -p 22 han82@sv1234.xserver.jp

# パスワード入力画面が出たら、Xserver パスワルを入力
```

### **Mac/Linux の場合**

```bash
# SSH で Xserver に接続
ssh -p 22 ユーザー名@ホスト名

# 例:
# ssh -p 22 han82@sv1234.xserver.jp
```

**接続成功すると:**
```
$ ← このプロンプトが表示
```

---

## 📂 ステップ 3: 自動デプロイメント スクリプトを実行

### **3-1. リポジトリをダウンロード（初回のみ）**

SSH 接続後、以下を実行:

```bash
# ホームディレクトリに移動
cd ~

# リポジトリを git clone
git clone https://github.com/tanko628-a11y/komashop.git

# または、ブランチを指定:
# git clone -b claude/review-nagi-financial-shop-5xOxg https://github.com/tanko628-a11y/komashop.git
```

### **3-2. スクリプトに実行権限を付与**

```bash
# komashop フォルダに移動
cd komashop

# スクリプトに実行権限を付与
chmod +x xserver-auto-deployment.sh
```

### **3-3. スクリプトを実行**

```bash
# 自動デプロイメント開始
./xserver-auto-deployment.sh
```

**実行されるもの:**

```
✓ WordPress インストール位置を自動検索
✓ WP-CLI の利用可能性を確認
✓ ファイル書き込み権限を確認
✓ 環境に応じた最適な自動化方法を判定
✓ Contact Form 7 をインストール・有効化
✓ footer.php にフッターコード追加
✓ バックアップ作成
```

---

## ✅ デプロイメント完了確認

### **スクリプト実行後**

```
✅ デプロイメント完了！

実施内容:
  ✓ Contact Form 7 をインストール・有効化
  ✓ footer.php にフッターコード追加
  ✓ バックアップを作成
```

**が表示されたら成功です。**

---

## 🌐 WordPress で確認

### **1. WordPress 管理画面にログイン**

```
URL: https://www.komashikifx.site/wp-admin/
```

### **2. Contact Form 7 が有効化されているか確認**

```
左メニュー → プラグイン
→ 「Contact Form 7」が有効化されている
```

### **3. フッターが表示されているか確認**

```
URL: https://www.komashikifx.site/
→ ページ下部にフッター表示確認
```

### **4. メール設定を確認**

```
左メニュー → Contact Form 7 → Contact Forms
→ 「お問い合わせ」をクリック
→ 「メール」タブを開く
```

**確認項目:**
- [ ] To が `kei@komasanshop.com` に設定されているか
- [ ] 本文テンプレートが正しいか

**メール設定が空白の場合:**

以下を手動で設定してください（CONTACT_MAIL_CONFIG.md 参照）

---

## 🧪 テスト送信

### **1. お問い合わせページにアクセス**

```
URL: https://www.komashikifx.site/お問い合わせ/
```

### **2. テストメール送信**

```
名前: テスト 太郎
メール: your-email@example.com
件名: テスト
メッセージ: テストメールです
```

### **3. メール確認**

```
CEO が以下を確認:

✓ kei@komasanshop.com にメール到着
✓ your-email@example.com に自動返信到着
```

---

## ⚠️ 問題が発生した場合

### **スクリプトが実行できない**

```bash
# 権限を確認
ls -l xserver-auto-deployment.sh

# 実行権限がなければ:
chmod +x xserver-auto-deployment.sh

# もう一度実行
./xserver-auto-deployment.sh
```

### **WordPress が見つからない**

```
スクリプト実行中に手動で WordPress パスを入力:
  WordPress ルートパス (例: ~/public_html): _

  例:
  ~/public_html
  ~/public_html/wordpress
```

### **WP-CLI が見つからない**

```
WP-CLI がインストールされていない場合:

方法 1: Xserver サーバーパネルで WP-CLI を有効化
→ サーバー管理 → ツール設定 → WP-CLI を ON

方法 2: 手動でインストール
→ QUICK_DEPLOYMENT_GUIDE.md で手動デプロイ
```

### **権限エラーが出た**

```
Xserver サーバーパネル → ファイルマネージャー で確認:
→ wp-content フォルダの権限が 755 か確認
→ 必要に応じて chmod 755 wp-content
```

### **Contact Form 7 がインストール失敗**

```
原因: プラグインディレクトリへの書き込み権限がない

解決方法:
1. Xserver サーバーパネル → ファイルマネージャー
2. wp-content/plugins を右クリック
3. 権限変更 → 755 に設定
4. スクリプトを再実行
```

---

## 📚 参考ドキュメント

| ドキュメント | 用途 |
|------------|------|
| **QUICK_DEPLOYMENT_GUIDE.md** | 手動デプロイ（このスクリプトが失敗した場合） |
| **CONTACT_MAIL_CONFIG.md** | メール設定の詳細 |
| **DEPLOYMENT_INSTRUCTIONS.md** | トラブルシューティング |

---

## 🎯 トラブル時の対応フロー

```
スクリプト実行
  ↓
【成功】
  ✓ デプロイメント完了
  ↓
  次: テスト送信へ
  
【失敗】
  ✗ エラーメッセージ確認
  ↓
  WordPress 位置を手動入力?
    はい → パス入力して続行
    いいえ → パスを確認して再実行
  ↓
  WP-CLI 未検出?
    はい → Xserver パネルで有効化
    いいえ → スクリプト再実行
  ↓
  権限エラー?
    はい → Xserver パネルで権限設定
    いいえ → QUICK_DEPLOYMENT_GUIDE.md で手動デプロイ
```

---

## 💡 SSH 接続が分からない場合

**代替手段: SFTP でファイルを直接送信**

```
1. ローカル PC に xserver-auto-deployment.sh をダウンロード
2. SFTP クライアント（WinSCP など）で接続
3. ファイルを Xserver にアップロード
4. サーバーパネルの「SSHコマンド実行」で実行
```

---

## ✨ 完了後

```
【自動化によるメリット】
✓ 5分で完全デプロイ
✓ 手動ミスなし
✓ バックアップ自動作成
✓ 再実行可能

【次のステップ】
1. テスト送信
2. メール確認
3. 本番公開
```

---

**作成日:** 2026-04-14  
**対象:** Xserver WordPress ホスティング  
**実装者:** Claude
