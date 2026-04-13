# 📋 WordPress デプロイメント 実行者向けガイド

**対象:** Cowork（実行者）  
**責任者:** CEO かんざき けい  
**実行方法:** WordPress 管理画面から直接デプロイ  
**所要時間:** 約 10 分

---

## 🎯 実行内容

```
【タスク】
WordPress 管理画面から以下を実行:

1️⃣ Contact Form 7 プラグインをインストール・有効化
2️⃣ footer.php にフッターコード追加
3️⃣ メール送受信テスト
4️⃣ 完了確認
```

---

## 📱 ログイン情報

**WordPress 管理画面:**
```
URL: https://www.komashikifx.site/wp-admin/

ユーザー名: [確認が必要]
パスワード: [確認が必要]

※ CEO かんざき けい に確認してください
```

---

## 📝 実行手順

### **ステップ 1️⃣: WordPress 管理画面にログイン**

1. ブラウザで以下にアクセス:
   ```
   https://www.komashikifx.site/wp-admin/
   ```

2. ユーザー名・パスワルで ログイン

3. **ダッシュボード** が表示される ✓

---

### **ステップ 2️⃣: Contact Form 7 をインストール・有効化**

1. 左メニュー → **プラグイン** → **新規追加**

2. 検索ボックスに以下を入力:
   ```
   Contact Form 7
   ```

3. **「Contact Form 7 by Takayuki Miyoshi」** を探す

4. **「インストール」** をクリック
   - インストール中...（少し待機）

5. **「有効化」** をクリック

6. **確認:**
   ```
   左メニュー → Contact Form 7
   「お問い合わせ」が表示されているか ✓
   ```

---

### **ステップ 3️⃣: footer.php にフッターコード追加**

1. 左メニュー → **外観** → **ファイルエディタ**

2. 右パネルのファイル一覧から **「footer.php」** を探す

3. **「footer.php」** をクリック

4. **ファイルの最後**（`</html>` の直前）に以下をコピー＆ペースト:

**[コード内容は下記参照]**

---

### **ステップ 4️⃣: メール設定確認**

1. 左メニュー → **Contact Form 7** → **Contact Forms**

2. **「お問い合わせ」** をクリック

3. **「メール」タブ** を開く

4. **以下を確認:**
   ```
   To: kei@komasanshop.com ← これが設定されているか
   ```

5. **メール設定が空白の場合:**
   - CONTACT_MAIL_CONFIG.md で手動設定
   - または CEO かんざき けい に確認

---

### **ステップ 5️⃣: テストメール送信**

1. サイトのお問い合わせページにアクセス:
   ```
   https://www.komashikifx.site/お問い合わせ/
   ```

2. 以下のテストデータを入力:
   ```
   名前: テスト 太郎
   メール: test@example.com
   件名: テスト お問い合わせ
   メッセージ: これはテストメールです
   ```

3. **「送信」** をクリック

4. **確認:**
   ```
   送信完了メッセージが表示される ✓
   ```

---

### **ステップ 6️⃣: メール受信確認**

**CEO かんざき けい が以下を確認:**

```
【受信メール】
メールアドレス: kei@komasanshop.com
件名: [新規お問い合わせ] テスト お問い合わせ
内容: テスト 太郎 からのメッセージ

状態: ✓ メール到着

【自動返信メール】
メールアドレス: test@example.com
件名: お問い合わせをお受けしました
内容: 24時間以内に返信する旨

状態: ✓ メール到着
```

---

## ✅ チェックリスト

### **実行前**
```
□ WordPress ログイン情報を確認
□ インターネット接続確認
□ ブラウザが最新版か確認
```

### **実行中**
```
□ Contact Form 7 インストール完了
□ footer.php にコード追加完了
□ メール設定確認完了
□ テストメール送信完了
```

### **実行後**
```
□ フッター表示確認済み
□ Contact Form 7 が有効化されている
□ メール受信確認済み
□ 自動返信メール確認済み
```

---

## 📄 footer.php に追加するコード

**以下をコピーして、footer.php の最後（`</html>` の直前）にペースト:**

```html
<!-- ===== Footer (Updated 2026-04-14) ===== -->
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

---

## ⚠️ トラブル対応

### **Contact Form 7 が見つからない**

```
対応: プラグイン一覧で「Contact Form 7」が有効化されているか確認
解決: もう一度インストール・有効化を実行
```

### **footer.php の追加に失敗**

```
対応: 
1. コード内の引用符（"）が正しいか確認
2. HTML 構文を確認
3. WordPress キャッシュをクリア
解決: CEO かんざき けい に報告
```

### **メールが届かない**

```
対応:
1. To: が kei@komasanshop.com に設定されているか確認
2. スパムフォルダを確認
解決: CONTACT_MAIL_CONFIG.md で手動設定
```

---

## 📞 完了報告

**実行完了後、以下を CEO かんざき けい に報告:**

```
✅ Contact Form 7 インストール・有効化完了
✅ footer.php にコード追加完了
✅ メール設定確認完了
✅ テストメール送受信確認済み
✅ フッター表示確認済み

実行者: [実行者名]
実行日時: [日付・時刻]
完了時刻: [所要時間]
```

---

## 🔗 参考資料

| ドキュメント | 内容 |
|------------|------|
| **CONTACT_MAIL_CONFIG.md** | メール設定詳細 |
| **FOOTER_IMPLEMENTATION_GUIDE.md** | フッター実装詳細 |
| **WORDPRESS_DEPLOYMENT_CHECKLIST.md** | 詳細チェックリスト |

---

**対象:** WordPress https://www.komashikifx.site/  
**責任者:** CEO かんざき けい  
**実行者:** Cowork  
**実行方法:** WordPress 管理画面  
**所要時間:** 約 10 分
