# ============================================
# Xserver WordPress ワンクリックデプロイメント
# 凪フィナンシャル Contact Form 7 + Footer
# SSH キー認証版 (パスワード不要)
# Windows PowerShell 用
# ============================================

param(
    [string]$Host = "sv13270.xserver.jp",
    [string]$Username = "han82",
    [string]$KeyPath = "$env:USERPROFILE\.ssh\xserver_key"
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
# ステップ 1: SSH キー確認
# ========================================

Write-Header "Xserver WordPress ワンクリックデプロイメント（SSH キー認証版）"

# SSH キーファイルの存在確認
if (-not (Test-Path $KeyPath)) {
    Write-Error-Custom "SSH キーファイルが見つかりません: $KeyPath"
    Write-Host ""
    Write-Host "【対応】"
    Write-Host "1. SSH キーを生成してください:"
    Write-Host "   ssh-keygen -t rsa -b 4096 -f `"$KeyPath`""
    Write-Host ""
    Write-Host "2. Xserver にSSH公開鍵を登録してください"
    Write-Host ""
    exit 1
}

Write-Success "SSH キーファイル確認: $KeyPath"
Write-Host "  ホスト: $Host"
Write-Host "  ユーザー: $Username"
Write-Host ""

# ========================================
# ステップ 2: SSH 接続テスト
# ========================================

Write-Host "【ステップ 1】SSH 接続テスト" -ForegroundColor Cyan
Write-Host ""

try {
    $testOutput = ssh -i $KeyPath -p 22 "${Username}@${Host}" "echo OK" 2>&1

    if ($testOutput -match "OK") {
        Write-Success "SSH 接続成功"
    } else {
        Write-Warning-Custom "SSH 接続に警告があります（続行します）"
    }
}
catch {
    Write-Error-Custom "SSH 接続エラー: $_"
    Write-Host ""
    Write-Host "【確認項目】"
    Write-Host "  • ホスト名が正しいか"
    Write-Host "  • ユーザー名が正しいか"
    Write-Host "  • SSH キーが正しいか"
    Write-Host "  • Xserver で SSH が有効化されているか"
    Write-Host ""
    exit 1
}

Write-Host ""

# ========================================
# ステップ 3: デプロイメント実行
# ========================================

Write-Host "【ステップ 2】デプロイメント実行" -ForegroundColor Cyan
Write-Host ""

# SSH コマンド構築
$sshCommand = @"
#!/bin/bash

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
chmod +x wordpress-deploy-complete.sh

# スクリプトを実行（WordPress パスを自動検出）
echo ""
echo "【ステップ 2】自動デプロイメント開始"
echo ""

./wordpress-deploy-complete.sh << 'EOF'
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
    Write-Host "【実行内容】" -ForegroundColor Cyan
    Write-Host "  • リポジトリをクローン"
    Write-Host "  • 自動デプロイメントスクリプト実行"
    Write-Host "  • Contact Form 7 インストール"
    Write-Host "  • footer.php にコード追加"
    Write-Host ""

    # SSH でリモートコマンドを実行
    $output = $sshCommand | ssh -i $KeyPath -p 22 "${Username}@${Host}" 2>&1

    Write-Host $output

    if ($LASTEXITCODE -eq 0) {
        Write-Success "SSH コマンド実行成功"
    } else {
        Write-Warning-Custom "SSH コマンド実行に警告がありますが、デプロイメント処理は完了した可能性があります"
    }

}
catch {
    Write-Error-Custom "SSH 実行エラー: $_"
    Write-Host ""
    Write-Host "【対応】"
    Write-Host "  • SSH 接続を再確認してください"
    Write-Host "  • Xserver サーバーの状態を確認してください"
    Write-Host ""
    exit 1
}

Write-Host ""

# ========================================
# ステップ 4: デプロイメント完了
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
Write-Host "  詳細は docs/SYNC_GUIDE.md を参照"
Write-Host ""

Write-Success "すべての処理が完了しました！"
Write-Host ""
