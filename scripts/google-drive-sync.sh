#!/bin/bash

# ============================================
# Google Drive ↔ GitHub 同期スクリプト
# rclone を使用した自動同期
# ============================================

set -e

# 設定
GOOGLE_DRIVE_REMOTE="komashop-gdrive"  # rclone リモート名
LOCAL_GDRIVE_DIR="/home/user/komashop-gdrive"
REPO_DIR="/home/user/komashop"
SYNC_LOG="${REPO_DIR}/logs/gdrive-sync.log"

# ログディレクトリ作成
mkdir -p "${REPO_DIR}/logs"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] === Google Drive 同期開始 ===" >> "${SYNC_LOG}"

# ===================================
# Phase 1: Google Drive → ローカル同期
# ===================================

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Phase 1: Google Drive → ローカル同期" >> "${SYNC_LOG}"

if rclone config show "${GOOGLE_DRIVE_REMOTE}" > /dev/null 2>&1; then
    rclone sync "${GOOGLE_DRIVE_REMOTE}:凪フィナンシャル SHOP" "${LOCAL_GDRIVE_DIR}" \
        --log-file="${SYNC_LOG}" --log-level INFO \
        --delete-excluded \
        || echo "[エラー] Google Drive 同期失敗" >> "${SYNC_LOG}"
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Google Drive 同期完了" >> "${SYNC_LOG}"
else
    echo "[エラー] rclone リモート '${GOOGLE_DRIVE_REMOTE}' が設定されていません" >> "${SYNC_LOG}"
    exit 1
fi

# ===================================
# Phase 2: ローカル → GitHub 統合
# ===================================

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Phase 2: ローカル → GitHub 統合" >> "${SYNC_LOG}"

cd "${REPO_DIR}"

# Google Drive からダウンロードしたファイルを docs/ に複製
if [ -d "${LOCAL_GDRIVE_DIR}/セットアップ" ]; then
    cp -v "${LOCAL_GDRIVE_DIR}"/セットアップ/* docs/ 2>/dev/null || true
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ セットアップ ファイル複製" >> "${SYNC_LOG}"
fi

if [ -d "${LOCAL_GDRIVE_DIR}/スクリプト" ]; then
    cp -v "${LOCAL_GDRIVE_DIR}"/スクリプト/* . 2>/dev/null || true
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ スクリプト ファイル複製" >> "${SYNC_LOG}"
fi

# Git ステージング・コミット
git add -A

# 変更があるか確認
if git diff --cached --quiet; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] (no changes)" >> "${SYNC_LOG}"
else
    COMMIT_MSG="Sync: Google Drive から最新ファイルを同期 ($(date '+%Y-%m-%d %H:%M:%S'))"
    git commit -m "${COMMIT_MSG}" 2>/dev/null || true
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Git コミット完了" >> "${SYNC_LOG}"
fi

# Git プッシュ
git push origin claude/review-nagi-financial-shop-5xOxg \
    >> "${SYNC_LOG}" 2>&1 || echo "[警告] Git プッシュが失敗しました" >> "${SYNC_LOG}"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ GitHub プッシュ完了" >> "${SYNC_LOG}"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] === Google Drive 同期完了 ===" >> "${SYNC_LOG}"
echo "" >> "${SYNC_LOG}"
