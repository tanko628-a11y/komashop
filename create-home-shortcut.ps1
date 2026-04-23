# ============================================
# デスクトップショートカット作成スクリプト
# 🏠 帰宅・同期スタート
# ============================================

param(
    [string]$ScriptPath = "$PSScriptRoot\home-sync-complete.ps1",
    [string]$DesktopPath = "$env:USERPROFILE\Desktop"
)

Write-Host "🏠 帰宅・同期スタート ショートカット作成" -ForegroundColor Cyan
Write-Host ""

# スクリプトパス確認
if (-not (Test-Path $ScriptPath)) {
    Write-Host "✗ スクリプトが見つかりません: $ScriptPath" -ForegroundColor Red
    exit 1
}

Write-Host "✓ スクリプト確認: $ScriptPath" -ForegroundColor Green

# ショートカット作成
$shortcutPath = Join-Path $DesktopPath "🏠 帰宅・同期スタート.lnk"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""
$shortcut.WorkingDirectory = Split-Path -Parent $ScriptPath
$shortcut.IconLocation = "$env:SystemRoot\System32\cmd.exe,0"
$shortcut.Description = "自宅に帰ったらこのボタンを押してください。WordPress デプロイ + Google Drive 同期が自動で完了します。"
$shortcut.Save()

Write-Host "✓ ショートカット作成完了: $shortcutPath" -ForegroundColor Green
Write-Host ""
Write-Host "使用方法:" -ForegroundColor Cyan
Write-Host "1. デスクトップの『🏠 帰宅・同期スタート』をダブルクリック" -ForegroundColor White
Write-Host "2. PowerShell が起動して自動実行を開始" -ForegroundColor White
Write-Host "3. 完了時に Windows 通知と Discord 通知が送信されます" -ForegroundColor White
Write-Host ""
