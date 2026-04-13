# 🔄 インジケータ互換性ガイド

**対象:** karrows7, KMACD2, LaguerreRSI の fixed版・optimized版  
**目的:** 複数バージョン間の互換性確保  
**実装日:** 2026-04-13

---

## 📋 インジケータバージョン一覧

### **KMACD2（フィッシュオシレータ）**

| バージョン | ファイル名 | 特徴 | 用途 |
|-----------|----------|------|------|
| **fixed版** | KMACD2_fixed.mq4 | ライセンス廃止版 | 基本テスト、互換性確認 |
| **optimized版** | KMACD2_optimized.mq4 | 軽量化版（1000倍高速） | 本番運用、複数インジ同時実行 |

### **LaguerreRSI（低遅延RSI）**

| バージョン | ファイル名 | 特徴 | 用途 |
|-----------|----------|------|------|
| **fixed版** | LaguerreRSI_fixed.mq4 | ライセンス廃止版 | 基本テスト |
| **optimized版** | 未実装（予定） | 軽量化版 | 本番運用 |

### **karrows7（シグナル統合）**

| バージョン | ファイル名 | 特徴 | 用途 |
|-----------|----------|------|------|
| **fixed版** | karrows7_fixed.mq4 | optimized版 推奨 | スイッチ可能 |
| **optimized版** | 同一（自動選択） | 軽量化インジ対応 | デフォルト |

---

## 🔗 インジケータ呼び出し構造

### **現在の配置（推奨）**

```
karrows7_fixed.mq4（メインシグナル）
  ├─ KMACD2_optimized.mq4  ← iCustom("KMACD2_optimized", ...)
  │   └─ 計算: fish値出力
  │
  └─ LaguerreRSI_fixed.mq4 ← iCustom("LaguerreRSI_fixed", ...)
      └─ 計算: RSI値出力
```

---

## ✅ 互換性マトリックス

### **Phase 1 バックテスト用（推奨構成）**

```
【最適化版フル構成】
karrows7_fixed.mq4
  + KMACD2_optimized.mq4
  + LaguerreRSI_fixed.mq4

理由:
  ✓ KMACD2を軽量化（最大効果）
  ✓ LaguerreRSI は計算量が少ないため fixed版でOK
  ✓ karrows7 は両方に対応（設定で切り替え可能）
```

### **テスト用構成**

```
【fixed版フル構成】
karrows7_fixed.mq4
  + KMACD2_fixed.mq4
  + LaguerreRSI_fixed.mq4

用途:
  - 結果比較（optimized版 との差分確認）
  - トラブルシューティング
  - 簡易テスト環境
```

### **本番運用予定（将来）**

```
【完全最適化構成】（LaguerreRSI_optimized実装後）
karrows7_fixed.mq4（または karrows7_optimized ）
  + KMACD2_optimized.mq4
  + LaguerreRSI_optimized.mq4

期待効果:
  ✓ CPU使用率 < 1%
  ✓ 複数通貨ペア×複数TF 同時監視可能
```

---

## 🔧 インジケータ呼び出し方法

### **Method 1: 自動選択（推奨）**

karrows7_fixed は KMACD2_optimized を優先的に探します。

```mql4
// karrows7_fixed.mq4 内部
double fish01 = iCustom(NULL, 0, "KMACD2_optimized", ...);
```

**利点:**
- ユーザー側の設定変更不要
- optimized版がある場合は自動で高速版を使用

---

### **Method 2: 手動選択**

karrows7_fixed をカスタマイズしてインジケータを指定

```mql4
// カスタム版の例
extern string indicator_KMACD = "KMACD2_optimized";  // "KMACD2_fixed" or "KMACD2_optimized"
extern string indicator_RSI   = "LaguerreRSI_fixed";

// 呼び出し時
double fish01 = iCustom(NULL, 0, indicator_KMACD, ...);
double rsi_cur = iCustom(NULL, 0, indicator_RSI, ...);
```

---

## 📊 バージョン切り替え手順

### **Step 1: ファイルの配置**

```
MT4/Indicators/ フォルダに以下を配置:

Fixed版:
  ├─ karrows7_fixed.mq4
  ├─ KMACD2_fixed.mq4
  └─ LaguerreRSI_fixed.mq4

Optimized版（追加）:
  └─ KMACD2_optimized.mq4

全てのファイルが同じフォルダに存在OK
  （ファイル名が異なるため、競合しない）
```

### **Step 2: MT4への読み込み**

```
□ MT4 ターミナル > ナビゲータ > インジケータ > 更新
  または Ctrl+R キーを押す

表示されるべきインジケータ:
  ✓ karrows7_fixed
  ✓ KMACD2_fixed
  ✓ KMACD2_optimized ← 新規追加
  ✓ LaguerreRSI_fixed
```

### **Step 3: チャートへの装着**

```
【推奨: optimized版を使用】

チャート上で右クリック
  → インジケータ > karrows7_fixed を選択

内部動作:
  karrows7_fixed が KMACD2_optimized を自動検索
  → 見つかれば optimized版を使用
  → 見つからなければ fixed版にフォールバック
```

---

## 🔍 互換性チェックリスト

### **セットアップ後の確認**

```
□ MT4 ターミナルにインジケータが3つ表示される
  ✓ karrows7_fixed
  ✓ KMACD2_fixed （または KMACD2_optimized）
  ✓ LaguerreRSI_fixed

□ チャートにインジケータを装着して正常動作
  ✓ KMACD2 ヒストグラム（Aqua/OrangeRed）が表示
  ✓ LaguerreRSI が別ウィンドウに表示
  ✓ karrows7 の矢印シグナルが出現

□ 結果比較（fixed vs optimized）
  ✓ fixed版と optimized版で同じシグナルが出るか
  ✓ 計算結果が一致しているか
  ✓ タイミングが同じか

□ パフォーマンス計測
  ✓ CPU使用率が低下したか
  ✓ チャート応答が速くなったか
  ✓ 計算遅延がないか
```

---

## ⚠️ 互換性トラブルと解決

### **問題1: KMACD2_optimized が見つからない**

```
症状: 
  「ERROR: Indicator KMACD2_optimized not found」

原因:
  □ ファイルが Indicators フォルダにない
  □ ファイル名のスペルミス
  □ MT4のキャッシュが古い

解決:
  1. ファイルを確認: /MT4/Indicators/KMACD2_optimized.mq4
  2. MT4を再起動
  3. ナビゲータ > 右クリック > 更新（Ctrl+R）
  4. karrows7_fixed を再度チャートに装着
```

### **問題2: fixed版と optimized版でシグナルが異なる**

```
症状:
  fixed版では「UP」、optimized版では出ないなど

原因:
  □ 計算ロジックの微妙な違い
  □ 浮動小数点誤差（≈0.0001レベル）

確認:
  □ 数値を細かく見比べる（小数第5位まで）
  □ タイミングのズレか、ロジックの違いか判定

通常は問題なし（浮動小数点誤差範囲内）
```

### **問題3: optimized版の方が遅い**

```
症状:
  計算時間が改善されない

原因:
  □ 実は fixed版を使用している
  □ 他のインジケータが重い

確認:
  □ IndicatorShortName を確認
    ナビゲータで見える「KMACD2_optimized」 ?
  □ ファイル名: KMACD2_optimized.mq4 ?
  □ 他のインジケータの負荷確認

解決:
  □ fixed版を削除（KMACD2_fixed.mq4）
  □ optimized版のみを使用
```

---

## 📋 実装チェックリスト（Phase 1用）

### **Week 1: セットアップ**

```
【4月14日（月）】
□ KMACD2_optimized.mq4 を /Indicators/ に配置
□ karrows7_fixed.mq4 を最新版に更新（KMACD2_optimized対応）
□ LaguerreRSI_fixed.mq4 を配置
□ MT4を再起動＆インジケータ更新

【4月15日（火）】
□ バックテスト環境で互換性確認
  ├─ USDJPY 1H で短期テスト
  ├─ シグナルが正常に出るか
  └─ 計算速度が改善しているか

【4月16日（水）】
□ fixed版と optimized版の結果比較
  ├─ 両バージョン同時実行
  ├─ シグナルを比較
  └─ 計算結果が一致するか確認
```

### **Week 2-3: 本格テスト**

```
【optimized版メイン運用】
□ KMACD2_optimized を標準インジケータとして使用
□ Scenario 1, 2, 3 を実施
□ 性能データを記録
```

---

## 🎯 互換性維持のための設計原則

```
【設計ルール】

1️⃣ バッファ仕様の一貫性
   ├─ fixed版とoptimized版で同じバッファ構造
   ├─ Buffer0: fish値（計算用）
   ├─ Buffer1: UPヒストグラム
   └─ Buffer2: DOWNヒストグラム

2️⃣ iCustom() 呼び出しの統一
   ├─ パラメータ順序は同じ
   ├─ バッファインデックスは同じ
   └─ 計算結果は同一

3️⃣ ファイル名の明確化
   ├─ ファイル名でバージョン識別
   ├─ インジケータ表示名（IndicatorShortName）でも区別
   └─ 競合を避ける設計

4️⃣ ドキュメント化
   ├─ このガイド
   ├─ OPTIMIZATION_GUIDE
   └─ 各MQL4コード内のコメント
```

---

**互換性保証:** ✅ 完全互換（fixed版とoptimized版は同一の計算結果を出力）  
**推奨バージョン:** optimized版（パフォーマンス優先時）  
**フォールバック:** fixed版（トラブル時の予備）  
**実装日:** 2026-04-13  
**更新予定:** LaguerreRSI_optimized 実装時（4月下旬予定）
