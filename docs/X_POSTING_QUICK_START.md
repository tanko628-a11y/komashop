# ⚡ X投稿 OODA — クイックスタート（実行優先順）

**実装期間**: 2026-04-24（今日） ~ 2026-04-30（1週間）  
**目標**: OODA サイクルの完全自動化を実現  
**月間投稿目標**: 25-35 件（Type A: 毎営業日）

---

## 🎯 本日（2026-04-24）のタスク — 1時間で完結

### ✅ Task 1: Google Apps Script プロジェクト作成（15分）

```
1. Google Drive → https://drive.google.com
2. 左上「+ 新規作成」→ 「Google Apps Script」
3. プロジェクト名: "凪FX - X投稿 OODA 自動化"
4. 保存（Ctrl+S）

✓ 完了確認: GAS エディタが開く
```

---

### ✅ Task 2: GAS コードを貼り付け（10分）

```javascript
// エディタのコードをすべて削除
// 以下の 2 つの関数を Code.gs にコピー:
// 参照: docs/GAS_X_POSTING_SETUP.md の「Step 3」「Step 4」

// 1. observeMarket() 関数
// 2. reflectOnPostings() 関数
// 3. setObserveTrigger() + setReflectTrigger() ※オプション

// Ctrl+S で保存
```

**参照**: `/home/user/komashop/docs/GAS_X_POSTING_SETUP.md`

---

### ✅ Task 3: API キー登録（15分）

```
【Google Apps Script】
  プロジェクト設定 → スクリプトプロパティ → 編集

【追加する 4 項目】
  1️⃣ DISCORD_WEBHOOK_URL
     値: https://discord.com/api/webhooks/[ID]/[TOKEN]

  2️⃣ TWITTER_BEARER_TOKEN
     値: [Twitter Developer Portal から取得]

  3️⃣ MT4_API_URL
     値: "mock" ※実装中なら後で修正

  4️⃣ GMAIL_LABEL
     値: "X投稿/相場実況型"

【保存】OK ボタン
```

**Discord Webhook 取得方法**:
```
Discord Server → #x-投稿-分析 チャネル
  → ⚙️ チャネル設定
  → 連携機能 → Webhook
  → 新規 Webhook → コピー
```

---

### ✅ Task 4: テスト実行（20分）

```
【手動テスト 1】
Google Apps Script エディタ
  → 関数を選択: observeMarket
  → ▶️ 実行ボタン
  → ログを確認: Logger タブで「✓ OBSERVE」を確認

【確認事項】
✓ エラーが出ていないか
✓ Discord #x-投稿-分析 に投稿されたか

【手動テスト 2】
  → 関数を選択: reflectOnPostings
  → ▶️ 実行ボタン
  → ログを確認

【確認事項】
✓ エラーが出ていないか
✓ Discord に朝レポートが投稿されたか
```

---

### 📊 本日終了時点の達成状況

```
✅ Google Apps Script プロジェクト作成
✅ GAS コード実装
✅ API キー設定
✅ テスト実行完了
✅ Discord 連携確認

進捗: 40% → 60%
```

---

## 📅 明日以降（2026-04-25）のタスク

### ✅ Task 5: Gmail メールテンプレート作成（30分）

```
Gmail で以下の 5 個の下書きを作成:

【タイプ A: 相場実況型】
  件名: 【凪FX】[相場実況] YYYY-MM-DD [概要]
  本文: [GAS_X_POSTING_SETUP.md「タイプA」参照]
  ラベル: "X投稿 > 相場実況型"

【タイプ B: Dev Logs型】
  件名: 【凪FX】[Dev Log] YYYY-MM-DD [タスク名]
  本文: [テンプレート参照]
  ラベル: "X投稿 > Dev Logs型"

【タイプ C: 失敗ケース型】
  件名: 【凪FX】[失敗ケース] YYYY-MM-DD [事例]
  本文: [テンプレート参照]

【タイプ D: テスター結果型】
  件名: 【凪FX】[テスター結果] YYYY-MM-DD [ロジック名]
  本文: [テンプレート参照]

【タイプ E: 市場分析型】
  件名: 【凪FX】[市場分析] YYYY-MM-DD [テーマ]
  本文: [テンプレート参照]
```

---

### ✅ Task 6: トリガー設定（5分）

```
Google Apps Script → トリガー → 新規作成

【Observe トリガー】
  関数: observeMarket
  実行: 毎日
  時刻: 23:00
  タイムゾーン: Asia/Tokyo
  → 保存

【Reflect トリガー】
  関数: reflectOnPostings
  実行: 毎日
  時刻: 06:00
  タイムゾーン: Asia/Tokyo
  → 保存

✓ 確認: トリガーページに 2 個のトリガーが表示される
```

---

### 📊 2日目終了時点の達成状況

```
✅ Google Apps Script プロジェクト
✅ GAS コード実装
✅ API キー設定
✅ テスト実行完了
✅ Gmail メールテンプレート 5 個
✅ トリガー設定（23:00, 06:00）

進捗: 60% → 80%
```

---

## 🚀 週末以降（2026-04-27+）のタスク

### ✅ Task 7: 自動実行確認（継続）

```
【初回自動実行確認】
2026-04-24 23:00: Observe が自動実行
  → Google Apps Script の実行履歴で確認
  → Discord #x-投稿-分析 で投稿確認

2026-04-25 06:00: Reflect が自動実行
  → ログ確認
  → Discord でレポート確認
```

---

### ✅ Task 8: 日常運用開始

```
【毎日 23:00】
→ Observe が自動実行
→ Discord に観察結果投稿
→ ユーザーがメール候補を確認

【毎日 06:00】
→ Reflect が自動実行
→ Discord に朝レポート投稿
→ 昨日のパフォーマンス確認

【毎日 17:00】
→ ユーザーが X に投稿（メール選択済み）

【毎営業日（月-金）】
→ Type A（相場実況）を投稿

【週 1-2 回】
→ Type B（Dev Logs）を投稿

【月 1-2 回】
→ Type C/D/E を投稿
```

---

## 📊 成功の指標

### 完全稼働のサイン

```
✅ 毎日 23:00 に Observe が実行される
✅ 毎日 06:00 に Reflect が実行される
✅ Discord に毎日 2 回（23:00, 06:00）通知が来る
✅ ユーザーが毎日メール候補を確認できる
✅ ユーザーが毎日 17:00 に X に投稿できる
✅ 月間 25-35 件の X 投稿が実現する
```

### 実装の進捗チェック

| 項目 | 状態 | 期限 |
|------|------|------|
| GAS プロジェクト作成 | 📍 2026-04-24 | ✅ |
| コード実装 | 📍 2026-04-24 | ✅ |
| API キー設定 | 📍 2026-04-24 | ✅ |
| テスト実行 | 📍 2026-04-24 | ✅ |
| Gmail テンプレート | 📍 2026-04-25 | 明日 |
| トリガー設定 | 📍 2026-04-25 | 明日 |
| 初回自動実行 | 📍 2026-04-24 23:00 | 本日夜 |
| 日常運用開始 | 📍 2026-04-27 | 週末 |

---

## 💡 実装のポイント

### 🔴 よくある落とし穴

```
❌ API キーを GitHub にコミットする
  → スクリプトプロパティに保存する

❌ トリガーのタイムゾーンを UTC のままにする
  → Asia/Tokyo に変更する（重要！）

❌ Discord Webhook URL の末尾に余分なスペース
  → コピー・ペーストで余分な文字を確認

❌ Gmail ラベルを作成しない
  → GAS コードが動作しない（自動作成は未実装）

❌ Twitter Bearer Token を発行せずに実装
  → Twitter Developer Portal から事前に取得
```

---

### ✅ 実装のコツ

```
✓ Google Apps Script は保存を頻繁に（Ctrl+S）
✓ テスト実行はログを常に確認
✓ Discord で投稿が来ているか確認
✓ API キーが無くても "mock" で動作テスト可
✓ 実行ログは 30 日間保持される（トラブル時に参照）
```

---

## 📞 サポート

### トラブルシューティング

| 問題 | 原因 | 解決 |
|------|------|------|
| GAS がエラーで動作しない | コード構文エラー | `GAS_X_POSTING_SETUP.md` のコードを確認 |
| Discord に投稿されない | Webhook URL 不正 | `プロジェクト設定 → スクリプトプロパティ` で再確認 |
| トリガーが実行されない | タイムゾーン UTC のまま | トリガー → `Asia/Tokyo` に変更 |
| Twitter API エラー | Bearer Token 無効 | Twitter Developer Portal で新規発行 |

### 詳細ドキュメント

- 📖 **セットアップ詳細**: `docs/GAS_X_POSTING_SETUP.md`
- 📖 **実装ガイド**: `docs/X_POSTING_IMPLEMENTATION_GUIDE.md`
- 📖 **OODA ガイド**: `docs/KOMASHIKIFX_X_POSTING_OODA.md`

---

## 🎉 実装完了後の流れ

```
【月間サイクル】

Week 1: 初期設定 & テスト（本週）
  → Google Apps Script 実装
  → 自動化確認

Week 2-4: 日常運用
  → 毎日 23:00 Observe 確認
  → 毎日 06:00 Reflect 確認
  → 毎日 17:00 X 投稿

Month 2+: パフォーマンス最適化
  → 月 1 回分析レビュー
  → エンゲージメント改善提案
  → Type ごとのパフォーマンス分析
```

---

**本日から 1 週間で、完全に自動化された X投稿 OODA システムが稼働します！**

