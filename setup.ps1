# X Post Generator Chrome拡張機能 自動インストールスクリプト
# Windows 10/11 対応

param(
  [switch]$RestartChrome = $false
)

function Write-Status {
  param([string]$Message, [ValidateSet("Info", "Success", "Warning", "Error")]$Type = "Info")
  $colors = @{
    Info    = "Cyan"
    Success = "Green"
    Warning = "Yellow"
    Error   = "Red"
  }
  Write-Host $Message -ForegroundColor $colors[$Type]
}

try {
  Write-Status "=== X Post Generator インストール開始 ===" "Info"

  # スクリプトディレクトリを取得
  $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
  $extensionDir = Join-Path $scriptDir "x-post-generator"

  if (-not (Test-Path $extensionDir)) {
    throw "x-post-generator フォルダが見つかりません: $extensionDir"
  }

  Write-Status "拡張機能フォルダを検出: $extensionDir" "Info"

  # Chrome Extensions フォルダを特定
  $chromeExtensionsPath = "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Extensions"

  if (-not (Test-Path $chromeExtensionsPath)) {
    throw "Chrome Extensions フォルダが見つかりません。Chrome がインストールされていることを確認してください。"
  }

  Write-Status "Chrome Extensions フォルダ: $chromeExtensionsPath" "Info"

  # manifest.json からバージョンを取得
  $manifestPath = Join-Path $extensionDir "manifest.json"
  $manifest = Get-Content $manifestPath | ConvertFrom-Json
  $version = $manifest.version
  $extensionName = $manifest.name

  Write-Status "拡張機能: $extensionName v$version" "Info"

  # 拡張機能ID を計算（ファイルパスのハッシュベース）
  # Chrome では、拡張フォルダ名をハッシュから計算
  # 簡易実装: フォルダ名 = 拡張ID にする
  $extensionId = "xpostgenerator"

  $installPath = Join-Path $chromeExtensionsPath $extensionId

  # インストール前に既存バージョンをバックアップ
  if (Test-Path $installPath) {
    $backupPath = "$installPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Write-Status "既存バージョンをバックアップ: $backupPath" "Warning"
    Move-Item -Path $installPath -Destination $backupPath -Force | Out-Null
  }

  # 拡張機能をコピー
  Write-Status "インストール中..." "Info"
  Copy-Item -Path $extensionDir -Destination $installPath -Recurse -Force | Out-Null

  Write-Status "✓ インストール完了: $installPath" "Success"

  # Chrome を再起動（オプション）
  if ($RestartChrome) {
    Write-Status "Chrome を再起動中..." "Info"
    Stop-Process -Name "chrome" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    Start-Process "chrome.exe"
    Write-Status "✓ Chrome を再起動しました" "Success"
  } else {
    Write-Status "Chrome を手動で再起動してください（F5キー、または Chrome 完全終了後に再度開く）" "Warning"
  }

  Write-Status "=== セットアップ完了 ===" "Success"
  Write-Status "chrome://extensions で 'X Post Generator' が表示されることを確認してください" "Info"

} catch {
  Write-Status "エラー: $_" "Error"
  Write-Status "トラブルシューティング:" "Warning"
  Write-Status "1. Chrome がインストールされているか確認してください" "Info"
  Write-Status "2. このスクリプトと x-post-generator フォルダが同じディレクトリにあることを確認してください" "Info"
  Write-Status "3. PowerShell 実行ポリシーを確認してください（Set-ExecutionPolicy RemoteSigned -Scope CurrentUser）" "Info"
  exit 1
}
