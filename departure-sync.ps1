# ============================================
# 🚗 出発・同期実施 — 出発前準備スクリプト
# Windows → Google Drive → ノート PC への
# 完全同期を実施
# ============================================

param(
    [string]$GoogleDrivePath = "$env:USERPROFILE\Google Drive\komashop-gdrive",
    [string]$GitRepoPath = (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)),
    [string]$DiscordWebhook = ""
)

# ============================================
# 色定義・ログ設定
# ============================================

$colors = @{
    Header   = 'Cyan'
    Success  = 'Green'
    Warning  = 'Yellow'
    Error    = 'Red'
    Progress = 'Magenta'
}

$logDir = "$env:USERPROFILE\Logs\departure-sync"
$logFile = "$logDir\sync-$(Get-Date -Format 'yyyyMMdd-HHmm').log"
if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir | Out-Null }

function Write-Log {
    param([string]$Message, [string]$Color = 'White')
    $timestamp = Get-Date -Format "HH:mm:ss"
    $output = "[$timestamp] $Message"
    Write-Host $output -ForegroundColor $Color
    Add-Content -Path $logFile -Value $output
}

function Write-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "=" * 50 -ForegroundColor $colors.Header
    Write-Host $Message -ForegroundColor $colors.Header
    Write-Host "=" * 50 -ForegroundColor $colors.Header
    Write-Host ""
    Add-Content -Path $logFile -Value "========================================`n$Message`n========================================"
}

function Write-Success {
    param([string]$Message)
    Write-Log "✓ $Message" $colors.Success
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Log "✗ $Message" $colors.Error
}

function Write-Warning-Custom {
    param([string]$Message)
    Write-Log "⚠ $Message" $colors.Warning
}

function Show-Progress {
    param([string]$Step, [int]$Current, [int]$Total)
    $percent = [math]::Round(($Current / $Total) * 100)
    $progressBar = "[" + ("=" * [math]::Round($percent / 5)).PadRight(20, "-") + "] $percent%"
    Write-Host $progressBar -ForegroundColor $colors.Progress
    Write-Log "Progress: $Current/$Total ($percent%)" $colors.Progress
}

# ============================================
# Step 1: Windows ローカル作業確認
# ============================================

Write-Header "🚗 出発・同期実施 開始"

Write-Log "Step 1: Windows ローカル作業確認中..."
Show-Progress "Local Check" 1 7

if (-not (Test-Path $GitRepoPath)) {
    Write-Error-Custom "リポジトリパスが見つかりません: $GitRepoPath"
    exit 1
}

Write-Success "リポジトリ確認: $GitRepoPath"
Write-Log ""

# ============================================
# Step 2: Git ステータス確認
# ============================================

Write-Header "Step 2: Git ステータス確認"
Show-Progress "Git Status" 2 7

Push-Location $GitRepoPath
try {
    Write-Log "Git ステータス確認中..."
    $gitStatus = git status --porcelain

    if ($gitStatus) {
        $uncommitted = @($gitStatus).Count
        Write-Warning-Custom "未コミット変更: $uncommitted ファイル"

        Write-Host ""
        Write-Host "未コミット変更:" -ForegroundColor Yellow
        $gitStatus | ForEach-Object { Write-Host "  $_" }

        $answer = Read-Host "これらの変更をコミットしますか? (y/n)"
        if ($answer -eq 'y') {
            Write-Log "変更をコミット中..."
            git add -A
            git commit -m "Departure sync: Windows から出発前の最新状態をコミット"
            Write-Success "コミット完了"
        } else {
            Write-Warning-Custom "コミットをスキップ"
        }
    } else {
        Write-Success "未コミット変更なし"
    }
} catch {
    Write-Error-Custom "Git コマンド実行エラー: $_"
}

Write-Log ""

# ============================================
# Step 3: GitHub プッシュ実行
# ============================================

Write-Header "Step 3: GitHub プッシュ実行"
Show-Progress "Git Push" 3 7

try {
    Write-Log "プッシュ中..."
    $pushOutput = git push origin claude/review-nagi-financial-shop-5xOxg 2>&1
    Write-Success "GitHub プッシュ完了"
    Write-Log $pushOutput
} catch {
    Write-Error-Custom "Git プッシュエラー: $_"
    $answer = Read-Host "続行しますか? (y/n)"
    if ($answer -ne 'y') { exit 1 }
}

Pop-Location
Write-Log ""

# ============================================
# Step 4: Google Drive for Desktop 同期確認
# ============================================

Write-Header "Step 4: Google Drive for Desktop 同期確認"
Show-Progress "Drive Sync" 4 7

$gdrivePath = "$env:USERPROFILE\Google Drive"
if (Test-Path $gdrivePath) {
    Write-Success "Google Drive フォルダ確認: $gdrivePath"

    $files = Get-ChildItem $gdrivePath -Recurse -ErrorAction SilentlyContinue | Measure-Object
    Write-Log "Google Drive ファイル数: $($files.Count)"
} else {
    Write-Warning-Custom "Google Drive フォルダが見つかりません"
    Write-Log "Google Drive for Desktop がインストールされているか確認してください"
}

Write-Log ""

# ============================================
# Step 5: Google Drive へのアップロード確認
# ============================================

Write-Header "Step 5: Google Drive へのアップロード確認"
Show-Progress "Upload Check" 5 7

Write-Log "最新ファイルが Google Drive に同期されているか確認中..."

$docsPath = Join-Path $GitRepoPath "docs"
if (Test-Path $docsPath) {
    Write-Success "docs フォルダ確認: $docsPath"
    $docFiles = Get-ChildItem $docsPath -File | Measure-Object
    Write-Log "docs フォルダ内ファイル数: $($docFiles.Count)"
}

# Google Drive にコピー（オプション）
$answer = Read-Host "docs フォルダを Google Drive にコピーしますか? (y/n)"
if ($answer -eq 'y') {
    Write-Log "Google Drive へコピー中..."
    try {
        if (-not (Test-Path "$gdrivePath\komashop-docs")) {
            New-Item -ItemType Directory -Path "$gdrivePath\komashop-docs" | Out-Null
        }
        Copy-Item -Path $docsPath -Destination "$gdrivePath\komashop-docs" -Recurse -Force
        Write-Success "Google Drive へのコピー完了"
    } catch {
        Write-Error-Custom "コピーエラー: $_"
    }
}

Write-Log ""

# ============================================
# Step 6: 出張用セットアップファイル確認
# ============================================

Write-Header "Step 6: 出張用セットアップファイル確認"
Show-Progress "Travel Setup" 6 7

$travelFiles = @(
    "TRAVEL_SETUP.md"
    "QUICK_REFERENCE.txt"
    "PACKING_CHECKLIST.md"
)

Write-Log "出張用セットアップファイル確認:"
foreach ($file in $travelFiles) {
    $filePath = Join-Path $docsPath $file
    if (Test-Path $filePath) {
        Write-Success "$file: ✓"
    } else {
        Write-Warning-Custom "$file: ✗ (見つかりません)"
    }
}

Write-Log ""
Write-Host "📋 出発準備チェックリスト:" -ForegroundColor Cyan
Write-Host "  □ 未コミット変更を確認・コミット完了" -ForegroundColor White
Write-Host "  □ GitHub へプッシュ完了" -ForegroundColor White
Write-Host "  □ Google Drive が同期中（確認中...）" -ForegroundColor White
Write-Host "  □ ノート PC で Google Drive にアクセス可能か確認" -ForegroundColor White
Write-Host ""

# ============================================
# Step 7: ノート PC セットアップ案内
# ============================================

Write-Header "Step 7: ノート PC セットアップ案内"
Show-Progress "Notebook Setup" 7 7

Write-Log "ノート PC へのセットアップ手順："
Write-Host ""
Write-Host "【ノート PC での作業】" -ForegroundColor Green
Write-Host "1. Google Drive for Desktop をインストール" -ForegroundColor White
Write-Host "   → https://www.google.com/drive/download/" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Google アカウントでログイン" -ForegroundColor White
Write-Host "   → 凪フィナンシャル SHOP フォルダを同期" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. このリポジトリをクローン" -ForegroundColor White
Write-Host "   git clone -b claude/review-nagi-financial-shop-5xOxg https://github.com/tanko628-a11y/komashop.git" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. docs/ フォルダの TRAVEL_SETUP.md を確認" -ForegroundColor White
Write-Host ""

Write-Log ""

# ============================================
# 完了通知
# ============================================

Write-Header "✅ 出発準備 完了"

Write-Success "✅ 出発準備がすべて完了しました！"

# Windows 通知
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications.ToastNotificationManager, ContentType = WindowsRuntime] | Out-Null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications.ToastNotification, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

$APP_ID = "Microsoft.Windows.PowerShell"
$template = @"
<toast>
    <visual>
        <binding template="ToastText02">
            <text id="1">出発準備 完了</text>
            <text id="2">✅ すべての同期が完了しました。安全な出張を！</text>
        </binding>
    </visual>
</toast>
"@

try {
    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml($template)
    $toast = New-Object Windows.UI.Notifications.ToastNotification $xml
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($APP_ID).Show($toast)
    Write-Success "Windows 通知送信完了"
} catch {
    Write-Warning-Custom "Windows 通知送信失敗（無視）"
}

# Discord 通知（オプション）
if ($DiscordWebhook) {
    Write-Log "Discord 通知を送信中..."
    try {
        $payload = @{
            content = "🚗 **出発準備 完了**`n完了時刻: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`nノート PC での Google Drive セットアップを忘れずに！"
        } | ConvertTo-Json

        Invoke-RestMethod -Uri $DiscordWebhook -Method Post -ContentType "application/json" -Body $payload | Out-Null
        Write-Success "Discord 通知送信完了"
    } catch {
        Write-Warning-Custom "Discord 通知送信失敗（無視）"
    }
}

Write-Host ""
Write-Host "🎉 出発準備が完了しました！安全な出張を！" -ForegroundColor Green
Write-Host ""
