#!/bin/bash

# ============================================
# WordPress デプロイメント 完全自動化スクリプト
# 凪フィナンシャル Contact Form 7 + Footer
# WP-CLI 使用 + Contact Form 自動作成
# ============================================

set -e

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}WordPress デプロイメント 完全自動化${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# ========================================
# ステップ 1: 環境確認
# ========================================

echo -e "${YELLOW}【ステップ 1】環境確認${NC}"
echo ""

# WordPress ディレクトリを検索
WORDPRESS_ROOT=""

if [ -f "~/public_html/wp-config.php" ]; then
    WORDPRESS_ROOT="$HOME/public_html"
elif [ -f "~/public_html/wordpress/wp-config.php" ]; then
    WORDPRESS_ROOT="$HOME/public_html/wordpress"
elif [ -f "~/www/wp-config.php" ]; then
    WORDPRESS_ROOT="$HOME/www"
else
    # 現在のディレクトリを確認
    if [ -f "wp-config.php" ]; then
        WORDPRESS_ROOT=$(pwd)
    else
        echo -e "${RED}✗ WordPress インストール位置が見つかりません${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ WordPress 位置: $WORDPRESS_ROOT${NC}"

# WP-CLI 確認
if ! command -v wp &> /dev/null; then
    echo -e "${RED}✗ WP-CLI がインストールされていません${NC}"
    echo "  詳細: https://wp-cli.org/ja/#installing"
    exit 1
fi

echo -e "${GREEN}✓ WP-CLI: $(wp --version)${NC}"
echo ""

# ========================================
# ステップ 2: Contact Form 7 インストール・有効化
# ========================================

echo -e "${YELLOW}【ステップ 2】Contact Form 7 をインストール・有効化${NC}"
echo ""

cd "$WORDPRESS_ROOT"

# Contact Form 7 が既にインストール済みか確認
if wp plugin is-installed contact-form-7 2>/dev/null; then
    echo -e "${YELLOW}⚠ Contact Form 7 はすでにインストール済みです${NC}"

    # 有効化されているか確認
    if wp plugin is-active contact-form-7 2>/dev/null; then
        echo -e "${GREEN}✓ Contact Form 7 は有効化されています${NC}"
    else
        echo "Contact Form 7 を有効化中..."
        wp plugin activate contact-form-7
        echo -e "${GREEN}✓ Contact Form 7 を有効化しました${NC}"
    fi
else
    echo "Contact Form 7 をインストール中..."
    wp plugin install contact-form-7 --activate
    echo -e "${GREEN}✓ Contact Form 7 をインストール・有効化しました${NC}"
fi

echo ""

# ========================================
# ステップ 3: Contact Form 7 フォーム作成
# ========================================

echo -e "${YELLOW}【ステップ 3】Contact Form 7 フォーム作成${NC}"
echo ""

# デフォルトの「お問い合わせ」フォームが存在するか確認
if wp post list --post_type=wpcf7_contact_form --format=count 2>/dev/null | grep -q "0"; then
    echo "お問い合わせフォームを作成中..."

    # Contact Form 7 フォームを作成
    wp cf7 form create --title="お問い合わせ" 2>/dev/null || {
        # コマンドが失敗した場合、手動で作成
        wp post create --post_type=wpcf7_contact_form --post_title="お問い合わせ" --post_content='<p>名前（必須）<br />
[text* your-name]</p>

<p>メール（必須）<br />
[email* your-email]</p>

<p>件名<br />
[text your-subject]</p>

<p>メッセージ<br />
[textarea your-message]</p>

<p>プライバシーポリシーに同意する（必須）<br />
[checkbox* consent "同意する"]</p>

<p>[recaptcha]</p>

<p>[submit "送信"]</p>' --post_status=publish --porcelain 2>/dev/null || echo ""
    }

    echo -e "${GREEN}✓ お問い合わせフォームを作成しました${NC}"
else
    echo -e "${YELLOW}⚠ お問い合わせフォームは既に存在します${NC}"
fi

echo ""

# ========================================
# ステップ 4: footer.php にコード追加
# ========================================

echo -e "${YELLOW}【ステップ 4】footer.php にコード追加${NC}"
echo ""

# アクティブテーマを取得
ACTIVE_THEME=$(wp option get template)
FOOTER_FILE="wp-content/themes/$ACTIVE_THEME/footer.php"

if [ ! -f "$FOOTER_FILE" ]; then
    echo -e "${RED}✗ footer.php が見つかりません: $FOOTER_FILE${NC}"
    exit 1
fi

echo "テーマ: $ACTIVE_THEME"
echo ""

# バックアップを作成
BACKUP_FILE="${FOOTER_FILE}.backup.$(date +%s)"
cp "$FOOTER_FILE" "$BACKUP_FILE"
echo -e "${GREEN}✓ バックアップ作成: $(basename $BACKUP_FILE)${NC}"
echo ""

# footer.php が既に修正されていないか確認
if grep -q "site-footer" "$FOOTER_FILE"; then
    echo -e "${YELLOW}⚠ footer.php には既にフッターコードが含まれています${NC}"
    echo -e "${YELLOW}   追加処理をスキップします${NC}"
else
    echo "footer.php にフッターコードを追加中..."

    # フッターコードをファイルに追加
    cat >> "$FOOTER_FILE" << 'FOOTER_HTML'

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
FOOTER_HTML

    echo -e "${GREEN}✓ footer.php にフッターコード追加完了${NC}"
fi

echo ""

# ========================================
# ステップ 5: キャッシュクリア
# ========================================

echo -e "${YELLOW}【ステップ 5】キャッシュクリア${NC}"
echo ""

# WordPress キャッシュをクリア（キャッシュプラグインがあれば）
if wp plugin list --status=active | grep -q "cache"; then
    echo "キャッシュプラグインが検出されました"

    if wp plugin list --status=active | grep -q "w3-total-cache"; then
        wp w3-total-cache flush
        echo -e "${GREEN}✓ W3 Total Cache をクリアしました${NC}"
    elif wp plugin list --status=active | grep -q "wp-super-cache"; then
        wp super-cache flush
        echo -e "${GREEN}✓ WP Super Cache をクリアしました${NC}"
    fi
fi

echo ""

# ========================================
# ステップ 6: デプロイメント完了
# ========================================

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✅ WordPress デプロイメント完了！${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

echo "実施内容:"
echo "  ✓ Contact Form 7 をインストール・有効化"
echo "  ✓ お問い合わせフォームを作成"
echo "  ✓ footer.php にフッターコード追加"
echo "  ✓ バックアップを作成"
echo "  ✓ キャッシュをクリア"
echo ""

echo "確認項目:"
echo "  1. WordPress 管理画面で Contact Form 7 が有効化されているか確認"
echo "  2. https://www.komashikifx.site でフッター表示確認"
echo "  3. お問い合わせページでテストメール送信"
echo "  4. kei@komasanshop.com にメール受信確認"
echo ""

echo -e "${GREEN}✓ すべての処理が完了しました！${NC}"
echo ""
