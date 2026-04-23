# 🔄 統合同期フロー — 両ボタン完全自動化

**プロジェクト**: 凪フィナンシャル WordPress デプロイメント + 3way 同期  
**バージョン**: 1.0 (2026-04-23)  
**対象者**: Windows 自宅PC / 出張ノート PC / Linux サーバー

---

## 📋 概要

このドキュメントは、2つのワンボタン自動化の統合同期フローを説明します：

| ボタン | タイミング | 実行内容 | 同期先 |
|--------|-----------|---------|--------|
| 🚗 出発・同期実施 | **出発前** | Windows → Google Drive / GitHub | Google Drive + GitHub |
| 🏠 帰宅・同期スタート | **帰宅直後** | Google Drive / WordPress デプロイ | WordPress + Linux |

---

## 🔄 統合同期フロー（時系列）

```
【Day 1: 出発準備】
┌──────────────────────────────────────┐
│ 📊 Windows 自宅PC                      │
│   └─ 🚗 出発・同期実施 ボタン         │
└──────────────────────────────────────┘
         ↓ (Git コミット・プッシュ)
┌──────────────────────────────────────┐
│ 🌐 GitHub リポジトリ                   │
│   └─ claude/review-nagi-financial... │
└──────────────────────────────────────┘
         ↓ (Google Drive for Desktop 同期)
┌──────────────────────────────────────┐
│ 🎨 Google Drive                       │
│   └─ 凪フィナンシャル SHOP/           │
│      ├─ セットアップ/                │
│      ├─ スクリプト/                  │
│      └─ komashop-docs/ (新規同期)     │
└──────────────────────────────────────┘
         ↓ (ノート PC で自動ダウンロード)
┌──────────────────────────────────────┐
│ 💻 Windows ノート PC（出張用）         │
│   └─ Google Drive フォルダ同期完了    │
└──────────────────────────────────────┘

【Day 2-N: 出張中】
┌──────────────────────────────────────┐
│ 💻 Windows ノート PC                   │
│   • セットアップファイル参照           │
│   • TRAVEL_SETUP.md で確認            │
│   • Google Drive で最新情報取得       │
└──────────────────────────────────────┘
         ↓ (30分ごと自動同期)
┌──────────────────────────────────────┐
│ 🎨 Google Drive                       │
│   └─ rclone で定期同期中              │
└──────────────────────────────────────┘
         ↓ (自動プッシュ)
┌──────────────────────────────────────┐
│ 🌐 GitHub リポジトリ                   │
│   └─ 最新ファイル保持                 │
└──────────────────────────────────────┘

【Day N+1: 帰宅直後】
┌──────────────────────────────────────┐
│ 📊 Windows 自宅PC                      │
│   └─ 🏠 帰宅・同期スタート ボタン     │
└──────────────────────────────────────┘
         ↓ (WordPress デプロイメント)
┌──────────────────────────────────────┐
│ 🖥️ Xserver WordPress                  │
│   ├─ Contact Form 7 インストール      │
│   ├─ お問い合わせフォーム作成        │
│   ├─ footer.php 埋め込み              │
│   └─ メール自動設定                  │
└──────────────────────────────────────┘
         ↓ (Google Drive 同期実行)
┌──────────────────────────────────────┐
│ 🎨 Google Drive                       │
│   └─ 最新ファイル取得                │
└──────────────────────────────────────┘
         ↓ (cron 自動設定)
┌──────────────────────────────────────┐
│ 🐧 Linux（Claude Code）               │
│   ├─ rclone Google Drive 認証         │
│   ├─ crontab スケジュール設定         │
│   └─ 30分ごと自動同期開始            │
└──────────────────────────────────────┘
```

---

## 🚗 Phase 1: 出発・同期実施（出発前）

### タイムフロー

```
[時刻] [ステップ] [処理内容] [完了時間]
────────────────────────────────────────
13:45 Step 1    Windows ローカル作業確認     1分
13:46 Step 2    Git ステータス確認・コミット 2分
13:48 Step 3    GitHub プッシュ実行          1分
13:49 Step 4    Google Drive 同期確認        1分
13:50 Step 5    Google Drive へのコピー      2分
13:52 Step 6    セットアップファイル確認    1分
13:53 Step 7    ノート PC セットアップ案内  2分

【完了】15:55 出発準備完了 ✅
```

### 実装内容

#### Step 1: Windows ローカル作業確認
```bash
確認項目：
- git status で未コミット変更を検出
- ローカルの docs/ フォルダを確認
- scripts/ フォルダを確認
```

#### Step 2: Git ステータス確認・コミット
```bash
処理：
1. git status --porcelain で未コミット変更を取得
2. あれば：自動コミット
   git add -A
   git commit -m "Departure sync: Windows から出発前の最新状態"
3. なければ：スキップ
```

#### Step 3: GitHub プッシュ実行
```bash
処理：
git push origin claude/review-nagi-financial-shop-5xOxg

結果：
- ✓ プッシュ成功 → 次ステップ
- ✗ プッシュ失敗 → スキップ可能
```

#### Step 4-5: Google Drive 同期
```bash
処理：
1. Google Drive フォルダの存在確認
2. docs/ をコピー
   cp -r docs/ "$GDRIVE/komashop-docs"
3. Google Drive for Desktop が自動同期
```

#### Step 6: 出張用セットアップファイル確認
```
確認ファイル：
□ TRAVEL_SETUP.md
□ QUICK_REFERENCE.txt
□ PACKING_CHECKLIST.md
```

#### Step 7: ノート PC セットアップ案内
```
ノート PC での作業：
1. Google Drive for Desktop インストール
2. Google アカウントでログイン
3. 凪フィナンシャル SHOP フォルダ同期
4. リポジトリをクローン
   git clone -b claude/review-nagi-financial-shop-5xOxg ...
5. TRAVEL_SETUP.md を確認
```

### 完了通知

```
✅ 出発準備 完了

通知方法：
1️⃣ Windows Desktop Notification（画面右下）
2️⃣ Discord 報告（プロジェクトチャネル）
3️⃣ ログファイル：C:\Logs\departure-sync\*.log
```

---

## 🏠 Phase 2: 帰宅・同期スタート（帰宅直後）

### タイムフロー

```
[時刻] [ステップ] [処理内容] [完了時間]
────────────────────────────────────────
20:30 Step 1    環境チェック                   2分
20:32 Step 2    WordPress デプロイメント       10分
20:42 Step 3    デプロイメント検証             2分
20:44 Step 4    rclone 認証確認                2分
20:46 Step 5    cron スケジュール確認・設定   3分
20:49 Step 6    Google Drive 同期実行          3分
20:52 Step 7    ログ記録                       1分
20:53 Step 8    完了通知                       1分

【完了】20:54 帰宅・同期スタート完了 ✅
```

### 実装内容

#### Step 1: 環境チェック
```bash
確認内容：
- SSH キー存在確認
  Test-Path "$env:USERPROFILE\.ssh\xserver_key"
- Xserver 接続テスト
  ssh -i $KeyPath "$Username@$Host" "echo OK"
```

#### Step 2: WordPress デプロイメント実行
```bash
処理：
実行ファイル: xserver-auto-deploy.bat
内容：
  ├─ Contact Form 7 インストール
  ├─ お問い合わせフォーム自動作成
  ├─ footer.php 埋め込み
  └─ メール設定

時間：約10分
```

#### Step 3: デプロイメント検証
```bash
確認コマンド：
wp core is-installed
  → WordPress インストール確認

結果：
- ✓ インストール確認 → 次ステップ
- ✗ 確認失敗 → スキップ可能
```

#### Step 4: rclone 認証確認
```bash
確認：
1. rclone version で確認
2. rclone config show komashop-gdrive で確認
3. 未認証の場合：rclone config で認証開始
```

#### Step 5: cron スケジュール確認・設定
```bash
確認：
crontab -l | grep google-drive-sync

未設定の場合：
crontab -e で以下を追加
*/30 * * * * /path/to/google-drive-sync.sh
```

#### Step 6: Google Drive 同期実行
```bash
処理：
1. Google Drive → ローカル同期（rclone）
   rclone sync komashop-gdrive: /home/user/komashop-gdrive/

2. ローカル → GitHub 統合
   cp -r /home/user/komashop-gdrive/セットアップ/* docs/

3. Git プッシュ
   git push origin claude/review-nagi-financial-shop-5xOxg
```

#### Step 7: ログ記録
```bash
ログファイル：
C:\Logs\home-sync\sync-20260423-2053.log

記録内容：
- 各ステップの実行結果
- エラー詳細
- 実行時間
```

#### Step 8: 完了通知
```
✅ 帰宅・同期スタート 完了

通知方法：
1️⃣ Windows Desktop Notification（画面右下）
2️⃣ Discord 報告（プロジェクトチャネル）
3️⃣ ログファイル記録

内容：
- 完了時刻
- 実行ステップと結果
- エラー概要（ある場合）
- 次回同期予定時刻
```

---

## 🔐 データ一貫性・同期確認

### 同期状態の検証方法

#### ✓ 自宅 PC から確認
```powershell
# Google Drive ファイル最新確認
Get-ChildItem "$env:USERPROFILE\Google Drive\komashop-docs" -Recurse | Select-Object FullName, LastWriteTime

# GitHub 最新コミット確認
git log --oneline -5
```

#### ✓ GitHub から確認
```bash
# ブラウザで確認
https://github.com/tanko628-a11y/komashop
→ Commits タブで最新コミット確認
→ 時刻が現在時刻と合致しているか確認
```

#### ✓ ノート PC から確認
```bash
# Google Drive 同期完了確認
ls -la ~/Google\ Drive/凪フィナンシャル\ SHOP/

# リポジトリ最新確認
git pull origin claude/review-nagi-financial-shop-5xOxg
```

#### ✓ Linux（Claude Code）から確認
```bash
# rclone 同期確認
rclone ls komashop-gdrive:/

# ローカルフォルダサイズ確認
du -sh /home/user/komashop-gdrive/

# git log 確認
git log --oneline -5
```

---

## ⚠️ トラブルシューティング

### Q: 出発ボタンを押したのにプッシュされない

```
A: 以下を確認：
1. GitHub に認証済みか確認
   git config --list | grep user.name
2. SSH キーが正しく設定されているか確認
3. インターネット接続を確認
→ スキップして続行も可能
```

### Q: 帰宅ボタンを押したのに WordPress がデプロイされない

```
A: 以下を確認：
1. Xserver に SSH キーが登録されているか
   ssh -i $KeyPath $User@$Host "echo OK"
2. WordPress パスが正しいか確認
3. デプロイメント中のエラーをログで確認
→ スキップして続行も可能
```

### Q: Google Drive が同期されない

```
A: 以下を確認：
1. Google Drive for Desktop がインストール・起動しているか
2. インターネット接続を確認
3. Google アカウントのログイン状態を確認
4. ディスク容量を確認
```

### Q: データが見落とされていないか心配

```
A: 以下の方法で確認：

1️⃣ 最新コミット確認
   git log --oneline -1
   → 時刻が合致しているか

2️⃣ ファイル数確認
   Windows:  Get-ChildItem docs | Measure-Object
   Google Drive: Find /path -type f | wc -l
   GitHub: GitHub Web で確認
   → 数字が一致しているか

3️⃣ ログファイル確認
   C:\Logs\home-sync\*.log
   C:\Logs\departure-sync\*.log
   → エラーがないか確認
```

---

## 📊 同期パイプライン概要図

```
┌─────────────────────────────────────────────────────────────┐
│ 同期パイプライン（完全自動化）                              │
└─────────────────────────────────────────────────────────────┘

出発前（🚗 ボタン）
│
├─→ Windows コミット・プッシュ
│   └─→ GitHub 最新状態
│       └─→ Google Drive 同期開始
│           └─→ ノート PC が自動取得
│
出張中
│
├─→ ノート PC で Google Drive 参照
│
├─→ Linux で 30分ごと自動同期
│   ├─→ Google Drive ← rclone
│   ├─→ ローカル同期実行
│   └─→ GitHub プッシュ
│
帰宅後（🏠 ボタン）
│
├─→ WordPress デプロイメント
│
├─→ Google Drive 同期実行
│
├─→ cron スケジュール設定
│
└─→ 30分ごと自動同期開始（以降無限ループ）
    ├─→ Google Drive → Linux
    ├─→ Linux → GitHub
    └─→ GitHub → Windows/ノート PC（git pull）
```

---

## ✅ チェックリスト

### デプロイ前
- [ ] 🚗 出発・同期実施 ボタンがデスクトップにあるか
- [ ] 🏠 帰宅・同期スタート ボタンがデスクトップにあるか
- [ ] PowerShell 実行ポリシーが有効か
  ```powershell
  Get-ExecutionPolicy → RemoteSigned 以上
  ```

### 出発時
- [ ] 🚗 出発・同期実施 を実行
- [ ] Windows 通知・Discord 通知を確認
- [ ] ログファイルでエラーを確認
- [ ] ノート PC で Google Drive が同期されているか確認

### 帰宅時
- [ ] 🏠 帰宅・同期スタート を実行
- [ ] WordPress デプロイメント完了を確認
- [ ] ロールバック・エラーがないか確認
- [ ] cron スケジュール設定を確認
  ```bash
  ssh user@host "crontab -l | grep google-drive-sync"
  ```

### 継続運用
- [ ] 毎日ログを確認
  ```bash
  tail -20 /home/user/komashop/logs/gdrive-sync.log
  ```
- [ ] 週1回 GitHub で最新コミットを確認
- [ ] 月1回 全同期パイプラインをテスト

---

## 🎉 最後に

このシステムにより、以下が実現されます：

✅ **完全自動化**: 2つのボタンで全プロセス完了  
✅ **時系列同期**: 出発前→出張中→帰宅後の完全な一貫性  
✅ **見落とし防止**: すべてのステップをログに記録  
✅ **無人実行**: 寝ている間に全同期完了  
✅ **エラー対応**: スキップ可能で堅牢性が高い  

安全で効率的な出張・帰宅ワークフローをお楽しみください！

---

**最終更新**: 2026-04-23  
**ドキュメント**: 完全版  
**ステータス**: ✅ 実装完了
