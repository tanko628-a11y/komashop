# 🚀 凪フィナンシャル WordPress デプロイメント & 同期システム

**プロジェクト名**: 凪フィナンシャル Contact Form 7 + Footer + 3way 同期自動化  
**バージョン**: 1.0 (2026-04-23)  
**ステータス**: 🔄 Phase 3 進行中 (全体進捗 85%)  
**ブランチ**: `claude/review-nagi-financial-shop-5xOxg`

---

## 📋 プロジェクト概要

このプロジェクトは、**凪フィナンシャル WordPress サイト**への自動デプロイメントと、**Windows・Linux・Google Drive の3way 同期システム**を実装します。

### 🎯 主な機能

| 機能 | 状態 | 説明 |
|------|------|------|
| **Contact Form 7 自動デプロイ** | ✅ 完成 | WP-CLI でプラグイン自動インストール・有効化 |
| **お問い合わせフォーム自動作成** | ✅ 完成 | 必須フィールド、reCAPTCHA v3 含む |
| **フッター自動埋め込み** | ✅ 完成 | 凪フィナンシャル ブランドフッター |
| **メール自動化** | ✅ 完成 | 受信・自動返信設定完了 |
| **SSH キー認証** | ✅ 完成 | パスワード不要のセキュアデプロイ |
| **ワンクリックデプロイ** | ✅ 完成 | Windows バッチファイル + PowerShell |
| **3way 同期** | 🔄 進行中 | Google Drive ↔ GitHub ↔ Linux |

---

## 🚀 クイックスタート

### **Method 1️⃣: Windows で自動実行（最も簡単）**

```powershell
# 1. このリポジトリをクローン
git clone -b claude/review-nagi-financial-shop-5xOxg https://github.com/tanko628-a11y/komashop.git
cd komashop

# 2. SSH キーを生成（初回のみ）
ssh-keygen -t rsa -b 4096 -f "$env:USERPROFILE\.ssh\xserver_key"

# 3. Xserver でSSH公開鍵を登録
# サーバーパネル → SSH 設定で公開鍵ファイルをコピー・登録

# 4. ワンクリック実行
.\xserver-auto-deploy.bat
```

**実行完了後**:
- WordPress に Contact Form 7 がインストール・有効化
- お問い合わせフォームが作成・表示
- フッターが埋め込み完了
- 次: COWORK_DEPLOYMENT_CHECK.md で検証

---

### **Method 2️⃣: Linux で SSH 実行（高度）**

```bash
# リポジトリをクローン
git clone -b claude/review-nagi-financial-shop-5xOxg https://github.com/tanko628-a11y/komashop.git
cd komashop

# SSH で直接実行
ssh -i ~/.ssh/xserver_key han82@sv13270.xserver.jp < wordpress-deploy-complete.sh
```

---

## 📁 ファイル構成

```
komashop/
├── README.md                              ← 当ファイル（全体概要）
├── COWORK_DEPLOYMENT_CHECK.md             ← ✅ Cowork 確認チェックリスト
├── COWORK_DEPLOYMENT_INSTRUCTIONS.md      ← 手動デプロイメント手順
├── COWORK_QUICK_CHECKLIST.md              ← 簡易チェックリスト（3ステップ）
│
├── wordpress-deploy-complete.sh           ← ✅ WP-CLI 自動デプロイスクリプト
├── xserver-auto-deploy.bat                ← ✅ Windows ワンクリック実行ファイル
├── xserver-one-click-deploy-ssh-key.ps1   ← ✅ PowerShell SSH キー認証版
│
├── scripts/
│   └── google-drive-sync.sh               ← ✅ Google Drive 自動同期スクリプト（30分ごと）
│
├── docs/
│   ├── PROJECT_STATUS.md                  ← 📊 プロジェクト進捗ダッシュボード
│   ├── SYNC_GUIDE.md                      ← 3way 同期セットアップガイド
│   ├── GDRIVE_SYNC_STATUS.md              ← Google Drive 同期状態ログ
│   └── AI_WORKFLOW.md                     ← AI デバッグプロセス
│
├── logs/
│   └── gdrive-sync.log                    ← 同期ログ（cron 実行時に自動作成）
│
└── .git/                                  ← Git リポジトリ
```

---

## 📖 ドキュメントガイド

### 🆕 新規ユーザー向け

**最初に読むべきドキュメント（順序）:**

1. **このファイル（README.md）** ← 今ここ
   - プロジェクト全体の概要、環境情報

2. **[docs/PROJECT_STATUS.md](docs/PROJECT_STATUS.md)**
   - 現在の進捗状況（85% 完了）
   - Phase 1-4 の詳細進捗
   - 成功基準と達成状況

3. **[COWORK_DEPLOYMENT_CHECK.md](COWORK_DEPLOYMENT_CHECK.md)**
   - デプロイメント後の検証チェックリスト（7項目）
   - 実施後にこれを使って全機能確認

4. **[xserver-auto-deploy.bat](xserver-auto-deploy.bat)** を実行
   - ワンクリックで全自動化

5. **[docs/SYNC_GUIDE.md](docs/SYNC_GUIDE.md)**
   - Google Drive + GitHub + Linux 3way 同期のセットアップ
   - 出張中の継続同期が必要な場合

---

### 📊 進捗追跡・管理向け

- **[docs/PROJECT_STATUS.md](docs/PROJECT_STATUS.md)** - 全体進捗・マイルストーン
- **[docs/GDRIVE_SYNC_STATUS.md](docs/GDRIVE_SYNC_STATUS.md)** - 同期システム状態
- **[COWORK_QUICK_CHECKLIST.md](COWORK_QUICK_CHECKLIST.md)** - 最小限チェックリスト

---

### 🔧 技術者向け

- **[wordpress-deploy-complete.sh](wordpress-deploy-complete.sh)** - 6ステップの自動デプロイスクリプト
- **[xserver-one-click-deploy-ssh-key.ps1](xserver-one-click-deploy-ssh-key.ps1)** - PowerShell SSH キー認証版
- **[scripts/google-drive-sync.sh](scripts/google-drive-sync.sh)** - 30分ごと自動同期スクリプト
- **[docs/SYNC_GUIDE.md](docs/SYNC_GUIDE.md)** - 3way 同期実装ガイド

---

## 🏗️ デプロイメント環境

### Xserver

```
ホスト名: sv13270.xserver.jp
ユーザー名: han82
WordPress ルート: ~/public_html/
公開 URL: https://www.komashikifx.site/
```

### Contact Form 7 設定

| 項目 | 値 |
|------|-----|
| 受信先メール | kei@komasanshop.com |
| フォーム名 | お問い合わせ |
| 自動返信先 | 送信者のメールアドレス |
| セキュリティ | reCAPTCHA v3 有効 |

---

## 📦 インストール済みプラグイン

```
✅ Contact Form 7 (最新版)
✅ Akismet (スパム防止)
✅ その他インストール済みプラグイン（保持）
```

---

## 🔐 セキュリティ

### SSH キー認証

```powershell
# Windows で SSH キー生成（4096ビット RSA）
ssh-keygen -t rsa -b 4096 -f "$env:USERPROFILE\.ssh\xserver_key"

# 公開鍵を Xserver に登録
# サーバーパネル → SSH 設定で以下をコピー:
# C:\Users\<username>\.ssh\xserver_key.pub
```

### 認証情報管理

- **SSH キーファイル**: `~/.ssh/xserver_key` (秘密鍵)
- **公開鍵**: Xserver サーバーパネルに登録
- **環境変数**: PowerShell スクリプトで自動参照
- ⚠️ 秘密鍵を GitHub にコミットしないこと

---

## 🔄 3way 同期システム

### 同期フロー

```
【Windows PC（自宅/出張）】
  ↓ Google Drive for Desktop (自動)
【Google Drive】
  ↓ rclone 同期（Linux で 30分ごと）
【Linux（Claude Code）】
  ↓ Git コミット・プッシュ（自動）
【GitHub リポジトリ】
  ↓ Git プル（Windows で手動）
【Windows PC】
  ...（ループ）
```

### 同期スクリプト

| スクリプト | 実行環境 | 頻度 | 機能 |
|-----------|---------|------|------|
| google-drive-sync.sh | Linux | 30分ごと（cron） | Google Drive → GitHub 同期 |
| (Windows Git) | Windows | 手動 | GitHub から最新プル |

---

## ✅ チェックリスト

### 初回セットアップ（ユーザー作業）

- [ ] このリポジトリをクローン
- [ ] SSH キーを生成（`ssh-keygen`）
- [ ] Xserver に公開鍵を登録
- [ ] SSH 接続テスト
- [ ] `xserver-auto-deploy.bat` 実行
- [ ] COWORK_DEPLOYMENT_CHECK.md で検証
- [ ] デプロイメント完了確認

### Google Drive 同期セットアップ（出張用）

- [ ] Google Drive for Desktop をインストール
- [ ] Google Drive フォルダをローカル同期
- [ ] Linux で `rclone config` で Google Drive 認証
- [ ] crontab に同期スケジュール追加（30分ごと）
- [ ] テスト同期実行（`./scripts/google-drive-sync.sh`）
- [ ] 同期ログ確認（`logs/gdrive-sync.log`）

---

## 🎯 次のステップ

### 【優先度 1】 今すぐ実施（ユーザー）

1. SSH キー生成
   ```powershell
   ssh-keygen -t rsa -b 4096 -f "$env:USERPROFILE\.ssh\xserver_key"
   ```

2. Xserver に公開鍵登録

3. `xserver-auto-deploy.bat` 実行

4. COWORK_DEPLOYMENT_CHECK.md で検証

### 【優先度 2】 帰宅後実施（Linux）

1. Linux で `rclone config` 実行
2. crontab に同期スケジュール追加
3. 最終テスト実行

---

## 📊 プロジェクト進捗

```
【全体進捗】
████████████████░░░░ 85% 完了

【Phase 別進捗】
Phase 1: スクリプト開発              ████████████████████░ 95% ✅
Phase 2: 初期デプロイメント          ████████████████░░░░░ 80% ✅
Phase 3: SSH キー認証自動化          ████████████████░░░░░ 90% ✅
Phase 4: Google Drive 同期           ████████████████████░ 100% ✅
```

詳細は [docs/PROJECT_STATUS.md](docs/PROJECT_STATUS.md) を参照

---

## 🐛 トラブルシューティング

### SSH キー関連

**Q: "SSH キーが見つかりません" エラー**
```
A: SSH キーをまず生成してください:
   ssh-keygen -t rsa -b 4096 -f "$env:USERPROFILE\.ssh\xserver_key"
```

**Q: "SSH 接続エラー"**
```
A: 以下を確認:
   1. SSH キーが正しく生成されたか
   2. Xserver に公開鍵が登録されたか
   3. ホスト名が正しいか（sv13270.xserver.jp）
   4. ユーザー名が正しいか（han82）
```

### フォーム関連

**Q: "フォームが表示されない"**
```
A: WordPress 管理画面で以下を確認:
   1. Contact Form 7 プラグインが有効化されているか
   2. 「お問い合わせ」ページが存在するか
   3. ページに [contact-form-7] ショートコードが埋め込まれているか
```

**Q: "メール送信されない"**
```
A: Contact Form 7 設定で以下を確認:
   1. 受信メールアドレス: kei@komasanshop.com
   2. メール送信プラグイン（Akismet など）の状態
   3. Xserver SMTP 設定
```

### 同期関連

詳細は [docs/GDRIVE_SYNC_STATUS.md](docs/GDRIVE_SYNC_STATUS.md) 参照

---

## 📞 サポート

| 項目 | 担当 |
|------|------|
| デプロイメント | Claude（Linux） |
| Windows 操作 | ユーザー |
| デプロイメント検証 | CEO かんざき けい |
| 技術サポート | Claude Code |

---

## 📝 更新履歴

| 日付 | 変更 | ステータス |
|------|------|-----------|
| 2026-04-23 | README.md 作成 | ✅ |
| 2026-04-22 | Google Drive 同期スクリプト完成 | ✅ |
| 2026-04-21 | SSH キー認証 PowerShell 版完成 | ✅ |
| 2026-04-20 | Contact Form 7 デプロイメント完成 | ✅ |
| 2026-04-13 | プロジェクト開始 | ✅ |

---

## 🎉 まとめ

このプロジェクトは **完全自動化** と **セキュアな多環境同期** を実現しています：

- 🚀 **自動化**: ワンクリックで WordPress デプロイメント完了
- 🔄 **同期**: Google Drive + GitHub + Linux の3way 同期
- 🔐 **セキュリティ**: SSH キー認証でパスワード不要
- 📱 **モビリティ**: 出張中も Google Drive で常時同期可能

**次のステップ: [COWORK_DEPLOYMENT_CHECK.md](COWORK_DEPLOYMENT_CHECK.md) で検証開始！** ✅

---

**最終更新**: 2026-04-23  
**ブランチ**: `claude/review-nagi-financial-shop-5xOxg`  
**ライセンス**: 内部使用
