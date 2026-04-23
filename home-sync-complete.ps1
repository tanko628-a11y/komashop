# ============================================
# 🏠 帰宅・同期スタート — 完全自動化スクリプト
# 自宅に帰ったらボタンを押すだけで
# WordPress デプロイ + Google Drive 同期が完了
# ============================================

param(
    [string]$Host = "sv13270.xserver.jp",
    [string]$Username = "han82",
    [string]$KeyPath = "$env:USERPROFILE\.ssh\xserver_key",
    [string]$DiscordWebhook = "",
    [switch]$SkipDeployment,
    [switch]$SkipSync
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

$logDir = "$env:USERPROFILE\Logs\home-sync"
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
# Step 1: 環境チェック
# ============================================

Write-Header "🏠 帰宅・同期スタート 開始"

Write-Log "Step 1: 環境チェック中..."
Show-Progress "Environment Check" 1 8

# SSH キー確認
if (-not (Test-Path $KeyPath)) {
    Write-Warning-Custom "SSH キーが見つかりません: $KeyPath"
    $answer = Read-Host "SSH キーを生成しますか? (y/n)"
    if ($answer -eq 'y') {
        Write-Log "SSH キー生成中..."
        ssh-keygen -t rsa -b 4096 -f $KeyPath -N "" | Out-Null
        Write-Success "SSH キー生成完了"
    } else {
        Write-Error-Custom "SSH キーが必要です。中止します。"
        exit 1
    }
}
Write-Success "SSH キー確認完了: $KeyPath"

# Xserver 接続テスト
Write-Log "Xserver への接続テスト中..."
try {
    $testOutput = ssh -i $KeyPath -p 22 "${Username}@${Host}" "echo OK" 2>&1
    if ($testOutput -match "OK") {
        Write-Success "Xserver 接続確認: OK"
    } else {
        throw "Xserver 接続失敗"
    }
} catch {
    Write-Error-Custom "Xserver への接続テスト失敗"
    $skipDeploy = Read-Host "デプロイメントをスキップして次に進みますか? (y/n)"
    if ($skipDeploy -ne 'y') { exit 1 }
}

Write-Log ""

# ============================================
# Step 2: WordPress デプロイメント実行
# ============================================

if (-not $SkipDeployment) {
    Write-Header "Step 2: WordPress デプロイメント実行"
    Show-Progress "WordPress Deployment" 2 8

    $repoDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
    $batFile = Join-Path $repoDir "xserver-auto-deploy.bat"

    if (Test-Path $batFile) {
        Write-Log "デプロイメント実行: $batFile"
        & $batFile
        Write-Success "WordPress デプロイメント完了"
    } else {
        Write-Error-Custom "xserver-auto-deploy.bat が見つかりません: $batFile"
        $skipDeploy = Read-Host "デプロイメントをスキップして次に進みますか? (y/n)"
        if ($skipDeploy -ne 'y') { exit 1 }
    }
} else {
    Write-Header "Step 2: デプロイメント スキップ"
    Show-Progress "WordPress Deployment" 2 8
    Write-Log "デプロイメントはスキップされました"
}

Write-Log ""

# ============================================
# Step 3: デプロイメント検証
# ============================================

Write-Header "Step 3: デプロイメント検証"
Show-Progress "Verification" 3 8

Write-Log "WordPress 環境を確認中..."
try {
    $wpCheck = ssh -i $KeyPath -p 22 "${Username}@${Host}" "cd ~/public_html && wp core is-installed && echo 'WordPress OK'" 2>&1
    if ($wpCheck -match "WordPress OK") {
        Write-Success "WordPress インストール確認: OK"
    } else {
        Write-Warning-Custom "WordPress の確認が取れません"
    }
} catch {
    Write-Warning-Custom "WordPress 確認スキップ"
}

Write-Log ""

# ============================================
# Step 4: rclone 認証確認
# ============================================

Write-Header "Step 4: rclone Google Drive 認証確認"
Show-Progress "rclone Configuration" 4 8

# rclone インストール確認
Write-Log "rclone インストール確認中..."
$rcloneCheck = rclone version 2>$null
if ($rcloneCheck) {
    Write-Success "rclone インストール確認: $(($rcloneCheck | Select-Object -First 1) -replace 'rclone ', '')"
} else {
    Write-Error-Custom "rclone がインストールされていません"
    $answer = Read-Host "インストールしますか? (y/n)"
    if ($answer -eq 'y') {
        Write-Log "Windows 版 rclone インストール: choco install rclone"
        Write-Log "詳細は https://rclone.org/install/ を参照してください"
    }
}

# Google Drive リモート確認
Write-Log "Google Drive リモート確認中..."
$rcloneConfig = rclone config show komashop-gdrive 2>$null
if ($rcloneConfig) {
    Write-Success "Google Drive リモート確認: komashop-gdrive"
} else {
    Write-Warning-Custom "Google Drive リモートが未設定です"
    $answer = Read-Host "ブラウザで認証を開始しますか? (y/n)"
    if ($answer -eq 'y') {
        Write-Log "rclone config で Google Drive 認証を完了してください..."
        Write-Log "実行: rclone config"
        rclone config
    }
}

Write-Log ""

# ============================================
# Step 5: cron スケジュール確認（Linux 側で設定）
# ============================================

Write-Header "Step 5: cron スケジュール確認"
Show-Progress "Cron Configuration" 5 8

Write-Log "cron スケジュール確認中 (Linux 側)..."
try {
    $cronCheck = ssh -i $KeyPath -p 22 "${Username}@${Host}" "crontab -l | grep google-drive-sync" 2>&1
    if ($cronCheck) {
        Write-Success "cron スケジュール設定確認: OK"
    } else {
        Write-Warning-Custom "cron スケジュールが未設定の可能性があります"
        Write-Log "帰宅後に docs/SETUP_RCLONE_CRON.md の Step 3 を実行してください"
    }
} catch {
    Write-Warning-Custom "cron スケジュール確認スキップ"
}

Write-Log ""

# ============================================
# Step 6: Google Drive 同期実行
# ============================================

if (-not $SkipSync) {
    Write-Header "Step 6: Google Drive 同期実行"
    Show-Progress "Google Drive Sync" 6 8

    Write-Log "Google Drive → ローカル同期中..."
    try {
        rclone sync komashop-gdrive:"凪フィナンシャル SHOP" "$env:USERPROFILE\Google Drive\komashop-gdrive" -v --log-file="$logDir\rclone-sync.log"
        Write-Success "Google Drive 同期完了"
    } catch {
        Write-Error-Custom "Google Drive 同期エラー: $_"
        $skipSync = Read-Host "同期をスキップして続行しますか? (y/n)"
        if ($skipSync -ne 'y') { exit 1 }
    }
} else {
    Write-Header "Step 6: Google Drive 同期 スキップ"
    Show-Progress "Google Drive Sync" 6 8
    Write-Log "Google Drive 同期はスキップされました"
}

Write-Log ""

# ============================================
# Step 7: ログ記録
# ============================================

Write-Header "Step 7: ログ記録"
Show-Progress "Logging" 7 8

Write-Success "ログファイル: $logFile"
Add-Content -Path $logFile -Value "`n完了時刻: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n"

Write-Log ""

# ============================================
# Step 8: 完了通知
# ============================================

Write-Header "Step 8: 完了通知"
Show-Progress "Completion Notification" 8 8

Write-Success "✅ 帰宅・同期スタート 完了！"

# Windows 通知
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications.ToastNotificationManager, ContentType = WindowsRuntime] | Out-Null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications.ToastNotification, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

$APP_ID = "Microsoft.Windows.PowerShell"
$template = @"
<toast>
    <visual>
        <binding template="ToastText02">
            <text id="1">帰宅・同期スタート 完了</text>
            <text id="2">✅ すべてのプロセスが完了しました。$(Get-Date -Format 'HH:mm')</text>
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
            content = "✅ **帰宅・同期スタート 完了**`n完了時刻: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`nログ: $logFile"
        } | ConvertTo-Json

        Invoke-RestMethod -Uri $DiscordWebhook -Method Post -ContentType "application/json" -Body $payload | Out-Null
        Write-Success "Discord 通知送信完了"
    } catch {
        Write-Warning-Custom "Discord 通知送信失敗（無視）"
    }
}

Write-Log ""
Write-Host "ログファイル: $logFile" -ForegroundColor $colors.Success
Write-Host ""
Write-Host "🎉 すべてのプロセスが完了しました！" -ForegroundColor $colors.Success
Write-Host ""

# ============================================
# クリーンアップ
# ============================================

Write-Log "プロセス終了: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
