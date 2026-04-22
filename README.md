# X Post Generator

FX トレード実績を複数パターンの X（旧Twitter）投稿に自動変換するツールです。

## セットアップ

### 方法 1: 自動インストール（Windows 推奨）

PowerShell 実行ポリシーを設定：
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

実行：
```powershell
.\setup.ps1
```

Chrome を再起動。

### 方法 2: 手動インストール

1. `chrome://extensions` を開く
2. 「デベロッパーモード」をオン
3. 「拡張機能を読み込む」で `x-post-generator` フォルダを選択

## 使い方

1. Chrome 拡張機能アイコンをクリック
2. エントリー価格・決済価格を入力
3. 商品・方向を選択
4. ハッシュタグを選択
5. 「全パターンを生成」をクリック
6. 「コピー」で投稿文をコピー
7. X にペースト投稿

## 機能

- 5パターン自動生成
- 複数 PC 同期（chrome.storage.sync）
- カスタムハッシュタグ対応
- 280文字チェック

## トラブルシューティング

**PowerShell ポリシーエラー**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**拡張機能が表示されない**: Chrome を再起動してください

---

Koma（コマ式 FX 練成会）