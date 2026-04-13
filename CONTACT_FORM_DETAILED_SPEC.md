# 📧 お問い合わせフォーム修正 詳細指示書

**対象ページ:** https://www.komashikifx.site/お問い合わせ/  
**実施日:** 2026-04-13（本日）  
**責任者:** CEO 神崎慧  
**優先度:** 🟡 HIGH  
**ステータス:** ⏳ スクリーンショット確認待ち

---

## 📸 現在の状態確認（スクリーンショット提出待ち）

### ユーザーへのお願い

以下の手順で、**現在のお問い合わせフォームのスクリーンショット**を送ってください：

```
1. https://www.komashikifx.site/お問い合わせ/ にアクセス
2. ページ全体が見える状態で、スクリーンショット取得
3. フォームの以下の部分も確認：
   ├─ フォーム全体（PC表示）
   ├─ フォーム全体（モバイル表示）
   ├─ フォーム下部（ボタン・免責事項）
   └─ ブラウザの開発者ツール > 要素検査でHTMLコード確認

4. スクリーンショット 3-4枚を Discord へ送信
   └─ フォーム全体
   └─ 入力欄詳細
   └─ 送信ボタン周辺
   └─ モバイル表示
```

---

## 📋 修正内容の詳細指示

### Phase 1: 緊急修正（本日実装）

#### 1️⃣ reCAPTCHA v3 導入

**現在の確認：**
```
□ 現在、スパム対策（reCAPTCHA）は実装されているか？
  ├─ NO → 今日実装が必須
  └─ YES → v3 か v2 か確認
```

**実装手順：**
```bash
【Step 1】Google Cloud Console でキー取得

1. Google Cloud Console へアクセス
   URL: https://console.cloud.google.com/
   
2. プロジェクト作成 or 既存プロジェクト選択
   
3. API > reCAPTCHA を検索
   └─ API を有効化
   
4. 認証情報 > 認証情報を作成
   └─ reCAPTCHA キーを作成
   ├─ reCAPTCHA v3 を選択
   ├─ サイト: komasanshop.com, komashikifx.site
   ├─ テスト環境: localhost
   └─ キー生成
   
5. 2つのキーをメモ:
   ├─ サイトキー（公開）: _______________
   └─ シークレットキー（秘密）: _______________

【Step 2】WordPress に設定

1. WordPress 管理画面にログイン
   URL: https://www.komashikifx.site/wp-admin/

2. Contact Form 7 をインストール（未インストール時）
   ├─ プラグイン > 新規追加
   ├─ 「Contact Form 7」検索
   └─ インストール & 有効化
   
3. Contact Form 7 > インテグレーション
   └─ reCAPTCHA を設定
   ├─ サイトキーを入力
   ├─ シークレットキーを入力
   └─ v3 を選択

【Step 3】フォームに reCAPTCHA タグを追加

フォームコードに以下を追加:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[recaptcha]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

(送信ボタンの直前に記載)
```

#### 2️⃣ プライバシー同意チェックボックス追加

```
【現在の確認】
□ プライバシーポリシーへのリンクはあるか
□ 同意チェックボックスはあるか

【実装内容】

フォームコードに以下を追加:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[checkbox privacy-agree "プライバシーポリシーに同意します"]

<p style="font-size: 12px;">
  <a href="/privacy-policy" target="_blank">
    プライバシーポリシー
  </a>
  をご確認の上、同意してください。
</p>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

バリデーション設定:
├─ required（必須）に設定
└─ エラーメッセージ: 
   「プライバシーポリシーに同意してください」
```

#### 3️⃣ 自動返信メール設定

```
【メール(2) 設定】

Mail タブで新規追加:

Subject: お問い合わせをお受けしました

Body:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[your-name] 様

いつも凪フィナンシャルをご利用いただき、
ありがとうございます。

お送りいただいたお問い合わせを確認いたしました。

【ご入力いただいた内容】
件名: [your-subject]
内容: 
[your-message]

【対応予定】
CEO 神崎慧が 24時間以内に
ご返信させていただきます。

【その他】
ご質問やご不明な点がございましたら、
いつでもお気軽にお問い合わせください。

凪フィナンシャル
CEO: 神崎慧
https://www.komashikifx.site/
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【重要】
□ To: [your-email]（顧客のメールアドレス）
□ From: kei@komasanshop.com （CEO のメール）
□ 有効化: チェック ✓
```

---

### Phase 2: CSSリデザイン（本日実装）

#### 4️⃣ スタイル改善

```css
/* Contact Form 修正 - 外観 > カスタマイズ > 追加CSS に貼り付け */

/* フォーム全体のスタイル */
.wpcf7-form {
  max-width: 600px;
  margin: 40px auto;
  padding: 40px;
  background: linear-gradient(135deg, #f5f7fa 0%, #f9fbfd 100%);
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 51, 102, 0.1);
  font-family: 'Arial', sans-serif;
}

/* 入力フィールド全体 */
.wpcf7-form-control {
  margin-bottom: 22px;
  width: 100%;
  display: block;
}

/* テキスト入力 & テキストエリア */
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

/* フォーカス時（ユーザーがクリック） */
.wpcf7-form-control input[type="text"]:focus,
.wpcf7-form-control input[type="email"]:focus,
.wpcf7-form-control input[type="tel"]:focus,
.wpcf7-form-control textarea:focus {
  outline: none;
  border-color: #007bff;
  box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
  background: #ffffff;
}

/* プレースホルダーテキスト */
.wpcf7-form-control input::placeholder,
.wpcf7-form-control textarea::placeholder {
  color: #999;
  opacity: 1;
}

/* ラベル（フォーム上の項目名） */
.wpcf7-form label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #003366;
  font-size: 15px;
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

/* ボタンホバー（マウスオーバー） */
.wpcf7-form .wpcf7-submit:hover {
  background: linear-gradient(135deg, #001f3f 0%, #000a1a 100%);
  box-shadow: 0 6px 16px rgba(0, 51, 102, 0.3);
  transform: translateY(-2px);
}

/* ボタンクリック時 */
.wpcf7-form .wpcf7-submit:active {
  transform: translateY(0);
  box-shadow: 0 2px 8px rgba(0, 51, 102, 0.2);
}

/* チェックボックス・ラジオボタン */
.wpcf7-form-control input[type="checkbox"],
.wpcf7-form-control input[type="radio"] {
  margin-right: 8px;
  cursor: pointer;
}

.wpcf7-form-control input[type="checkbox"] + label,
.wpcf7-form-control input[type="radio"] + label {
  display: inline;
  margin-bottom: 0;
  font-weight: normal;
  cursor: pointer;
  font-size: 14px;
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

/* モバイル対応 */
@media (max-width: 768px) {
  .wpcf7-form {
    padding: 30px 20px;
    margin: 30px 15px;
  }

  .wpcf7-form-control input,
  .wpcf7-form-control textarea {
    font-size: 16px; /* モバイルでズーム防止 */
  }

  .wpcf7-form .wpcf7-submit {
    padding: 14px 32px;
    font-size: 15px;
  }
}

/* 超小型画面（スマートフォン） */
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

---

## ✅ テスト手順

### テスト1: フォーム送信テスト（PC）

```
1. https://www.komashikifx.site/お問い合わせ/ にアクセス
2. 以下の情報を入力:
   ├─ 名前: テスト太郎
   ├─ メール: test@example.com
   ├─ 件名: テスト送信
   └─ メッセージ: これはテスト送信です
3. チェックボックスにチェック
4. 「送信する」ボタンをクリック
5. 確認:
   ├─ ページ上に成功メッセージが表示されるか
   ├─ エラーメッセージはないか
   └─ reCAPTCHA が自動判定したか（目に見えない）
```

### テスト2: 自動返信メール確認

```
1. テスト1の送信直後、test@example.com に
   「お問い合わせをお受けしました」メールが届いているか確認
   
2. メール内容確認:
   ├─ 件名が正しいか
   ├─ ユーザーの情報が正しく表示されているか
   ├─ CEO からの返信予定日時が明記されているか
   └─ リンクが正しく機能するか
```

### テスト3: モバイル表示テスト

```
1. モバイルブラウザ（スマートフォン）で
   https://www.komashikifx.site/お問い合わせ/ にアクセス
   
2. 表示確認:
   ├─ フォーム全体が画面に収まっているか
   ├─ 入力フィールドが読みやすいサイズか
   ├─ ボタンが押しやすいサイズか（最小44px推奨）
   ├─ テキストがズームされていないか
   └─ 横スクロール不要か
   
3. 送信テスト:
   ├─ フォームを入力して送信
   ├─ 成功メッセージが表示されるか
   └─ メールが届くか
```

### テスト4: ブラウザ互換性テスト

```
□ Chrome（最新版）
□ Safari（最新版）
□ Firefox（最新版）
□ Edge（最新版）

各ブラウザで テスト1-3 を実施
```

---

## 📋 修正完了チェックリスト

```
【reCAPTCHA v3 実装】
□ Google Cloud Console でキー取得
□ WordPress にキーを設定
□ Contact Form 7 に [recaptcha] タグ追加
□ テスト送信で動作確認

【プライバシー同意】
□ チェックボックスを追加
□ バリデーション設定（必須）
□ プライバシーポリシーへのリンク確認

【自動返信メール】
□ Mail(2) を設定
□ To / From アドレス確認
□ 本文テンプレート入力
□ テストメール受け取り確認

【CSSリデザイン】
□ 外観 > カスタマイズ > 追加CSS に貼り付け
□ PC表示で確認（色・スペース・ホバー）
□ モバイル表示で確認
□ 各ブラウザで動作確認

【本番デプロイ】
□ すべてのテスト合格
□ 管理画面で「公開」状態確認
□ フロントエンドで動作確認
□ 24時間のモニタリング
□ 問題があれば即座に修正
```

---

## 🎬 次のステップ

### 本日中にやること

```
1. 現在のフォームをスクリーンショット送信
   └─ PC表示 + モバイル表示
   
2. Google Cloud Console でキー取得
   └─ サイトキー & シークレットキーをメモ
   
3. WordPress で設定実装
   └─ reCAPTCHA v3 導入
   └─ プライバシーチェックボックス追加
   └─ 自動返信メール設定
   
4. CSS をカスタマイズ
   └─ 外観 > カスタマイズに上記コード貼り付け
   
5. テスト実施
   └─ PC / モバイル / 各ブラウザで確認
   
6. 完成報告を Discord へ
   └─ Before / After のスクリーンショット添付
```

---

**実施日:** 2026-04-13  
**責任者:** CEO 神崎慧  
**ステータス:** ⏳ スクリーンショット確認待ち

---

**CEO: 神崎慧**  
**Organization: 凪フィナンシャル**
