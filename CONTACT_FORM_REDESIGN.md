# 📧 お問い合わせフォーム修正・リデザイン計画

**対象URL:** https://www.komashikifx.site/お問い合わせ/  
**実施日:** 2026-04-13  
**責任者:** CEO かんざき けい  
**優先度:** 🟡 HIGH

---

## 📋 現在のフォーム状況（確認待ち）

ユーザーからの指示で、以下が必要と判明：

```
❓ 現在のお問い合わせフォームの状態:
  ├─ Contact Form 7 プラグイン使用か?
  ├─ 現在の入力項目は?
  │  └─ 名前 / メール / 件名 / メッセージ ?
  ├─ バリデーション（入力検証）はあるか?
  └─ スパム対策（reCAPTCHA）はあるか?

📌 修正・リデザインの目的:
  ├─ 顧客対応の質向上
  ├─ スパム・不正入力の削減
  ├─ UI/UX の改善（モバイル対応）
  └─ 法的要件への対応（個人情報取得）
```

---

## 🎯 修正案：3段階リデザイン

### Phase 1: すぐに実装（緊急修正）

**目的:** スパム対策 + 個人情報保護対応

```
【追加すべき項目】

1️⃣ Google reCAPTCHA v3 導入
   ├─ Contact Form 7 と統合
   ├─ 人間 vs bot の自動判定
   ├─ ユーザーの負担を最小化
   └─ 手順: 
      1. Google Cloud Console で reCAPTCHA キー取得
      2. CF7 に設定
      3. テスト送信で動作確認

2️⃣ プライバシーポリシーリンク
   ├─ フォーム下部に「個人情報取得の同意」チェック
   └─ 本来は必須（法的要件）

3️⃣ 自動返信メール設定
   ├─ 顧客が送信後すぐに確認メールを受け取る
   ├─ 「お問い合わせ受領しました」メッセージ
   └─ 対応予定日時を明記

4️⃣ 入力ガイドの改善
   ├─ 「メールアドレスを正しく入力してください」
   ├─ 「お問い合わせ内容を詳しく説明してください」
   └─ 入力エラー時の親切なメッセージ
```

### Phase 2: UIデザイン改善（本日実装）

**目的:** ユーザー体験の向上 + モバイル最適化

```
【デザイン修正案】

現在の問題:
  ❌ テキストが詰まり気味
  ❌ モバイルで見づらい
  ❌ CTA（送信ボタン）が目立たない
  ❌ エラー表示が分かりづらい

修正案:
  ✅ スペース調整（margin/padding 増加）
  ✅ モバイル レスポンシブ対応
     └─ 幅 100% で小画面適応
  ✅ 送信ボタンのスタイル改善
     ├─ 色: 目立つ色（ネイビー or 青）
     ├─ サイズ: 50px以上の高さ
     ├─ テキスト: 「送信する」or「問い合わせる」
     └─ ホバー効果: 色が濃くなる
  ✅ 入力フィールド の強調
     └─ フォーカス時に枠線が青くなる

【CSS 修正例】
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/* Contact Form 修正 */
.wpcf7-form {
  margin: 30px auto;
  padding: 30px;
  max-width: 600px;
  background: #f9f9f9;
  border-radius: 8px;
}

.wpcf7-form-control {
  margin-bottom: 20px;
  width: 100%;
}

.wpcf7-form-control input,
.wpcf7-form-control textarea {
  width: 100%;
  padding: 12px 15px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 16px;
  font-family: inherit;
}

.wpcf7-form-control input:focus,
.wpcf7-form-control textarea:focus {
  outline: none;
  border-color: #007bff;
  box-shadow: 0 0 5px rgba(0,123,255,0.25);
}

.wpcf7-form .wpcf7-submit {
  background-color: #003366;
  color: white;
  padding: 15px 40px;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  width: 100%;
  transition: background-color 0.3s;
}

.wpcf7-form .wpcf7-submit:hover {
  background-color: #001f3f;
}

/* モバイル対応 */
@media (max-width: 768px) {
  .wpcf7-form {
    padding: 20px;
  }
}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Phase 3: 自動化・回答体制（来週以降）

**目的:** 顧客対応の効率化

```
【実装予定】

1️⃣ お問い合わせ内容の自動振り分け
   ├─ 「NK225シグナルについて」 → CEO へ割り当て
   ├─ 「MT4インジケーターについて」 → 技術担当へ割り当て
   └─ 「その他」 → 一般対応

2️⃣ 自動応答メール
   ├─ テンプレート 3パターン
   ├─ 返信予定時間: 24時間以内
   └─ 例: 
      ```
      ご問い合わせありがとうございます。
      
      お送りいただいたお問い合わせについて、
      24時間以内にご返信させていただきます。
      
      お待たせして申し訳ございません。
      
      凪フィナンシャル CEO かんざき けい
      ```

3️⃣ お問い合わせ管理ダッシュボード
   ├─ 未対応件数の表示
   ├─ 返信状況の追跡
   └─ 平均対応時間の測定
```

---

## 🔧 実装手順（WordPress）

### Step 1: Contact Form 7 の確認（15分）

```bash
【WordPress 管理画面で実施】

1. ダッシュボード > Contact Form 7
   └─ 現在のフォーム編集を開く

2. フォーム編集画面で確認:
   ├─ [text* name] - 名前
   ├─ [email* mail] - メール
   ├─ [text subject] - 件名
   ├─ [textarea message] - メッセージ
   └─ [submit] - 送信ボタン

3. 現在のコードを確認
   └─ Screenshot 取得して CEO へ報告
```

### Step 2: reCAPTCHA v3 設定（30分）

```
【Google Cloud 設定】

1. Google Cloud Console へアクセス
   URL: https://console.cloud.google.com/

2. reCAPTCHA を検索 → API 有効化

3. reCAPTCHA キーを取得
   ├─ Site Key (サイトキー)
   └─ Secret Key (シークレットキー)

【WordPress 設定】

4. Contact Form 7 管理画面
   └─ インテグレーション > reCAPTCHA
   ├─ Site Key を入力
   ├─ Secret Key を入力
   └─ v3 を選択

5. フォームのコードにタグを追加
   └─ [recaptcha]
```

### Step 3: CSS リデザイン（30分）

```
【WordPress カスタマイズ】

1. 外観 > カスタマイズ
   └─ 追加 CSS

2. 上記の CSS コードを貼り付け
   └─ プレビューで確認

3. 公開 > 保存

4. フロントエンドでテスト
   ├─ モバイルで表示確認
   ├─ 入力テスト
   ├─ 送信テスト
   └─ 自動返信メール確認
```

### Step 4: プライバシーチェックボックス追加（15分）

```
【Contact Form 7 コード修正】

フォームコード例:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[text* your-name placeholder "お名前"]

[email* your-email placeholder "メールアドレス"]

[text your-subject placeholder "件名"]

[textarea your-message placeholder "お問い合わせ内容" rows:6]

[checkbox privacy-accept "プライバシーポリシーに同意します"]

[recaptcha]

[submit class:btn-custom "送信する"]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【メール設定】

Mail: to = kei@komasanshop.com
      subject = "【新規お問い合わせ】[your-subject]"
      
Mail (2): to = [your-email]
          subject = "お問い合わせをお受けしました"
          body = [自動返信メール本文]
```

---

## 📧 自動返信メール テンプレート

```
【件名】
お問い合わせをお受けしました - 凪フィナンシャル

【本文】
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[your-name] 様

いつも凪フィナンシャルをご利用いただき、
ありがとうございます。

お送りいただいたお問い合わせを確認いたしました。

【ご入力いただいた内容】
件名: [your-subject]
内容: [your-message]

【対応予定】
CEO かんざき けいが 24時間以内に
ご返信させていただきます。

お急ぎの場合は、
以下のメールアドレスへお送りください:
kei@komasanshop.com

【その他】
ご質問やご不明な点がございましたら、
いつでもお気軽にお問い合わせください。

凪フィナンシャル
CEO: 神崎慧
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## ✅ 修正完了チェックリスト

```
【Phase 1: 緊急修正】
□ reCAPTCHA v3 を導入
□ プライバシーチェックボックスを追加
□ 自動返信メール設定を完了
□ 入力ガイドを改善

【Phase 2: デザイン改善】
□ CSS をカスタマイズ
□ モバイル レスポンシブ対応を確認
□ 送信ボタンのスタイルを改善
□ フォーカス効果（枠線の色変更）を実装

【Phase 3: テスト】
□ Desktop で送信テスト
□ Mobile で送信テスト
□ 自動返信メール受け取り確認
□ スパム判定（reCAPTCHA）動作確認

【Phase 4: デプロイ】
□ 本番環境へ反映
□ 24時間のモニタリング
□ 完了報告を Discord へ投稿
```

---

## 🎬 CEO からのタスク定義

```
【本日のタスク】

Task: お問い合わせフォーム修正・リデザイン
Priority: 🟡 HIGH
Deadline: 2026-04-13 (本日) 18:00

Subtasks:
1. 現在のフォーム状態を確認
   └─ Screenshot 取得 + 分析
   
2. reCAPTCHA v3 を導入
   └─ Google Cloud キー取得
   
3. CSS リデザイン実装
   └─ モバイル対応確認
   
4. テスト送信 × 3回
   └─ Desktop / Mobile / 複数端末
   
5. 完了報告を Discord へ
   └─ Before / After の screenshot 添付

時間目安: 2時間
担当: CEO かんざき けい
確認者: オーナー 小松直人
```

---

## 📊 現在の進捗

```
🔴 未開始（確認待ち）

次のステップ:
1. ユーザーからの詳細指示を受ける
2. 現在のフォーム状態を確認
3. 修正案をアップデート
4. 本番実装を開始
```

---

**実施日:** 2026-04-13  
**責任者:** CEO かんざき けい  
**ステータス:** 📋 仕様確認待ち

---

**CEO: 神崎慧**  
**Organization: 凪フィナンシャル**  
**Date: 2026-04-13**
