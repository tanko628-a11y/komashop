#!/bin/bash

# ============================================
# Xserver WordPress 自動デプロイメント スクリプト
# 凪フィナンシャル Contact Form 7 + Footer 自動化
# ============================================

set -e

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Xserver WordPress 自動デプロイメント${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# ========================================
# ステップ 1: 環境確認
# ========================================

echo -e "${YELLOW}【ステップ 1】環境確認${NC}"
echo ""

# WordPress ディレクトリを探す
echo "WordPress インストール位置を検索中..."

WORDPRESS_ROOT=""

# パターン 1: public_html/wordpress/
if [ -f "~/public_html/wordpress/wp-config.php" ]; then
    WORDPRESS_ROOT="$HOME/public_html/wordpress"
    echo -e "${GREEN}✓ 見つかりました: $WORDPRESS_ROOT${NC}"
# パターン 2: public_html/
elif [ -f "~/public_html/wp-config.php" ]; then
    WORDPRESS_ROOT="$HOME/public_html"
    echo -e "${GREEN}✓ 見つかりました: $WORDPRESS_ROOT${NC}"
# パターン 3: www/
elif [ -f "~/www/wp-config.php" ]; then
    WORDPRESS_ROOT="$HOME/www"
    echo -e "${GREEN}✓ 見つかりました: $WORDPRESS_ROOT${NC}"
else
    echo -e "${RED}✗ WordPress インストール位置が見つかりません${NC}"
    echo "  手動で入力してください:"
    read -p "  WordPress ルートパス (例: ~/public_html): " WORDPRESS_ROOT

    if [ ! -f "$WORDPRESS_ROOT/wp-config.php" ]; then
        echo -e "${RED}エラー: wp-config.php が見つかりません${NC}"
        exit 1
    fi
fi

echo ""

# ========================================
# ステップ 2: WP-CLI 確認
# ========================================

echo -e "${YELLOW}【ステップ 2】WP-CLI 確認${NC}"

if command -v wp &> /dev/null; then
    WP_CLI_VERSION=$(wp --version)
    echo -e "${GREEN}✓ WP-CLI がインストールされています: $WP_CLI_VERSION${NC}"
    HAS_WP_CLI=true
else
    echo -e "${YELLOW}⚠ WP-CLI が見つかりません${NC}"
    echo "  以下で確認できます: https://wp-cli.org/ja/#installing"
    HAS_WP_CLI=false
fi

echo ""

# ========================================
# ステップ 3: WordPress 確認
# ========================================

echo -e "${YELLOW}【ステップ 3】WordPress 確認${NC}"

if [ ! -f "$WORDPRESS_ROOT/wp-config.php" ]; then
    echo -e "${RED}✗ wp-config.php が見つかりません${NC}"
    exit 1
fi

WP_TITLE=$(grep "DB_NAME" "$WORDPRESS_ROOT/wp-config.php" | head -1)
echo -e "${GREEN}✓ WordPress インストール確認: $WORDPRESS_ROOT${NC}"
echo "  $WP_TITLE"

echo ""

# ========================================
# ステップ 4: 権限確認
# ========================================

echo -e "${YELLOW}【ステップ 4】ファイル権限確認${NC}"

if [ -w "$WORDPRESS_ROOT/wp-content/themes" ]; then
    echo -e "${GREEN}✓ wp-content/themes に書き込み権限あり${NC}"
    HAS_WRITE_PERMISSION=true
else
    echo -e "${RED}✗ wp-content/themes に書き込み権限なし${NC}"
    HAS_WRITE_PERMISSION=false
fi

if [ -w "$WORDPRESS_ROOT/wp-content/plugins" ]; then
    echo -e "${GREEN}✓ wp-content/plugins に書き込み権限あり${NC}"
else
    echo -e "${RED}✗ wp-content/plugins に書き込み権限なし${NC}"
    HAS_WRITE_PERMISSION=false
fi

echo ""

# ========================================
# ステップ 5: 環境判定
# ========================================

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}環境判定結果${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

if [ "$HAS_WP_CLI" = true ] && [ "$HAS_WRITE_PERMISSION" = true ]; then
    echo -e "${GREEN}✅ フル自動化可能！${NC}"
    echo ""
    echo "推奨方法: WP-CLI 自動デプロイメント"
    echo ""
    read -p "自動デプロイメントを実行しますか？ (y/n): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # ========================================
        # 自動デプロイメント実行
        # ========================================

        echo ""
        echo -e "${YELLOW}【デプロイメント開始】${NC}"
        echo ""

        cd "$WORDPRESS_ROOT"

        # Contact Form 7 プラグイン インストール・有効化
        echo "Contact Form 7 をインストール中..."
        if wp plugin is-installed contact-form-7 2>/dev/null; then
            echo -e "${YELLOW}⚠ Contact Form 7 はすでにインストール済みです${NC}"
        else
            wp plugin install contact-form-7 --activate
            echo -e "${GREEN}✓ Contact Form 7 をインストール・有効化しました${NC}"
        fi

        echo ""

        # フッター実装（footer.php に追加）
        ACTIVE_THEME=$(wp option get template)
        FOOTER_FILE="wp-content/themes/$ACTIVE_THEME/footer.php"

        if [ ! -f "$FOOTER_FILE" ]; then
            echo -e "${RED}✗ footer.php が見つかりません: $FOOTER_FILE${NC}"
            exit 1
        fi

        # バックアップ作成
        BACKUP_FILE="${FOOTER_FILE}.backup.$(date +%s)"
        cp "$FOOTER_FILE" "$BACKUP_FILE"
        echo -e "${GREEN}✓ バックアップ作成: $BACKUP_FILE${NC}"

        # フッターコード追加（既に追加されていない場合）
        if ! grep -q "site-footer" "$FOOTER_FILE"; then
            echo "footer.php にフッターコードを追加中..."

            # フッターコード追加
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

            echo -e "${GREEN}✓ footer.php にフッターコード追加しました${NC}"
        else
            echo -e "${YELLOW}⚠ footer.php には既にフッターコードが含まれています${NC}"
        fi

        echo ""

        # ========================================
        # デプロイメント完了
        # ========================================

        echo -e "${GREEN}========================================${NC}"
        echo -e "${GREEN}✅ デプロイメント完了！${NC}"
        echo -e "${GREEN}========================================${NC}"
        echo ""

        echo "実施内容:"
        echo "  ✓ Contact Form 7 をインストール・有効化"
        echo "  ✓ footer.php にフッターコード追加"
        echo "  ✓ バックアップを作成"
        echo ""

        echo "次のステップ:"
        echo "  1. WordPress 管理画面にログイン"
        echo "  2. Contact Form 7 → 「お問い合わせ」をクリック"
        echo "  3. 「メール」タブでメール設定確認"
        echo "  4. kei@komasanshop.com が受信先か確認"
        echo "  5. テストメール送信"
        echo ""

    fi

elif [ "$HAS_WP_CLI" = true ]; then
    echo -e "${YELLOW}⚠️ 部分自動化可能${NC}"
    echo ""
    echo "WP-CLI は利用可能ですが、ファイル書き込み権限がありません。"
    echo ""
    echo "以下のみ自動化できます:"
    echo "  • Contact Form 7 プラグインのインストール・有効化"
    echo ""
    echo "手動対応が必要:"
    echo "  • footer.php にフッターコード追加"

else
    echo -e "${RED}✗ 完全自動化はできません${NC}"
    echo ""
    echo "対応方法:"
    echo "  1. Xserver サーバーパネル → SSH設定 を確認"
    echo "  2. WP-CLI インストールを確認"
    echo "  3. WordPress 管理画面から手動デプロイ"
    echo ""
    echo "参考: QUICK_DEPLOYMENT_GUIDE.md"
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo "スクリプト終了"
echo -e "${BLUE}========================================${NC}"
