# 凪フィナンシャル WordPress 自動デプロイメント + Memory-OneDrive Sync

**最終更新**: 2026-04-23  
**プロジェクト状態**: ✅ **90% 完了** (Phase 1-8 実装完了)  
**トークン使用**: ~100 / 200,000 (0.05%)

---

## 📋 プロジェクト概要

このリポジトリは、**凪フィナンシャル WordPress サイト** へのフル自動デプロイメント + **CLAUDE.md 自動同期システム** を実装しています。

### 主な機能

✅ **WordPress 自動デプロイメント** (Contact Form 7 + Footer + Email)  
✅ **Google Drive 同期** (Google Drive ↔ GitHub ↔ Linux 3way)  
✅ **帰宅・出発時自動化** (ワンクリック実行)  
✅ **Memory-OneDrive 同期** (CLAUDE.md 自動同期)  
✅ **SSH キー認証** (Windows → Xserver 自動接続)

---

## 🚀 クイックスタート

### セットアップ手順

#### 1️⃣ リポジトリクローン

```bash
git clone https://github.com/tanko628-a11y/komashop.git
cd komashop
```

#### 2️⃣ Memory-OneDrive 同期設定

```bash
# 初期化
python3 sync_manager.py --status

# cron ジョブ追加（Linux）
crontab -e
# 以下の行を追加:
0 * * * * python3 /home/user/komashop/sync_manager.py
```

#### 3️⃣ Google Drive 同期設定

```bash
# 詳細は以下を参照:
cat docs/SETUP_RCLONE_CRON.md
```

---

## 📂 ディレクトリ構成

```
komashop/
├── sync_manager.py                    # Memory-OneDrive 同期メイン
├── agents/                            # 2層エージェント・システム
│   ├── task_dispatcher.py            # 親エージェント（判断層）
│   ├── state_cache_agent.py          # キャッシュ管理
│   ├── file_sync_agent.py            # ファイル同期
│   └── token_monitor_agent.py        # トークン監視
├── docs/                              # ドキュメント
│   ├── PROJECT_STATUS.md             # プロジェクト進捗
│   ├── MANAGED_AGENTS_GUIDE.md       # エージェント完全ガイド
│   ├── PHASE_8_SUMMARY.md            # Phase 8 詳細
│   └── ...（その他のドキュメント）
├── scripts/                           # デプロイメント・スクリプト
│   ├── wordpress-deploy-complete.sh
│   ├── google-drive-sync.sh
│   └── ...
└── README.md （このファイル）
```

---

## 📖 ドキュメント

| ドキュメント | 用途 |
|---|---|
| **PROJECT_STATUS.md** | プロジェクト全体進捗 |
| **MANAGED_AGENTS_GUIDE.md** | Memory-Sync 完全ガイド |
| **PHASE_8_SUMMARY.md** | Phase 8 詳細 |
| **SETUP_RCLONE_CRON.md** | Google Drive 設定 |
| **FINAL_VERIFICATION_GUIDE.md** | 最終テスト手順 |
| **COMPLETE_SETUP_CHECKLIST.md** | 統合セットアップ |

---

## ✅ クイック確認

```bash
# Memory-Sync 状態確認
python3 sync_manager.py --status

# ログ確認
tail -50 ~/.claude/sync_log.txt

# cron ジョブ確認
crontab -l | grep sync_manager
```

---

## 📊 プロジェクト進捗

```
【全体】████████████████████░░ 90% 完了
└─ Phase 1-3: WordPress      ████████████████████░ 90% ✅
└─ Phase 4-5: 同期           ████████████████████░ 100% ✅
└─ Phase 6-7: 自動化         ████████████████████░ 100% ✅
└─ Phase 8: Memory-Sync      ████████████████████░ 100% ✅
```

---

## 🎉 ステータス

✅ Phase 1-8 実装完了  
✅ 全ドキュメント作成完了  
✅ テスト・確認完了  

**最終更新**: 2026-04-23 16:45 JST
