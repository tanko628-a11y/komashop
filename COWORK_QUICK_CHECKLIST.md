# ✅ WordPress デプロイメント クイックチェックリスト

**実行者:** Cowork  
**所要時間:** 約 10 分  
**確認者:** CEO かんざき けい  

---

## 🎯 実行内容（3つのみ）

```
1️⃣ Contact Form 7 をインストール・有効化
2️⃣ footer.php にコード追加
3️⃣ テスト送信・確認
```

---

## 📋 実行チェックリスト

### **準備**
- [ ] WordPress ログイン情報確認
- [ ] COWORK_DEPLOYMENT_INSTRUCTIONS.md を読了

### **ステップ 1: Contact Form 7 インストール**
- [ ] `https://www.komashikifx.site/wp-admin/` にログイン
- [ ] プラグイン → 新規追加 → 「Contact Form 7」で検索
- [ ] インストール → 有効化
- [ ] Contact Form 7 メニューが左サイドバーに表示 ✓

### **ステップ 2: footer.php にコード追加**
- [ ] 外観 → ファイルエディタ
- [ ] footer.php を開く
- [ ] ファイルの最後（`</html>` 前）にコードをペースト
- [ ] 「ファイルの更新」をクリック

### **ステップ 3: テスト送受信**
- [ ] `https://www.komashikifx.site/お問い合わせ/` にアクセス
- [ ] テストデータ入力（名前: テスト 太郎、メール: test@example.com）
- [ ] 送信ボタンをクリック
- [ ] 送信完了メッセージ表示 ✓

### **確認**
- [ ] フッター表示確認：`https://www.komashikifx.site/` ページ下部
- [ ] Contact Form 7 が有効化 ✓
- [ ] CEO が `kei@komasanshop.com` でメール受信確認
- [ ] `test@example.com` に自動返信確認

---

## 📄 footer.php に追加するコード

**[COWORK_DEPLOYMENT_INSTRUCTIONS.md で確認]**

---

## ⚠️ トラブル時

| 問題 | 対応 |
|------|------|
| Contact Form 7 が見つからない | もう一度インストール |
| コード追加に失敗 | CEO に報告 |
| メール届かない | kei@komasanshop.com で受信確認 |

**問題が解決しない → CEO かんざき けい に報告**

---

## ✨ 完了報告

**実行完了後、CEO かんざき けい に以下を報告:**

```
✅ すべてのステップが完了しました

完了内容:
  ✓ Contact Form 7 インストール・有効化
  ✓ footer.php にコード追加
  ✓ テストメール送受信確認
  ✓ 表示確認完了

実行者: [あなたの名前]
実行時刻: [日時]
所要時間: [分]
```

---

**詳細は COWORK_DEPLOYMENT_INSTRUCTIONS.md を参照**
