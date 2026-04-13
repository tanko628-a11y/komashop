# 📧 Contact Form 7 実装ガイド
## WordPress 管理画面での完全手順書

**実装日:** 2026-04-13  
**対象ページ:** https://www.komashikifx.site/お問い合わせ/  
**優先度:** 🔴 HIGH  

---

## 📋 実装内容サマリー

本ガイドは以下の 3 つの修正を WordPress に反映させるための完全手順です：

1. **reCAPTCHA v3** - スパム対策の自動導入
2. **プライバシーポリシー同意** - 法的要件への対応
3. **自動返信メール** - ユーザーへの即座の確認
4. **CSS リデザイン** - フォームの見た目を改善

---

## Step 1️⃣: Google Cloud Console で reCAPTCHA キー取得

### 1-1: Google Cloud Console にアクセス

```
URL: https://console.cloud.google.com/
ログイン: CEO 神崎慧のメール（現在の Google アカウント）
```

### 1-2: プロジェクト選択またはプロジェクト作成

```
画面上部の「プロジェクト選択」→ 「新しいプロジェクト」
プロジェクト名: 凪フィナンシャル-Nagi-Financial (または任意の名前)
作成をクリック
```

### 1-3: API を有効化

```
左サイドメニュー → 「API とサービス」
「+ API とサービスの有効化」をクリック
検索ボックスに「recaptcha」と入力
「reCAPTCHA Enterprise API」を選択
「有効にする」をクリック
```

### 1-4: 認証情報（キー）を作成

```
左サイドメニュー → 「認証情報」
「+ 認証情報を作成」→ 「API キー」を選択
（ポップアップが出たらとじる）

再度「+ 認証情報を作成」→ 「reCAPTCHA キー」を選択

以下の情報を入力:
┌─────────────────────────────────────┐
│ reCAPTCHA タイプ: reCAPTCHA v3       │
│                                     │
│ サイトのリスト:                      │
│ ├─ https://www.komashikifx.site    │
│ ├─ https://komashikifx.site        │
│ ├─ http://localhost                │
│ └─ http://localhost:3000           │
│                                     │
│ 登録ボタン: 「作成」をクリック      │
└─────────────────────────────────────┘
```

### 1-5: キーをメモ

```
作成後、以下の 2 つのキーが表示されます：

┌──────────────────────────────────────┐
│ サイトキー（公開）:                  │
│ __________________ (コピーしてメモ)  │
│                                      │
│ シークレットキー（秘密）:            │
│ __________________ (コピーしてメモ)  │
└──────────────────────────────────────┘

🔒 シークレットキーは絶対に公開しないこと！
```

---

## Step 2️⃣: WordPress で Contact Form 7 をセットアップ

### 2-1: WordPress 管理画面にログイン

```
URL: https://www.komashikifx.site/wp-admin/
ユーザー名: (現在のログイン情報)
パスワード: (現在のログイン情報)
```

### 2-2: Contact Form 7 プラグインをインストール（未インストール時）

```
左サイドメニュー → 「プラグイン」→ 「新規追加」
検索ボックスに「Contact Form 7」と入力
「Contact Form 7」（作者: Takayuki Miyoshi）を選択
「今すぐインストール」→ 「有効化」をクリック
```

### 2-3: reCAPTCHA を Contact Form 7 に設定

```
左サイドメニュー → 「Contact Form 7」
→ 「インテグレーション」をクリック

「reCAPTCHA」セクションで:
┌─────────────────────────────────────┐
│ サイトキーを入力:                    │
│ [Step 1-5でメモしたサイトキー]      │
│                                     │
│ シークレットキーを入力:              │
│ [Step 1-5でメモしたシークレット]    │
│                                     │
│ バージョン: reCAPTCHA v3を選択       │
│                                     │
│ 「変更を保存」をクリック             │
└─────────────────────────────────────┘
```

---

## Step 3️⃣: Contact Form のコード修正

### 3-1: 現在のフォームを開く

```
左サイドメニュー → 「Contact Form 7」
既存のフォーム（例: 「お問い合わせ」）をクリック
```

### 3-2: フォームコードを編集

`フォーム` タブで、現在のコードを確認します。
以下の構造であることを確認：

```
[text* your-name placeholder "お名前"]
[email* your-email placeholder "メールアドレス"]
[text* your-subject placeholder "件名"]
[textarea* your-message placeholder "メッセージ"]
[checkbox privacy-agree "プライバシーポリシーに同意します"]
[recaptcha]
[submit "送信する"]
```

**現在のコードがない場合、以下を新規作成:**

```
以下をコピーして「フォーム」タブの入力欄に貼り付けます：

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
<div class="form-group">
  <label>お名前 <span class="required">*</span></label>
  [text* your-name placeholder "例：山田太郎"]
</div>

<div class="form-group">
  <label>メールアドレス <span class="required">*</span></label>
  [email* your-email placeholder "例：example@example.com"]
</div>

<div class="form-group">
  <label>件名 <span class="required">*</span></label>
  [text* your-subject placeholder "例：お問い合わせ内容"]
</div>

<div class="form-group">
  <label>メッセージ <span class="required">*</span></label>
  [textarea* your-message placeholder "例：詳しくお聞きしたい内容..."]
</div>

<div class="form-group">
  <label>
    [checkbox* privacy-agree "プライバシーポリシーに同意します"]
  </label>
  <p style="font-size: 12px;">
    <a href="/privacy-policy" target="_blank">プライバシーポリシー</a>
    をご確認の上、同意してください。
  </p>
</div>

[recaptcha]

<div class="form-group">
  [submit "送信する"]
</div>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 3-3: 必須フィールドの設定

`メール` タブで以下を確認/設定：

```
【フィールドの必須設定】

1. your-name
   ├─ 型: テキスト
   └─ 必須: ✓ チェック

2. your-email
   ├─ 型: メール
   └─ 必須: ✓ チェック

3. your-subject
   ├─ 型: テキスト
   └─ 必須: ✓ チェック

4. your-message
   ├─ 型: テキストエリア
   └─ 必須: ✓ チェック

5. privacy-agree
   ├─ 型: チェックボックス
   └─ 必須: ✓ チェック
   └─ エラーメッセージ: 
       「プライバシーポリシーに同意してください」
```

---

## Step 4️⃣: 自動返信メール設定

### 4-1: Mail(2) タブを開く

Contact Form の編集画面で「メール(2)」タブをクリック
（初回は「メールを追加」で作成が必要な場合あり）

### 4-2: 設定を入力

```
【Mail(2) 設定】

To: [your-email]
    └─ ユーザーのメールアドレスに自動返信を送信

From: kei@komasanshop.com
      └─ 凪フィナンシャル のメールアドレス

件名(Subject):
  お問い合わせをお受けしました

本文(Body):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[your-name] 様

いつも凪フィナンシャルをご利用いただき、
ありがとうございます。

お送りいただいたお問い合わせを確認いたしました。

【ご入力いただいた内容】
件名: [your-subject]
内容: 
[your-message]

【対応予定】
担当者が 24時間以内に
ご返信させていただきます。

【その他】
ご質問やご不明な点がございましたら、
いつでもお気軽にお問い合わせください。

凪フィナンシャル
神崎慧
https://www.komashikifx.site/
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

有効化: ✓ チェック

「保存」をクリック
```

---

## Step 5️⃣: CSS スタイル適用

### 5-1: WordPress テーマカスタマイザーを開く

```
左サイドメニュー → 「外観」→ 「カスタマイズ」
```

### 5-2: 追加 CSS に貼り付け

「追加 CSS」セクション（最下部）を開き、
以下のコードを入力欄に貼り付けます：

```css
/* Contact Form 7 カスタムスタイル */

/* フォーム全体 */
.wpcf7-form {
  max-width: 600px;
  margin: 40px auto;
  padding: 40px;
  background: linear-gradient(135deg, #f5f7fa 0%, #f9fbfd 100%);
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 51, 102, 0.1);
  font-family: 'Arial', 'Segoe UI', sans-serif;
}

/* フォームグループ */
.form-group {
  margin-bottom: 22px;
}

/* ラベル */
.wpcf7-form label,
.form-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #003366;
  font-size: 15px;
}

.required {
  color: #dc3545;
  margin-left: 4px;
}

/* 入力フィールド */
.wpcf7-form-control input[type="text"],
.wpcf7-form-control input[type="email"],
.wpcf7-form-control input[type="tel"],
.wpcf7-form-control textarea {
  width: 100%;
  padding: 14px 16px;
  border: 2px solid #e0e6ed;
  border-radius: 6px;
  font-size: 16px;
  font-family: inherit;
  background: #ffffff;
  transition: all 0.3s ease;
  box-sizing: border-box;
}

/* フォーカス時 */
.wpcf7-form-control input[type="text"]:focus,
.wpcf7-form-control input[type="email"]:focus,
.wpcf7-form-control input[type="tel"]:focus,
.wpcf7-form-control textarea:focus {
  outline: none;
  border-color: #007bff;
  box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
  background: #ffffff;
}

/* プレースホルダー */
.wpcf7-form-control input::placeholder,
.wpcf7-form-control textarea::placeholder {
  color: #999;
  opacity: 1;
}

/* チェックボックス */
.wpcf7-form-control input[type="checkbox"] {
  margin-right: 8px;
  cursor: pointer;
}

.wpcf7-form-control input[type="checkbox"] + label {
  display: inline;
  margin-bottom: 0;
  font-weight: normal;
  cursor: pointer;
  font-size: 14px;
}

/* 送信ボタン */
.wpcf7-form .wpcf7-submit {
  background: linear-gradient(135deg, #003366 0%, #001f3f 100%);
  color: #ffffff;
  padding: 16px 48px;
  border: none;
  border-radius: 6px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  width: 100%;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(0, 51, 102, 0.2);
  letter-spacing: 0.5px;
}

/* ボタンホバー */
.wpcf7-form .wpcf7-submit:hover {
  background: linear-gradient(135deg, #001f3f 0%, #000a1a 100%);
  box-shadow: 0 6px 16px rgba(0, 51, 102, 0.3);
  transform: translateY(-2px);
}

/* ボタンクリック */
.wpcf7-form .wpcf7-submit:active {
  transform: translateY(0);
  box-shadow: 0 2px 8px rgba(0, 51, 102, 0.2);
}

/* エラーメッセージ */
.wpcf7-form .wpcf7-not-valid {
  border-color: #dc3545 !important;
  background-color: #fff5f5;
}

.wpcf7-form .wpcf7-not-valid-tip {
  color: #dc3545;
  font-size: 13px;
  margin-top: 6px;
  display: block;
}

/* 成功メッセージ */
.wpcf7-form .wpcf7-mail-sent-ok {
  background: #d4edda;
  border: 2px solid #28a745;
  color: #155724;
  padding: 16px;
  border-radius: 6px;
  margin-bottom: 20px;
  font-weight: 500;
}

/* モバイル対応（768px以下） */
@media (max-width: 768px) {
  .wpcf7-form {
    padding: 30px 20px;
    margin: 30px 15px;
  }

  .wpcf7-form-control input,
  .wpcf7-form-control textarea {
    font-size: 16px;
  }

  .wpcf7-form .wpcf7-submit {
    padding: 14px 32px;
    font-size: 15px;
  }
}

/* 超小型画面（480px以下） */
@media (max-width: 480px) {
  .wpcf7-form {
    padding: 20px 15px;
    margin: 20px 10px;
  }

  .wpcf7-form label {
    font-size: 14px;
  }

  .wpcf7-form-control input,
  .wpcf7-form-control textarea {
    font-size: 16px;
    padding: 12px 12px;
  }

  .wpcf7-form .wpcf7-submit {
    padding: 12px 24px;
    font-size: 14px;
  }
}
```

### 5-3: 保存

「公開」をクリックして変更を保存します。

---

## ✅ テスト手順

### テスト 1: フォーム送信テスト（PC）

```
1. https://www.komashikifx.site/お問い合わせ/ にアクセス
2. フォームを入力:
   ├─ 名前: テスト太郎
   ├─ メール: test@example.com
   ├─ 件名: テスト送信
   └─ メッセージ: これはテスト送信です
3. チェックボックスにチェック
4. 「送信する」をクリック
5. 確認:
   ├─ 成功メッセージが表示されるか
   ├─ エラーがないか
   └─ reCAPTCHA が自動判定したか（目に見えない）
```

### テスト 2: 自動返信メール確認

```
1. テスト 1 の直後、test@example.com に
   メールが届いているか確認
2. メール内容:
   ├─ 件名: 「お問い合わせをお受けしました」
   ├─ 送信者: kei@komasanshop.com
   ├─ テスト情報が正しく表示されているか
   └─ リンクが機能するか
```

### テスト 3: 必須フィールド検証

```
1. フォームを空のまま送信
2. エラーメッセージが表示されるか確認
3. 各フィールドを 1 つずつ空にして送信テスト
```

### テスト 4: モバイル表示テスト

```
1. モバイルブラウザで同じ URL にアクセス
2. 表示確認:
   ├─ フォーム全体が画面に収まっているか
   ├─ 入力フィールドが読みやすいサイズか
   ├─ ボタンが押しやすいサイズ（最小 44px）か
   ├─ テキストがズームされていないか
   └─ 横スクロール不要か
3. 送信テスト実施
```

### テスト 5: ブラウザ互換性テスト

```
以下各ブラウザで テスト 1-4 を実施:
□ Chrome（最新版）
□ Safari（最新版）
□ Firefox（最新版）
□ Edge（最新版）
```

---

## 🔍 トラブルシューティング

### メールが届かない場合

```
1. WordPress の「設定」→ 「一般」でメール設定確認
2. Contact Form 7 の「メール」タブで
   From アドレスと To アドレスが正しいか確認
3. スパムフォルダを確認
4. サーバーのメール機能が有効化されているか確認
```

### reCAPTCHA が動作しない場合

```
1. Step 2-3 で サイトキーとシークレットキーが正しく入力されているか確認
2. Google Cloud Console で設定したドメインが
   現在のサイトドメインと一致しているか確認
3. Contact Form のコードに [recaptcha] タグが含まれているか確認
4. Contact Form を保存後、ページをリロードして再度テスト
```

### CSS が反映されない場合

```
1. WordPress の外観 > カスタマイズ > 追加 CSS が保存されているか確認
2. ブラウザのキャッシュをクリア
   ├─ Ctrl + Shift + Delete（Windows）
   └─ Cmd + Shift + Delete（Mac）
3. ページをハードリロード
   ├─ Ctrl + F5（Windows）
   └─ Cmd + Shift + R（Mac）
```

---

## 📋 完了チェックリスト

```
【reCAPTCHA v3 セットアップ】
□ Google Cloud Console でプロジェクト作成
□ reCAPTCHA API を有効化
□ サイトキーとシークレットキーを取得
□ Contact Form 7 インテグレーションで設定
□ フォームコードに [recaptcha] を追加
□ テスト送信で reCAPTCHA が動作することを確認

【プライバシーチェックボックス】
□ フォームコードにチェックボックスを追加
□ プライバシーポリシーへのリンクを確認
□ 必須フィールド設定が完了

【自動返信メール】
□ Mail(2) タブを設定
□ To: [your-email] に設定
□ From: kei@komasanshop.com に設定
□ 本文テンプレートを入力
□ 「有効化」にチェック
□ テストメールが届くか確認

【CSS リデザイン】
□ 追加 CSS にコードを貼り付け
□ 「公開」をクリック
□ PC 表示で確認（色、スペース、ホバー効果）
□ モバイル表示で確認
□ 各ブラウザで動作確認

【最終確認】
□ すべてのテスト合格
□ フロントエンドで正常に表示されている
□ エラーメッセージが表示されない
□ モバイルでも問題なく動作している
```

---

**実装者:** CEO 神崎慧  
**企業:** 凪フィナンシャル  
**完成予定日:** 2026-04-13
