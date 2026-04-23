# ============================================
# デスクトップショートカット作成スクリプト
# 🚗 出発・同期実施
# ============================================

param(
    [string]$ScriptPath = "$PSScriptRoot\departure-sync.ps1",
    [string]$DesktopPath = "$env:USERPROFILE\Desktop"
)

Write-Host "🚗 出発・同期実施 ショートカット作成" -ForegroundColor Cyan
Write-Host ""

# スクリプトパス確認
if (-not (Test-Path $ScriptPath)) {
    Write-Host "✗ スクリプトが見つかりません: $ScriptPath" -ForegroundColor Red
    exit 1
}

Write-Host "✓ スクリプト確認: $ScriptPath" -ForegroundColor Green

# ショートカット作成
$shortcutPath = Join-Path $DesktopPath "🚗 出発・同期実施.lnk"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""
$shortcut.WorkingDirectory = Split-Path -Parent $ScriptPath
$shortcut.IconLocation = "$env:SystemRoot\System32\cmd.exe,1"
$shortcut.Description = "出発する前にこのボタンを押してください。Windows → Google Drive の全データ同期と Git プッシュが自動で完了します。"
$shortcut.Save()

Write-Host "✓ ショートカット作成完了: $shortcutPath" -ForegroundColor Green
Write-Host ""
Write-Host "使用方法:" -ForegroundColor Cyan
Write-Host "1. デスクトップの『🚗 出発・同期実施』をダブルクリック" -ForegroundColor White
Write-Host "2. PowerShell が起動して自動実行を開始" -ForegroundColor White
Write-Host "3. 完了時に Windows 通知が送信されます" -ForegroundColor White
Write-Host "4. ノート PC で Google Drive にアクセスして同期を確認" -ForegroundColor White
Write-Host ""
