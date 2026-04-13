# 🚀 WordPress デプロイメント チェックリスト

**デプロイ日:** 2026-04-14  
**対象サイト:** https://www.komashikifx.site  
**対象バージョン:** Claude/review-nagi-financial-shop-5xOxg

---

## 📋 デプロイメント手順

### **フェーズ 1: WordPress 管理画面にアクセス**

```
URL: https://www.komashikifx.site/wp-admin/
ログイン: 管理者アカウント
```

**チェック:**
- [ ] ログイン成功
- [ ] ダッシュボード表示確認

---

### **フェーズ 2: プラグインのインストール・有効化**

#### **2-1. Contact Form 7 をインストール**

```
左サイドメニュー → プラグイン → 新規追加
検索: 「Contact Form 7」
```

**操作:**
- [ ] 「Contact Form 7 by Takayuki Miyoshi」を検索
- [ ] 「インストール」をクリック
- [ ] 「有効化」をクリック

#### **2-2. reCAPTCHA v3 統合（オプション）**

Contact Form 7 インストール後、以下いずれかを実施:

**方法 A: プラグイン追加（推奨）**
```
プラグイン → 新規追加
検索: 「reCAPTCHA」
「Contact Form 7 reCAPTCHA」 or 「Invisible reCAPTCHA」をインストール
```

**方法 B: 手動設定（高度）**
```
Google Cloud Console からキーを取得
Contact Form 7 設定で手動入力
```

**チェック:**
- [ ] Contact Form 7 有効化確認
- [ ] プラグイン一覧に表示されている

---

### **フェーズ 3: Contact Form 7 フォーム設定**

#### **3-1. フォームを開く**

```
左サイドメニュー → Contact Form 7 → Contact Forms
「お問い合わせ」をクリック
```

#### **3-2. フォーム構造を確認・修正**

**Form タブ:**
```
[text* your-name placeholder "名前"]
[email* your-email placeholder "メールアドレス"]
[text* your-subject placeholder "件名"]
[textarea your-message placeholder "メッセージ"]
[checkbox consent "プライバシーポリシーに同意する"]
[recaptcha]
[submit "送信"]
```

**チェック:**
- [ ] Form タブ内容を確認
- [ ] 必須フィールド (*) が設定されている
- [ ] reCAPTCHA タグが含まれている

#### **3-3. メール受け取り設定（Mail タブ）**

```
Tab: 「メール」
```

**設定内容:**

| 項目 | 値 |
|------|-----|
| **To** | `kei@komasanshop.com` |
| **From** | `凪フィナンシャル お問い合わせ対応` |
| **Subject** | `[新規お問い合わせ] [your-subject]` |

**メール本文テンプレート:**
```
新しいお問い合わせがあります。

【申込者情報】
名前: [your-name]
メール: [your-email]

【内容】
件名: [your-subject]

メッセージ:
[your-message]

────────────────────────────────────
本メールは自動送信です。返信不要です。
```

**オプション:**
- [ ] 「Exclude blank fields」にチェック
- [ ] 「Use HTML content type」にチェック

**チェック:**
- [ ] To アドレスが `kei@komasanshop.com` に設定されている
- [ ] 本文が正しく設定されている
- [ ] 「保存」をクリック

#### **3-4. 自動返信メール設定（Mail 2 タブ）**

```
Tab: 「メール(2)」
※ない場合は「＋」アイコンで新規作成
```

**設定内容:**

| 項目 | 値 |
|------|-----|
| **To** | `[your-email]` |
| **From** | `凪フィナンシャル サポートチーム` |
| **Subject** | `お問い合わせをお受けしました` |

**メール本文テンプレート:**
```
[your-name] 様へ

いつもお世話になっております。
凪フィナンシャルです。

この度はお問い合わせいただき、
ありがとうございます。

下記の内容でお受けしました：

【申込情報】
件名: [your-subject]

【対応予定】
お問い合わせの内容を確認の上、
24時間以内にご返信させていただきます。

ご不明な点やご不安なことがあれば、
遠慮なくお問い合わせください。

────────────────────────────────────
凪フィナンシャル
サポートチーム
```

**オプション:**
- [ ] 「Use HTML content type」にチェック

**チェック:**
- [ ] To が `[your-email]` に設定されている
- [ ] 自動返信内容が正しい
- [ ] 「保存」をクリック

---

### **フェーズ 4: フッター実装**

#### **4-1. テーマエディタを開く**

```
左サイドメニュー → 外観 → ファイルエディタ
```

#### **4-2. footer.php を確認・修正**

**方法 A: エディタで直接修正**

1. 右側パネルから「footer.php」を探す
2. ファイルを開く
3. ファイルの末尾（`</body>` の前）に以下のコードを追加：

```html
<!-- ===== Footer (Updated 2026-04-13) ===== -->
<footer class="site-footer">

  <div class="footer-content">

    <!-- Company Info Section -->
    <div class="footer-section footer-info">
      <h3 class="footer-brand">凪フィナンシャル</h3>
      <p class="footer-tagline">
        MT4対応トレーディングツール<br>& データ分析サービス
      </p>
    </div>

    <!-- About Section -->
    <div class="footer-section">
      <h4 class="footer-title">About</h4>
      <ul class="footer-menu">
        <li><a href="/about/">About</a></li>
        <li><a href="/members/">メンバー</a></li>
        <li><a href="/history/">沿革</a></li>
      </ul>
    </div>

    <!-- Legal Section -->
    <div class="footer-section">
      <h4 class="footer-title">Legal</h4>
      <ul class="footer-menu">
        <li><a href="/privacy/">プライバシー</a></li>
        <li><a href="/terms/">利用規約</a></li>
        <li><a href="/contact/">お問い合わせ</a></li>
      </ul>
    </div>

    <!-- Social Section -->
    <div class="footer-section">
      <h4 class="footer-title">Social</h4>
      <div class="footer-social">
        <a href="https://facebook.com/komashikifx" target="_blank" rel="noopener" class="social-link">
          <svg class="social-icon" viewBox="0 0 24 24" width="24" height="24">
            <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" fill="currentColor"/>
          </svg>
          Facebook
        </a>
        <a href="https://instagram.com/komashikifx" target="_blank" rel="noopener" class="social-link">
          <svg class="social-icon" viewBox="0 0 24 24" width="24" height="24">
            <path d="M12 0C8.74 0 8.333.015 7.053.072 5.775.132 4.905.333 4.117.6c-.588.147-1.079.35-1.57.742-.188.147-.36.295-.53.465-.17.17-.318.342-.465.53-.392.491-.594.982-.744 1.57-.266.788-.467 1.658-.527 2.936C.039 8.333.024 8.74 0 12s.015 3.667.072 4.947c.06 1.277.261 2.148.527 2.936.147.588.35 1.079.742 1.57.147.188.295.36.465.53.17.17.342.318.53.465.491.392.982.594 1.57.744.788.266 1.658.467 2.936.527C8.333 23.961 8.74 23.976 12 23.976s3.667-.015 4.947-.072c1.277-.06 2.148-.261 2.936-.527.588-.147 1.079-.35 1.57-.742.188-.147.36-.295.465-.53.17-.17.318-.342.465-.53.392-.491.594-.982.744-1.57.266-.788.467-1.658.527-2.936.058-1.28.072-1.687.072-4.947s-.015-3.667-.072-4.947c-.06-1.277-.261-2.148-.527-2.936-.147-.588-.35-1.079-.742-1.57-.147-.188-.295-.36-.465-.53-.17-.17-.342-.318-.53-.465-.491-.392-.982-.594-1.57-.744-.788-.266-1.658-.467-2.936-.527C15.667.039 15.26.024 12.001 0h-.001zm0 2.16c3.203 0 3.585.009 4.849.07 1.171.054 1.805.244 2.227.408.561.217.96.477 1.382.896.419.42.679.821.896 1.381.164.422.354 1.057.408 2.227.061 1.264.07 1.646.07 4.85s-.009 3.585-.07 4.849c-.054 1.171-.244 1.805-.408 2.227-.217.561-.477.96-.896 1.382-.42.419-.821.679-1.381.896-.422.164-1.057.354-2.227.408-1.264.061-1.646.07-4.85.07s-3.585-.009-4.849-.07c-1.171-.054-1.805-.244-2.227-.408-.561-.217-.96-.477-1.382-.896-.419-.42-.679-.821-.896-1.381-.164-.422-.354-1.057-.408-2.227-.061-1.264-.07-1.646-.07-4.849s.009-3.585.07-4.849c.054-1.171.244-1.805.408-2.227.217-.561.477-.96.896-1.382.42-.419.821-.679 1.381-.896.422-.164 1.057-.354 2.227-.408 1.264-.061 1.646-.07 4.849-.07z" fill="currentColor"/>
          </svg>
          Instagram
        </a>
        <a href="https://x.com/komashikifx" target="_blank" rel="noopener" class="social-link">
          <svg class="social-icon" viewBox="0 0 24 24" width="24" height="24">
            <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24h-6.514l-5.106-6.694-5.832 6.694H2.882l7.732-8.835L1.227 2.25h6.682l4.648 6.155 5.695-6.155zM17.15 18.75h1.828L5.857 3.957H3.873l13.277 14.793z" fill="currentColor"/>
          </svg>
          X
        </a>
      </div>
    </div>

  </div>

  <!-- Copyright -->
  <div class="footer-bottom">
    <p>&copy; 2026 凪フィナンシャル. All Rights Reserved.</p>
    <p>Designed with WordPress</p>
  </div>

</footer>

<style>
.site-footer {
  background-color: #003366;
  color: #ffffff;
  padding: 40px 20px;
  margin-top: 60px;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 40px;
  margin-bottom: 40px;
}

.footer-section {
  flex: 1;
}

.footer-info .footer-brand {
  font-size: 18px;
  font-weight: bold;
  margin: 0 0 10px 0;
  color: #ffffff;
}

.footer-info .footer-tagline {
  font-size: 14px;
  line-height: 1.6;
  color: #cccccc;
  margin: 0;
}

.footer-title {
  font-size: 16px;
  font-weight: 600;
  margin: 0 0 15px 0;
  color: #ffffff;
}

.footer-menu {
  list-style: none;
  padding: 0;
  margin: 0;
}

.footer-menu li {
  margin-bottom: 10px;
}

.footer-menu a {
  color: #cccccc;
  text-decoration: none;
  font-size: 14px;
  transition: color 0.3s ease;
}

.footer-menu a:hover {
  color: #ffffff;
}

.footer-social {
  display: flex;
  gap: 15px;
}

.social-link {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  color: #cccccc;
  text-decoration: none;
  font-size: 14px;
  transition: color 0.3s ease;
}

.social-link:hover {
  color: #ffffff;
}

.social-icon {
  width: 24px;
  height: 24px;
  color: currentColor;
}

.footer-bottom {
  max-width: 1200px;
  margin: 0 auto;
  border-top: 1px solid #555555;
  padding-top: 20px;
  text-align: center;
  font-size: 12px;
  color: #999999;
}

.footer-bottom p {
  margin: 5px 0;
}

/* レスポンシブ */
@media (max-width: 768px) {
  .footer-content {
    grid-template-columns: 1fr 1fr;
    gap: 30px;
  }

  .site-footer {
    padding: 30px 15px;
  }
}

@media (max-width: 480px) {
  .footer-content {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .footer-social {
    justify-content: center;
  }
}
</style>
```

4. 「ファイルの更新」をクリック

**チェック:**
- [ ] コード追加完了
- [ ] エラーなし

#### **4-3. フッター表示確認**

1. サイトのトップページにアクセス: https://www.komashikifx.site/
2. ページ下部を確認

**チェック:**
- [ ] フッター表示されている
- [ ] 凪フィナンシャルロゴが表示されている
- [ ] About / Legal / Social セクションがある
- [ ] リンク機能確認

---

### **フェーズ 5: Contact Form テスト**

#### **5-1. お問い合わせページにアクセス**

```
URL: https://www.komashikifx.site/お問い合わせ/
※ または /contact/
```

#### **5-2. テストメール送信**

**テストデータ入力:**
```
名前: テスト 太郎
メール: your-test-email@example.com
件名: テスト お問い合わせ
メッセージ: これはテストメールです
プライバシーチェックボックス: ✓ チェック
```

1. 各フィールドにテストデータ入力
2. 送信ボタンをクリック
3. 送信完了メッセージが表示されることを確認

**チェック:**
- [ ] フォーム送信成功
- [ ] 送信完了メッセージ表示
- [ ] エラーなし

#### **5-3. メール受信確認**

**CEO が以下を確認:**

```
①受信メール確認
  メールアドレス: kei@komasanshop.com
  受信メール: テスト お問い合わせ メールが到着
  内容: 送信者名・メールアドレス・メッセージが正しく表示

②自動返信メール確認
  メールアドレス: your-test-email@example.com
  受信メール: 「お問い合わせをお受けしました」通知が到着
  内容: 24時間以内に返信する旨が記載
```

**チェック:**
- [ ] kei@komasanshop.com に受信メール到着
- [ ] your-test-email@example.com に自動返信到着
- [ ] メール内容が正しい
- [ ] 送信者名・件名が正しく表示されている

---

### **フェーズ 6: レスポンシブ確認**

**PC ブラウザ:**
- [ ] フッター表示確認（フル幅）
- [ ] Contact Form 表示確認

**タブレット/スマートフォン:**

```
Chrome DevTools の Responsive Mode で確認
- 768px (タブレット)
- 480px (スマートフォン)
```

**チェック:**
- [ ] 768px で正しくレイアウト
- [ ] 480px で正しくレイアウト
- [ ] 文字が読みやすい
- [ ] ボタンが操作しやすい
- [ ] ソーシャルリンク配置が適切

---

## ✅ デプロイメント完了チェック

```
【フッター実装】
□ footer.php にコード追加完了
□ PC・モバイルで表示確認
□ リンク動作確認
□ ソーシャルリンク動作確認

【Contact Form 7】
□ プラグインインストール・有効化
□ フォーム構造確認
□ メール受け取り設定（kei@komasanshop.com）
□ 自動返信設定
□ reCAPTCHA 動作確認（有効化している場合）

【テスト】
□ テストメール送受信確認
□ 自動返信メール確認
□ フォーム送信エラーなし
□ レスポンシブ表示確認

【品質確認】
□ 日本語表示正常
□ リンク全て動作
□ CSS スタイル正常
□ ブラウザ互換性確認
```

---

## 🔗 参考ドキュメント

| ドキュメント | 内容 |
|-------------|------|
| **FOOTER_IMPLEMENTATION_GUIDE.md** | フッター詳細実装ガイド |
| **CONTACT_MAIL_CONFIG.md** | メール送信先設定詳細 |
| **CONTACT_FORM_IMPLEMENTATION_GUIDE.md** | Contact Form 7 詳細ガイド |
| **GOOGLE_CLOUD_RECAPTCHA_DETAILED_GUIDE.md** | reCAPTCHA v3 セットアップ |
| **wordpress-setup.sh** | 自動セットアップスクリプト（参考） |

---

## 📞 トラブルシューティング

### **フッターが表示されない**

```
原因: footer.php 修正ミス
解決:
  1. footer.php を確認
  2. HTML 構文エラーをチェック
  3. キャッシュをクリア
  4. ブラウザキャッシュをクリア
```

### **Contact Form が表示されない**

```
原因: プラグイン未インストール or お問い合わせページが存在しない
解決:
  1. Contact Form 7 インストール・有効化確認
  2. お問い合わせページが存在するか確認
  3. ショートコード [contact-form-7 id="..." title="..."] が設定されているか確認
```

### **メールが届かない**

```
原因: メール設定ミス or メールサーバー問題
解決:
  1. To アドレスが kei@komasanshop.com か確認
  2. Contact Form 7 メール設定を再度確認
  3. WordPress メール送信機能確認
  4. ホスティング会社にメール送信機能確認
```

---

## 📝 完了後の手順

1. **本番公開**
   - テスト完了後、公開リリース

2. **利用者通知**
   - お問い合わせフォームが動作開始したことを案内

3. **運用開始**
   - CEO がお問い合わせメール受け取り開始
   - 24時間以内返信体制開始

---

**作成日:** 2026-04-14  
**対象ブランチ:** claude/review-nagi-financial-shop-5xOxg  
**責任者:** CEO かんざき けい
