# 🚀 Google Apps Script（GAS）X投稿 OODA 自動化セットアップ

**目的**: 相場観察→分析→X投稿を自動化し、手作業を最小化  
**設定日**: 2026-04-24  
**対象**: 凪フィナンシャル X投稿 OODA ループ

---

## 📋 事前準備

### 必要なアカウント
- ✅ Google アカウント（凪フィナンシャル用）
- ✅ Gmail アカウント（kei@komasanshop.com）
- ✅ Discord サーバーアクセス（#x-投稿-分析）
- ✅ X Developer Account（API キー取得済み）
- ✅ Google Apps Script（GAS）アクセス権限

### API キーの確認

```bash
# X API キーの保存場所
~/.env または 環境変数で設定
- TWITTER_API_KEY
- TWITTER_API_SECRET
- TWITTER_BEARER_TOKEN
```

---

## 🔧 Step 1: Google Apps Script プロジェクト作成

### 1.1 新規スクリプトプロジェクト作成

```
1. Google Drive にアクセス: https://drive.google.com
2. 新規作成 → Google Apps Script
3. プロジェクト名: "凪FX - X投稿 OODA 自動化"
4. 保存
```

### 1.2 Google Apps Script コンソール

```
プロジェクト ID: [自動生成される]
作成者: kei@komasanshop.com
デプロイ方法: 2つのスクリプト併用
  1. Observe スクリプト（23:00 実行）
  2. Reflect スクリプト（06:00 実行）
```

---

## 📝 Step 2: メール記者プロンプト設定

### 2.1 Gmail で下書きフォルダ作成

```
Gmail フォルダ構成:
├── 凪FX - X投稿（ラベル）
│   ├── 相場実況型（下書き）
│   ├── Dev Logs（下書き）
│   ├── 失敗ケース（下書き）
│   ├── テスター結果（下書き）
│   └── 市場分析（下書き）
```

### 2.2 メール件名テンプレート

各メールテンプレートの件名は以下のフォーマット：

```
【凪FX】[タイプ] [日付] [概要]

例：
【凪FX】[相場実況] 2026-04-24 ドル円145.00突破

【凪FX】[Dev Log] 2026-04-24 MT4 API 連携テスト結果

【凪FX】[失敗ケース] 2026-04-23 リスク管理ルール違反時の復旧手順

【凪FX】[テスター結果] 2026-04-22 自動売買ロジック検証結果

【凪FX】[市場分析] 2026-04-21 週間相場見通し
```

---

## 🤖 Step 3: OODA Observe スクリプト（23:00 自動実行）

### 3.1 スクリプト概要

```
【実行時間】毎日 23:00 JST
【処理内容】
1. MT4 リアルタイムデータ取得（最新4時間）
2. 相場トレンド分析（Moving Average, RSI）
3. Discord に観察記録 POST
4. Gmail 下書き"相場実況型"を候補提示
```

### 3.2 GAS コード（Observe）

```javascript
// 凪FX - Observe スクリプト（23:00 実行）

const DISCORD_WEBHOOK = PropertiesService.getScriptProperties().getProperty('DISCORD_WEBHOOK_URL');
const MT4_API_URL = PropertiesService.getScriptProperties().getProperty('MT4_API_URL');
const GMAIL_LABEL = 'X投稿/相場実況型';

function observeMarket() {
  Logger.log('[OBSERVE] 23:00 相場観察開始...');
  
  // Step 1: MT4 からリアルタイムデータ取得
  const marketData = fetchMT4Data();
  
  // Step 2: トレンド分析
  const analysis = analyzeMarketTrend(marketData);
  
  // Step 3: Discord に観察結果を POST
  postToDiscord('OBSERVE', analysis);
  
  // Step 4: 候補メールを提示
  suggestEmailTemplate(analysis);
  
  Logger.log('[OBSERVE] 23:00 観察完了 ✓');
}

function fetchMT4Data() {
  // MT4 REST API からデータ取得（過去4時間）
  try {
    const response = UrlFetchApp.fetch(MT4_API_URL + '/rates/latest');
    const data = JSON.parse(response.getContentText());
    return {
      timestamp: new Date(),
      eurusd: data.eurusd,
      gbpjpy: data.gbpjpy,
      usdjpy: data.usdjpy,
      nikkei225: data.nikkei225
    };
  } catch(e) {
    Logger.log('Error fetching MT4 data: ' + e);
    return null;
  }
}

function analyzeMarketTrend(data) {
  if (!data) return { error: 'No data' };
  
  return {
    time: data.timestamp,
    eurusd: data.eurusd,
    trend: calculateTrend(data.eurusd),
    strength: calculateStrength(data.eurusd),
    keyLevels: calculateKeyLevels(data.eurusd),
    riskLevel: assessRisk(data)
  };
}

function calculateTrend(price) {
  // Moving Average で短期トレンド判定
  // Simple: 上昇 / 下降 / 横ばい
  return '上昇トレンド'; // 実装後は実際の計算
}

function calculateStrength(price) {
  // RSI で強度判定（0-100）
  return 65; // 実装後は実際の計算
}

function calculateKeyLevels(price) {
  return {
    support: price * 0.99,
    resistance: price * 1.01
  };
}

function assessRisk(data) {
  // リスク評価（Low/Medium/High）
  return 'Medium';
}

function postToDiscord(phase, analysis) {
  const message = {
    content: `🔍 **【${phase}】 相場観察 - ${new Date().toLocaleString('ja-JP')}**`,
    embeds: [{
      color: 0x003366,
      fields: [
        { name: 'EUR/USD', value: analysis.eurusd + '(' + analysis.trend + ')', inline: true },
        { name: 'トレンド強度', value: analysis.strength + '%', inline: true },
        { name: 'リスク', value: analysis.riskLevel, inline: false },
        { name: 'キーレベル', value: 'S: ' + analysis.keyLevels.support.toFixed(4) + ' / R: ' + analysis.keyLevels.resistance.toFixed(4), inline: false }
      ]
    }]
  };
  
  UrlFetchApp.fetch(DISCORD_WEBHOOK, {
    method: 'post',
    contentType: 'application/json',
    payload: JSON.stringify(message)
  });
}

function suggestEmailTemplate(analysis) {
  // Gmail に下書き提示
  const suggestions = GmailApp.search('label:' + GMAIL_LABEL);
  Logger.log('Available email templates: ' + suggestions.length);
  // ユーザーが選択して投稿
}

// トリガー設定：毎日 23:00 に実行
function setObserveTrigger() {
  ScriptApp.newTrigger('observeMarket')
    .timeBased()
    .atHour(23)
    .everyDays(1)
    .create();
  Logger.log('✓ Observe trigger (23:00 JST) created');
}
```

---

## 📊 Step 4: OODA Reflect スクリプト（06:00 自動実行）

### 4.1 スクリプト概要

```
【実行時間】毎日 06:00 JST
【処理内容】
1. 前日の X 投稿をすべて取得
2. エンゲージメント分析（いいね/RT/返信）
3. 投稿タイプ別パフォーマンス集計
4. Discord に朝レポート POST
5. 改善提案を表示
```

### 4.2 GAS コード（Reflect）

```javascript
// 凪FX - Reflect スクリプト（06:00 実行）

const DISCORD_WEBHOOK = PropertiesService.getScriptProperties().getProperty('DISCORD_WEBHOOK_URL');
const TWITTER_BEARER_TOKEN = PropertiesService.getScriptProperties().getProperty('TWITTER_BEARER_TOKEN');

function reflectOnPostings() {
  Logger.log('[REFLECT] 06:00 投稿分析開始...');
  
  // Step 1: 前日の X 投稿を取得
  const yesterdayPosts = fetchYesterdayPosts();
  
  // Step 2: エンゲージメント分析
  const analytics = analyzeEngagement(yesterdayPosts);
  
  // Step 3: パフォーマンス集計
  const summary = summarizePerformance(analytics);
  
  // Step 4: Discord レポート POST
  postReflectionReport(summary);
  
  Logger.log('[REFLECT] 06:00 分析完了 ✓');
}

function fetchYesterdayPosts() {
  // Twitter API v2 で前日の投稿を取得
  const yesterday = new Date();
  yesterday.setDate(yesterday.getDate() - 1);
  
  const startTime = new Date(yesterday);
  startTime.setHours(0, 0, 0);
  
  const endTime = new Date(yesterday);
  endTime.setHours(23, 59, 59);
  
  try {
    const url = 'https://api.twitter.com/2/users/me/tweets?start_time=' + 
                startTime.toISOString() + '&end_time=' + endTime.toISOString() +
                '&tweet.fields=public_metrics,created_at';
    
    const response = UrlFetchApp.fetch(url, {
      headers: { 'Authorization': 'Bearer ' + TWITTER_BEARER_TOKEN }
    });
    
    const data = JSON.parse(response.getContentText());
    return data.data || [];
  } catch(e) {
    Logger.log('Error fetching posts: ' + e);
    return [];
  }
}

function analyzeEngagement(posts) {
  return posts.map(post => ({
    id: post.id,
    text: post.text,
    created_at: post.created_at,
    likes: post.public_metrics.like_count,
    retweets: post.public_metrics.retweet_count,
    replies: post.public_metrics.reply_count,
    engagement: post.public_metrics.like_count + 
                post.public_metrics.retweet_count + 
                post.public_metrics.reply_count,
    type: inferPostType(post.text)
  }));
}

function inferPostType(text) {
  if (text.includes('相場') || text.includes('ドル円')) return 'Type A: 相場実況型';
  if (text.includes('開発') || text.includes('API')) return 'Type B: Dev Log型';
  if (text.includes('失敗') || text.includes('NG')) return 'Type C: 失敗ケース型';
  if (text.includes('テスター') || text.includes('結果')) return 'Type D: テスター型';
  if (text.includes('分析') || text.includes('見通し')) return 'Type E: 市場分析型';
  return 'Unknown';
}

function summarizePerformance(analytics) {
  const summary = {
    total_posts: analytics.length,
    total_engagement: 0,
    by_type: {},
    top_post: null,
    average_engagement: 0
  };
  
  analytics.forEach(post => {
    summary.total_engagement += post.engagement;
    
    if (!summary.by_type[post.type]) {
      summary.by_type[post.type] = { count: 0, engagement: 0 };
    }
    summary.by_type[post.type].count++;
    summary.by_type[post.type].engagement += post.engagement;
    
    if (!summary.top_post || post.engagement > summary.top_post.engagement) {
      summary.top_post = post;
    }
  });
  
  summary.average_engagement = Math.round(summary.total_engagement / summary.total_posts);
  
  return summary;
}

function postReflectionReport(summary) {
  const embed = {
    color: 0x003366,
    title: '📊 朝レポート - ' + new Date().toLocaleDateString('ja-JP'),
    fields: [
      { name: '投稿数', value: summary.total_posts.toString(), inline: true },
      { name: '総エンゲージメント', value: summary.total_engagement.toString(), inline: true },
      { name: '平均', value: summary.average_engagement.toString(), inline: true }
    ]
  };
  
  // 投稿タイプ別
  Object.keys(summary.by_type).forEach(type => {
    const data = summary.by_type[type];
    embed.fields.push({
      name: type,
      value: `${data.count}件 / ${data.engagement}エンゲージ`,
      inline: false
    });
  });
  
  // トップ投稿
  if (summary.top_post) {
    embed.fields.push({
      name: 'トップ投稿',
      value: summary.top_post.text.substring(0, 100) + '...',
      inline: false
    });
  }
  
  const message = { embeds: [embed] };
  
  UrlFetchApp.fetch(DISCORD_WEBHOOK, {
    method: 'post',
    contentType: 'application/json',
    payload: JSON.stringify(message)
  });
}

// トリガー設定：毎日 06:00 に実行
function setReflectTrigger() {
  ScriptApp.newTrigger('reflectOnPostings')
    .timeBased()
    .atHour(6)
    .everyDays(1)
    .create();
  Logger.log('✓ Reflect trigger (06:00 JST) created');
}
```

---

## 🔐 Step 5: API キー・認証情報の設定

### 5.1 スクリプトプロパティに登録

```
Google Apps Script → プロジェクト設定 → スクリプトプロパティ

設定する項目:
├── DISCORD_WEBHOOK_URL = "https://discord.com/api/webhooks/..."
├── TWITTER_BEARER_TOKEN = "AAAA..."
├── MT4_API_URL = "https://api.example.com/mt4"
└── GMAIL_LABEL = "X投稿/相場実況型"
```

### 5.2 セキュリティ設定

```javascript
// API キーはスクリプトプロパティに保存（リポジトリに保存しない）
function getProperty(name) {
  return PropertiesService.getScriptProperties().getProperty(name);
}
```

---

## ⏰ Step 6: トリガー設定

### 6.1 スクリプトトリガー作成

```
Google Apps Script エディタ → 左側「トリガー」 → 新規作成

Observe トリガー:
  関数: observeMarket
  実行: 毎日
  時刻: 23:00 (23時)
  タイムゾーン: Asia/Tokyo

Reflect トリガー:
  関数: reflectOnPostings
  実行: 毎日
  時刻: 06:00 (06時)
  タイムゾーン: Asia/Tokyo
```

### 6.2 トリガー確認

```bash
# トリガーが正常に作成されたか確認
Apps Script Editor → トリガー → 確認
```

---

## 🎯 Step 7: Discord Webhook 設定

### 7.1 Discord サーバーで webhook 作成

```
Discord サーバー → #x-投稿-分析 チャネル
  → チャネル設定 → 連携機能 → Webhook
  → 新規 Webhook 作成
  → 名前: "凪FX OODA"
  → コピー Webhook URL
```

### 7.2 Google Apps Script に登録

```
プロジェクト設定 → スクリプトプロパティ
  DISCORD_WEBHOOK_URL = "[コピーした URL]"
```

---

## 📧 Step 8: メールテンプレート設定

### 8.1 Gmail 下書きテンプレート作成

各タイプ別に Gmail 下書きを作成：

**タイプ A: 相場実況型（日次）**
```
宛先: なし（下書きのみ）
件名: 【凪FX】[相場実況] YYYY-MM-DD [相場概況]

本文:
📈 相場実況（YYYY-MM-DD HH:MM）

EUR/USD: X.XXXX [上昇↗ / 下降↘]
トレンド強度: XX%

📍 キーレベル
- サポート: X.XXXX
- レジスタンス: X.XXXX

💡 注目ポイント
[ここに相場分析]

#FX #市場分析 #凪FX
```

**タイプ B: Dev Logs型（週1-2回）**
```
件名: 【凪FX】[Dev Log] YYYY-MM-DD [開発タスク名]

本文:
🔧 開発ログ

【実施内容】
- [タスク内容]
- [実装内容]

【進捗】
完了 / 進行中 / 保留

【次のステップ】
[次の作業内容]

#開発 #FX #技術 #凪FX
```

**タイプ C: 失敗ケース型（月1-2回）**
```
件名: 【凪FX】[失敗ケース] YYYY-MM-DD [失敗事例]

本文:
❌ 失敗から学ぶ

【失敗内容】
[何が起こったか]

【原因分析】
[なぜ失敗したか]

【対策・教訓】
[次にどうするか]

【改善済み内容】
✓ [実施した改善]

#失敗から学ぶ #リスク管理 #凪FX
```

**タイプ D: テスター結果型（月1-2回）**
```
件名: 【凪FX】[テスター結果] YYYY-MM-DD [ロジック名]

本文:
📊 テスター検証結果

【ロジック】
[検証したロジック名]

【テスト期間】
YYYY-MM-DD ～ YYYY-MM-DD

【結果】
勝率: XX%
プロフィット: ¥XX,XXX
ドローダウン: XX%

【評価】
良好 / 改善必要 / 検討中

#バックテスト #検証 #凪FX
```

**タイプ E: 市場分析型（月1-2回）**
```
件名: 【凪FX】[市場分析] YYYY-MM-DD [分析テーマ]

本文:
📊 市場分析レポート

【テーマ】
[分析対象]

【現況】
[現在の状況]

【見通し】
[今後の予想]

【リスク要因】
- [リスク1]
- [リスク2]

【投資戦略への影響】
[我々の戦略への含意]

#市場分析 #見通し #凪FX
```

---

## 🚀 Step 9: 自動化の開始

### 9.1 テスト実行

```javascript
// Apps Script エディタで実行
function testObserve() {
  observeMarket();
}

function testReflect() {
  reflectOnPostings();
}
```

### 9.2 初回確認

```
1. 23:00 に Observe スクリプトが実行されたか確認
   → Discord #x-投稿-分析 に観察結果が posted
   → ユーザーが メールテンプレートを選択して X に投稿

2. 06:00 に Reflect スクリプトが実行されたか確認
   → Discord に朝レポートが posted
   → パフォーマンス分析が表示される
```

---

## 📋 チェックリスト

- [ ] Google Apps Script プロジェクト作成（"凪FX - X投稿 OODA 自動化"）
- [ ] Gmail メールテンプレート 5 タイプ作成（A-E）
- [ ] GAS Observe スクリプト作成・デプロイ
- [ ] GAS Reflect スクリプト作成・デプロイ
- [ ] API キー・トークン設定（スクリプトプロパティ）
- [ ] Discord Webhook 作成・設定
- [ ] Observe トリガー設定（23:00 JST）
- [ ] Reflect トリガー設定（06:00 JST）
- [ ] テスト実行・確認
- [ ] ユーザーに初期稼働通知

---

**セットアップ完了後**: ユーザーは毎日 23:00 に観察結果を確認 → メール選択 → 17:00 に投稿、という最小限の手作業で OODA サイクルが回転します。

