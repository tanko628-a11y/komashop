@echo off
REM Xserver WordPress ワンクリックデプロイメント - Windows バッチファイル
REM PowerShell スクリプト実行（SSH キー認証版）

cd /d "%~dp0"

REM PowerShell 実行ポリシー設定
powershell -ExecutionPolicy Bypass -File "%~dp0xserver-one-click-deploy-ssh-key.ps1"

pause
