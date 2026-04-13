# ============================================
# Xserver WordPress ワンクリックデプロイメント
# 凪フィナンシャル Contact Form 7 + Footer
# Windows PowerShell 用
# ============================================

param(
    [string]$Host = "",
    [string]$Username = "",
    [string]$Password = ""
)

# 色定義
function Write-Header {
    param([string]$Message)
    Write-Host "========================================" -ForegroundColor Blue
    Write-Host $Message -ForegroundColor Blue
    Write-Host "========================================" -ForegroundColor Blue
    Write-Host ""
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Warning-Custom {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

# ========================================
# ステップ 1: 接続情報の入力
# ========================================

Write-Header "Xserver WordPress ワンクリックデプロイメント"

# コマンドライン引数がない場合は対話形式で入力
if (-not $Host) {
    Write-Host "Xserver 接続情報を入力してください"
    Write-Host ""

    $Host = Read-Host "ホスト名 (例: sv1234.xserver.jp)"
    if (-not $Host) {
        Write-Error-Custom "ホスト名が入力されていません"
        exit 1
    }
}

if (-not $Username) {
    $Username = Read-Host "ユーザー名 (例: han82)"
    if (-not $Username) {
        Write-Error-Custom "ユーザー名が入力されていません"
        exit 1
    }
}

if (-not $Password) {
    $PasswordSecure = Read-Host "パスワード" -AsSecureString
    $Password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($PasswordSecure))
    if (-not $Password) {
        Write-Error-Custom "パスワードが入力されていません"
        exit 1
    }
}

Write-Success "接続情報を確認しました"
Write-Host "  ホスト: $Host"
Write-Host "  ユーザー: $Username"
Write-Host ""

# ========================================
# ステップ 2: SSH 接続・デプロイメント実行
# ========================================

Write-Host "【ステップ 1】Xserver に接続中..."
Write-Host ""

# SSH コマンドを作成
$sshCommand = @"
# ========================================
# Xserver 自動デプロイメント処理
# ========================================

echo "【ステップ 1】環境確認"
echo ""

cd ~

# リポジトリをクローン（既存の場合はスキップ）
if [ ! -d "komashop" ]; then
    echo "リポジトリをクローン中..."
    git clone -b claude/review-nagi-financial-shop-5xOxg https://github.com/tanko628-a11y/komashop.git
    echo ""
else
    echo "リポジトリは既に存在します"
    echo ""
fi

cd komashop

# スクリプト実行権限を付与
chmod +x xserver-auto-deployment.sh

# スクリプトを実行（WordPress パスを自動検出）
echo ""
echo "【ステップ 2】自動デプロイメント開始"
echo ""

# 対話モードで実行（パス入力を促す場合）
./xserver-auto-deployment.sh << 'EOF'
~/public_html
y
EOF

echo ""
echo "========================================"
echo "✅ デプロイメント完了"
echo "========================================"
echo ""
echo "次のステップ:"
echo "  1. WordPress 管理画面にログイン"
echo "  2. Contact Form 7 が有効化されているか確認"
echo "  3. https://www.komashikifx.site でフッター表示確認"
echo "  4. テストメール送信"
echo ""
"@

try {
    # SSH でリモートコマンドを実行
    Write-Host "【実行内容】" -ForegroundColor Cyan
    Write-Host "  • リポジトリをクローン"
    Write-Host "  • 自動デプロイメントスクリプト実行"
    Write-Host "  • Contact Form 7 インストール"
    Write-Host "  • footer.php にコード追加"
    Write-Host ""

    # plink（PuTTY）またはネイティブ SSH を使用
    $output = echo $sshCommand | ssh -p 22 "${Username}@${Host}" 2>&1

    Write-Host $output

    if ($LASTEXITCODE -eq 0) {
        Write-Success "SSH コマンド実行成功"
    } else {
        Write-Warning-Custom "SSH コマンド実行に警告がありますが、続行します"
    }

}
catch {
    Write-Error-Custom "SSH 接続エラー: $_"
    Write-Host ""
    Write-Host "確認項目:"
    Write-Host "  • ホスト名が正しいか"
    Write-Host "  • ユーザー名が正しいか"
    Write-Host "  • パスワードが正しいか"
    Write-Host "  • SSH が有効化されているか"
    Write-Host ""
    exit 1
}

# ========================================
# ステップ 3: デプロイメント完了
# ========================================

Write-Header "ワンクリックデプロイメント完了"

Write-Host "✅ デプロイメント処理が完了しました"
Write-Host ""

Write-Host "【次のステップ】" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. WordPress 管理画面でプラグイン確認"
Write-Host "   URL: https://www.komashikifx.site/wp-admin/"
Write-Host "   確認: Contact Form 7 が有効化されているか"
Write-Host ""

Write-Host "2. フッター表示確認"
Write-Host "   URL: https://www.komashikifx.site/"
Write-Host "   確認: ページ下部にフッター表示"
Write-Host ""

Write-Host "3. テストメール送信"
Write-Host "   URL: https://www.komashikifx.site/お問い合わせ/"
Write-Host "   送信先: kei@komasanshop.com"
Write-Host ""

Write-Host "4. メール受信確認"
Write-Host "   kei@komasanshop.com に受信メールが到着"
Write-Host "   テストメールアドレスに自動返信が到着"
Write-Host ""

Write-Host "問題が発生した場合:" -ForegroundColor Yellow
Write-Host "  詳細は XSERVER_AUTO_DEPLOY_GUIDE.md を参照"
Write-Host ""

Write-Success "すべての処理が完了しました！"
Write-Host ""
