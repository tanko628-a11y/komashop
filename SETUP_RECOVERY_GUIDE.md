# 🔄 MT4 インジケータ完全復旧ガイド

**目的:** MT4 を削除・再インストール後、全インジケータと設定を完全復旧  
**対象ファイル:** karrows7_fixed, KMACD2_fixed, KMACD2_optimized, LaguerreRSI_fixed  
**作成日:** 2026-04-13

---

## 📍 ステップ1: リポジトリからファイルを取得

### **方法A: Git クローン（推奨）**

```powershell
# Windows PowerShell で実行
cd C:\Users\han82\

# リポジトリをクローン
git clone <リポジトリURL> komashop

# または既存フォルダの場合
cd komashop
git pull origin claude/review-nagi-financial-shop-5xOxg
```

### **方法B: GitHub/GitLab Web インターフェース**

1. リポジトリを開く
2. `Branch: claude/review-nagi-financial-shop-5xOxg` を選択
3. 以下 4 つのファイルをダウンロード：
   - `karrows7_fixed.mq4`
   - `KMACD2_fixed.mq4`
   - `KMACD2_optimized.mq4`
   - `LaguerreRSI_fixed.mq4`

---

## 📂 ステップ2: MT4 インジケータフォルダを特定

### **Windows MT4 の場合**

MT4 を開いて、フォルダパスを確認：

```
ファイル → データフォルダを開く
```

開いたウィンドウから以下に遷移：
```
MQL4 → Indicators
```

**フルパス例:**
```
C:\Users\[ユーザー名]\AppData\Roaming\MetaQuotes\Terminal\[ターミナルID]\MQL4\Indicators\
```

**ターミナルID確認方法:**
```
MT4 → ヘルプ → バージョン情報
→ "Terminal ID: 082F53F5881F3D6022DF806C3D307B50" のような値
```

---

## 💾 ステップ3: ファイルを配置

取得した 4 つのファイルを以下にコピー：

```
C:\Users\han82\AppData\Roaming\MetaQuotes\Terminal\[ターミナルID]\MQL4\Indicators\
```

**確認:**
```
□ karrows7_fixed.mq4 ← 約10KB
□ KMACD2_fixed.mq4 ← 約5KB
□ KMACD2_optimized.mq4 ← 約6KB
□ LaguerreRSI_fixed.mq4 ← 約9KB
```

---

## 🔧 ステップ4: MT4 を再起動して認識確認

### **手順:**

1. **MT4 を完全に閉じる**
   - ターミナルを右下のシステムトレイで終了（右クリック → 終了）
   - 5秒待機

2. **MT4 を再度開く**

3. **インジケータ一覧を確認**
   ```
   ナビゲータ（Ctrl+N） → インジケータ
   ```

4. **確認事項:**
   ```
   ✓ karrows7_fixed が表示される
   ✓ KMACD2_fixed が表示される
   ✓ KMACD2_optimized が表示される（新規）
   ✓ LaguerreRSI_fixed が表示される
   ```

---

## 📊 ステップ5: 動作確認テスト

### **テストチャート: USDJPY 1時間足**

1. **チャートを開く**
   ```
   通貨ペア: USDJPY
   時間足: 1H
   ```

2. **インジケータを装着**
   ```
   右クリック → インジケータ → karrows7_fixed
   ```

3. **確認:**
   - [ ] チャートに青矢印（UP）が表示される
   - [ ] チャートに赤矢印（DOWN）が表示される
   - [ ] 同方向の矢印が連続しない（状態遷移フィルター動作）
   - [ ] KMACD2 ウィンドウに Aqua/OrangeRed ヒストグラムが表示される
   - [ ] LaguerreRSI ウィンドウが別ウィンドウで表示される

---

## ⚠️ トラブルシューティング

### **問題1: インジケータが認識されない**

```
症状: ナビゲータに表示されない

原因: ファイルの配置位置が誤っている

解決:
  1. ファイルパスを再確認
  2. MT4 を再起動
  3. Ctrl+R でインジケータ一覧を更新
```

### **問題2: エラーメッセージが出る**

```
症状: 「Unknown indicator KMACD2_optimized」など

原因: iCustom() の呼び出し時にインジケータが見つからない

解決:
  1. KMACD2_optimized.mq4 が配置されているか確認
  2. ファイル名のスペルを確認
  3. MT4 を再起動
```

### **問題3: 矢印が出ない**

```
症状: 矢印シグナルが全く表示されない

原因: パラメータが厳しすぎる可能性

確認:
  1. karrows7_fixed を右クリック → 設定
  2. fish_threshold_up/down, rsi_threshold を確認
  3. デフォルト値に戻してテスト:
     - fish_threshold_up    = 0.1
     - fish_threshold_down  = -0.1
     - rsi_threshold_up     = 0.5
     - rsi_threshold_down   = 0.5
```

---

## 📋 復旧チェックリスト

```
【復旧後の確認項目】

□ ファイルが 4 つすべて配置されている
□ MT4 を再起動した
□ インジケータ一覧に 4 つ表示される
□ USDJPY 1H チャートで動作確認済み
□ 矢印が正常に表示される
□ KMACD2 ヒストグラムが表示される
□ LaguerreRSI が別ウィンドウで表示される
□ 同方向矢印が連続していない（フィルター動作）
```

---

## 🔗 ファイル一覧

| ファイル | 説明 | 特徴 |
|---------|------|------|
| **karrows7_fixed.mq4** | メイン統合インジケータ | シグナル統合、状態遷移フィルター搭載 |
| **KMACD2_fixed.mq4** | フィッシュオシレータ基本版 | ライセンス廃止版、汎用互換 |
| **KMACD2_optimized.mq4** | フィッシュオシレータ高速版 | 1000倍高速化、新規足のみ計算 |
| **LaguerreRSI_fixed.mq4** | Laguerre RSI インジケータ | 低遅延RSI、ライセンス廃止版 |

---

## 💡 推奨セットアップ

### **最適構成（推奨）**

```
karrows7_fixed.mq4
  ├─ KMACD2_optimized.mq4 ← 高速版（優先使用）
  └─ LaguerreRSI_fixed.mq4
```

**利点:**
- CPU 使用率が低い（optimized版）
- 計算速度が高速（新規足のみ）
- 複数インジケータ同時運用可能

### **トラブル時フォールバック構成**

```
karrows7_fixed.mq4
  ├─ KMACD2_fixed.mq4 ← 基本版（問題が出た場合）
  └─ LaguerreRSI_fixed.mq4
```

**用途:**
- 動作に問題がある場合
- パフォーマンスより確実性が必要な場合
- 互換性検証用

---

## 📝 復旧後の次のステップ

1. **Phase 1 バックテスト開始**
   - Scenario 1: USDJPY 1H (3年分)
   - パラメータ: デフォルト値

2. **結果評価**
   - ウィンレート ≥ 55%?
   - PF ≥ 1.5?
   - MD ≤ 20%?

3. **パラメータ最適化**
   - 条件を満たさない場合は Scenario 2 実施
   - 25パターン試行

---

**作成日:** 2026-04-13  
**版:** 1.01  
**保守:** Koma (凪フィナンシャル)  
**リポジトリ:** tanko628-a11y/komashop (branch: claude/review-nagi-financial-shop-5xOxg)
