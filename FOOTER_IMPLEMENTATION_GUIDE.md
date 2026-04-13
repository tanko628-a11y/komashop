# 🔗 フッター実装ガイド
## 凪フィナンシャル ショップ フッター構築

**対象ページ:** https://www.komashikifx.site  
**実装日:** 2026-04-13  
**優先度:** 🔴 HIGH  
**責任者:** CEO かんざき けい  

---

## 📋 フッター構成

```
┌─────────────────────────────────────────────────┐
│                                                 │
│  凪フィナンシャル SHOP                          │
│  MT4対応トレーディングツール & データ分析      │
│                                                 │
├─────────────────────────────────────────────────┤
│                                                 │
│  About          Legal          Social           │
│  ・About        ・プライバシー  ・Facebook     │
│  ・メンバー     ・利用規約      ・Instagram    │
│  ・沿革         ・お問い合わせ  ・X            │
│                                                 │
├─────────────────────────────────────────────────┤
│ Designed with WordPress                        │
│ © 2026 凪フィナンシャル. All Rights Reserved.  │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## Step 1️⃣: フッター HTML コード

### WordPress テーマの footer.php に追加

**場所:** `wp-content/themes/[テーマ名]/footer.php`

```html
<!-- ===== Footer ===== -->
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
        <!-- 採用情報は削除（2026-04-13） -->
      </ul>
    </div>

    <!-- Legal Section -->
    <div class="footer-section">
      <h4 class="footer-title">Legal</h4>
      <ul class="footer-menu">
        <li><a href="/privacy/">プライバシー</a></li>
        <li><a href="/privacy-policy/">プライバシーポリシー</a></li>
        <li><a href="/terms/">利用規約</a></li>
        <li><a href="/contact/">お問い合わせ</a></li>
      </ul>
    </div>

    <!-- Social Section -->
    <div class="footer-section">
      <h4 class="footer-title">Social</h4>
      <div class="footer-social">
        <a href="https://facebook.com/komashikifx" target="_blank" rel="noopener" class="social-link">
          <svg class="social-icon" viewBox="0 0 24 24">
            <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
          </svg>
          Facebook
        </a>
        <a href="https://instagram.com/komashikifx" target="_blank" rel="noopener" class="social-link">
          <svg class="social-icon" viewBox="0 0 24 24">
            <path d="M12 0C8.74 0 8.333.015 7.053.072 5.775.132 4.905.333 4.117.6c-.588.147-1.079.35-1.57.742-.188.147-.36.295-.53.465-.17.17-.318.342-.465.53-.392.491-.594.982-.744 1.57-.266.788-.467 1.658-.527 2.936C.039 8.333.024 8.74 0 12s.015 3.667.072 4.947c.06 1.277.261 2.148.527 2.936.147.588.35 1.079.742 1.57.147.188.295.36.465.53.17.17.342.318.53.465.491.392.982.594 1.57.744.788.266 1.658.467 2.936.527C8.333 23.961 8.74 23.976 12 23.976s3.667-.015 4.947-.072c1.277-.06 2.148-.261 2.936-.527.588-.147 1.079-.35 1.57-.742.188-.147.36-.295.465-.53.17-.17.318-.342.465-.53.392-.491.594-.982.744-1.57.266-.788.467-1.658.527-2.936.058-1.28.072-1.687.072-4.947s-.015-3.667-.072-4.947c-.06-1.277-.261-2.148-.527-2.936-.147-.588-.35-1.079-.742-1.57-.147-.188-.295-.36-.465-.53-.17-.17-.342-.318-.53-.465-.491-.392-.982-.594-1.57-.744-.788-.266-1.658-.467-2.936-.527C15.667.039 15.26.024 12.001 0h-.001zm0 2.16c3.203 0 3.585.009 4.849.070 1.171.054 1.805.244 2.227.408.561.217.96.477 1.382.896.419.42.679.821.896 1.381.164.422.354 1.057.408 2.227.061 1.264.07 1.646.07 4.85s-.009 3.585-.07 4.849c-.054 1.171-.244 1.805-.408 2.227-.217.561-.477.96-.896 1.382-.42.419-.821.679-1.381.896-.422.164-1.057.354-2.227.408-1.264.061-1.646.07-4.85.07s-3.585-.009-4.849-.07c-1.171-.054-1.805-.244-2.227-.408-.561-.217-.96-.477-1.382-.896-.419-.42-.679-.821-.896-1.381-.164-.422-.354-1.057-.408-2.227-.061-1.264-.07-1.646-.07-4.849s.009-3.585.07-4.849c.054-1.171.244-1.805.408-2.227.217-.561.477-.96.896-1.382.42-.419.821-.679 1.381-.896.422-.164 1.057-.354 2.227-.408 1.264-.061 1.646-.07 4.849-.07z"/>
          </svg>
          Instagram
        </a>
        <a href="https://x.com/komashikifx" target="_blank" rel="noopener" class="social-link">
          <svg class="social-icon" viewBox="0 0 24 24">
            <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24h-6.514l-5.106-6.694-5.832 6.694H2.882l7.732-8.835L1.227 2.25h6.682l4.648 6.155 5.695-6.155zM17.15 18.75h1.828L5.857 3.957H3.873l13.277 14.793z"/>
          </svg>
          X
        </a>
      </div>
    </div>

  </div>

  <!-- Footer Bottom -->
  <div class="footer-bottom">
    <p class="footer-copyright">
      Designed with WordPress<br>
      © 2026 凪フィナンシャル. All Rights Reserved.
    </p>
  </div>

</footer>
<!-- ===== End Footer ===== -->
```

---

## Step 2️⃣: フッター CSS

### WordPress テーマのカスタム CSS に追加

**場所:** `外観` → `カスタマイズ` → `追加CSS`

```css
/* ===== Footer Styles ===== */

.site-footer {
  background: linear-gradient(135deg, #003366 0%, #001f3f 100%);
  color: #ffffff;
  padding: 60px 20px 30px;
  margin-top: 80px;
  font-family: 'Arial', 'Segoe UI', sans-serif;
}

/* Footer Content Grid */
.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 40px;
  margin-bottom: 40px;
}

/* Company Info Section */
.footer-info {
  grid-column: span 1;
}

.footer-brand {
  font-size: 24px;
  font-weight: bold;
  margin: 0 0 10px 0;
  color: #ffffff;
  line-height: 1.4;
}

.footer-tagline {
  font-size: 14px;
  color: #b3d9ff;
  margin: 0;
  line-height: 1.6;
  opacity: 0.9;
}

/* Section Titles */
.footer-title {
  font-size: 16px;
  font-weight: 600;
  margin: 0 0 15px 0;
  color: #ffffff;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

/* Footer Menu Links */
.footer-menu {
  list-style: none;
  padding: 0;
  margin: 0;
}

.footer-menu li {
  margin-bottom: 10px;
}

.footer-menu a {
  color: #b3d9ff;
  text-decoration: none;
  font-size: 14px;
  transition: color 0.3s ease;
  display: inline-block;
}

.footer-menu a:hover {
  color: #ffffff;
  text-decoration: underline;
}

/* Social Links */
.footer-social {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.social-link {
  display: flex;
  align-items: center;
  gap: 10px;
  color: #b3d9ff;
  text-decoration: none;
  font-size: 14px;
  transition: all 0.3s ease;
  padding: 8px;
  border-radius: 4px;
}

.social-link:hover {
  color: #ffffff;
  background: rgba(255, 255, 255, 0.1);
  padding-left: 16px;
}

.social-icon {
  width: 18px;
  height: 18px;
  fill: currentColor;
}

/* Footer Bottom */
.footer-bottom {
  border-top: 1px solid rgba(255, 255, 255, 0.2);
  padding-top: 30px;
  text-align: center;
  max-width: 1200px;
  margin: 0 auto;
}

.footer-copyright {
  font-size: 13px;
  color: #99b3cc;
  margin: 0;
  line-height: 1.8;
}

/* Responsive Design */
@media (max-width: 768px) {
  .site-footer {
    padding: 40px 20px 20px;
    margin-top: 60px;
  }

  .footer-content {
    grid-template-columns: 1fr;
    gap: 30px;
  }

  .footer-brand {
    font-size: 20px;
  }

  .footer-title {
    font-size: 14px;
  }

  .footer-menu a,
  .social-link {
    font-size: 13px;
  }

  .footer-copyright {
    font-size: 12px;
  }
}

@media (max-width: 480px) {
  .site-footer {
    padding: 30px 15px 15px;
    margin-top: 40px;
  }

  .footer-content {
    gap: 25px;
  }

  .footer-brand {
    font-size: 18px;
  }

  .footer-title {
    font-size: 13px;
  }

  .footer-menu a,
  .social-link {
    font-size: 12px;
  }
}
```

---

## Step 3️⃣: WordPress での実装

### 3-1: footer.php に追加する方法

```
【Option A: テーマファイルエディタを使用】

1. WordPress 管理画面
2. 外観 → テーマファイルエディタ
3. 右側で「footer.php」を探す
4. </footer> または </body> の前に
   上記の HTML コードを貼り付け
5. 「ファイルを更新」をクリック
```

```
【Option B: 子テーマを使用（推奨）】

1. 子テーマを作成 or 既存の子テーマを使用
2. 子テーマの footer.php を開く
3. HTML コードを貼り付け
4. ファイルを保存
```

### 3-2: CSS を適加

```
1. WordPress 管理画面
2. 外観 → カスタマイズ
3. 「追加 CSS」セクション
4. 上記の CSS コードを貼り付け
5. 「公開」をクリック
```

### 3-3: メニューリンクを設定

```
【About メニュー】
1. 外観 → メニュー
2. 「新規メニューを作成」（必要に応じて）
3. リンクを追加:
   ├─ /about/
   ├─ /members/
   ├─ /history/
   └─ /careers/

【Legal メニュー】
1. 同じメニューに追加:
   ├─ /privacy/
   ├─ /privacy-policy/
   ├─ /terms/
   └─ /contact/
```

### 3-4: SNS リンクを更新

```html
<!-- Facebook URL を更新 -->
<a href="https://facebook.com/komashikifx" ...>

<!-- Instagram URL を更新 -->
<a href="https://instagram.com/komashikifx" ...>

<!-- Twitter URL を更新 -->
<a href="https://twitter.com/komashikifx" ...>
```

---

## Step 4️⃣: 各ページの作成

### 必要なページ

```
✅ /about/ - 企業情報ページ
✅ /members/ - メンバーページ
✅ /history/ - 沿革ページ
✅ /careers/ - 採用情報ページ
✅ /privacy/ - プライバシーページ
✅ /privacy-policy/ - プライバシーポリシー
✅ /terms/ - 利用規約ページ
✅ /contact/ - お問い合わせ（既存）
```

**各ページの作成方法:**

```
WordPress 管理画面
→ 固定ページ
→ 新規追加
→ ページタイトル: 「About」
→ スラッグ:「about」
→ コンテンツを入力
→ 「公開」をクリック
```

---

## ✅ テスト手順

### テスト 1: フッター表示テスト（PC）

```
1. https://www.komashikifx.site/ にアクセス
2. ページを下にスクロール
3. フッターが表示されるか確認
4. 以下が見える確認:
   ✅ 「凪フィナンシャル SHOP」タイトル
   ✅ 「MT4対応トレーディングツール...」説明
   ✅ About セクション（4 個のリンク）
   ✅ Legal セクション（4 個のリンク）
   ✅ Social セクション（3 個のリンク）
   ✅ 著作権表記
```

### テスト 2: リンク動作テスト

```
1. About リンクをクリック → /about/ に遷移
2. メンバーリンクをクリック → /members/ に遷移
3. プライバシーリンクをクリック → /privacy/ に遷移
4. Facebook リンクをクリック → Facebook に遷移（新規タブ）
5. Instagram リンクをクリック → Instagram に遷移（新規タブ）
6. Twitter/X リンクをクリック → Twitter に遷移（新規タブ）
```

### テスト 3: モバイル表示テスト

```
1. モバイルブラウザで https://www.komashikifx.site/ にアクセス
2. ページを下にスクロール
3. フッターの表示確認:
   ✅ フッターが 1 列に切り替わっているか
   ✅ テキストが読みやすいサイズか
   ✅ リンクが押しやすいサイズ（最小 44px）か
   ✅ 横スクロール不要か
```

### テスト 4: スタイル確認テスト

```
1. フッター背景色が紺色（#003366）か
2. テキストが白色か
3. リンクホバー時に色が明るくなるか
4. Social リンク：アイコンが表示されているか
5. Responsive: タブレット・スマートフォンで正常に表示されるか
```

### テスト 5: ブラウザ互換性テスト

```
□ Chrome（最新版）
□ Safari（最新版）
□ Firefox（最新版）
□ Edge（最新版）
```

---

## 📋 実装完了チェックリスト

```
【HTML 実装】
□ footer.php に HTML コードを追加
□ すべてのセクションが含まれている
  ├─ Company Info
  ├─ About
  ├─ Legal
  ├─ Social
  └─ Copyright

【CSS 適用】
□ 外観 → カスタマイズ → 追加CSS に貼り付け
□ 「公開」をクリック
□ フッターが正しいスタイルで表示される

【メニュー設定】
□ About メニューリンクを設定（4 個）
□ Legal メニューリンクを設定（4 個）
□ リンク先が正しいか確認

【ページ作成】
□ /about/ ページを作成
□ /members/ ページを作成
□ /history/ ページを作成
□ /careers/ ページを作成
□ /privacy/ ページを作成
□ /privacy-policy/ ページを作成
□ /terms/ ページを作成
□ /contact/ ページを確認

【SNS リンク】
□ Facebook URL を正しい URL に更新
□ Instagram URL を正しい URL に更新
□ Twitter/X URL を正しい URL に更新
□ 新規タブで開くか確認（target="_blank"）

【テスト】
□ PC 表示で動作確認
□ モバイル表示で動作確認
□ すべてのリンクが機能
□ 複数ブラウザで動作確認
□ スタイルが正しく適用

【最終確認】
□ フッターが全ページで表示される
□ スマートフォンで問題なく表示
□ リンクが正しく機能
□ SNS リンクが新規タブで開く
□ エラーメッセージなし
```

---

## 🎨 カスタマイズオプション

### フッター背景色を変更

```css
/* 現在: 紺色（#003366） */
.site-footer {
  background: linear-gradient(135deg, #003366 0%, #001f3f 100%);
  /* または単色: */
  background: #003366;
}
```

### リンク色を変更

```css
/* 現在: 薄青（#b3d9ff） */
.footer-menu a {
  color: #b3d9ff;
}
```

### 社名を変更

```html
<h3 class="footer-brand">凪フィナンシャル SHOP</h3>
<!-- または -->
<h3 class="footer-brand">Nagi Financial Shop</h3>
```

---

## 📧 次のステップ

1. **フッター HTML を footer.php に追加**
2. **CSS を 「追加CSS」に貼り付け**
3. **メニューリンクを設定**
4. **各ページを作成**
5. **テストを実施**
6. **スクリーンショットを送信**

---

**実装者:** CEO かんざき けい  
**企業:** 凪フィナンシャル  
**完成予定:** 2026-04-13
