# X Post Generator

FX トレード実績を複数パターンの X（旧Twitter）投稿に自動変換する Web アプリケーション。

Google Drive に投稿データを自動保存、複数 PC で同期可能。

## 使用方法

1. **Web アプリを開く**: https://tanko628-a11y.github.io/komashop
2. **Google アカウントでログイン**
3. **エントリー価格・決済価格を入力**
4. **商品・方向を選択**
5. **ハッシュタグを選択**
6. **「全パターンを生成」をクリック**
7. **「コピー」で投稿文をコピー**
8. **X にペースト投稿**

## 機能

- **5パターン自動生成**: 異なるトレード報告スタイル
- **Google Drive 自動保存**: データが Google Drive に自動保存
- **複数 PC 同期**: 同じ Google アカウントで自動同期
- **カスタムハッシュタグ**: 独自のハッシュタグを追加可能
- **280文字チェック**: X の文字数制限を自動検出

## セットアップ（開発者向け）

### 前提

- Node.js（ローカルテスト用）
- Google Cloud Console アカウント

### Google Drive API 設定

1. **Google Cloud Console にアクセス**: https://console.cloud.google.com
2. **新規プロジェクトを作成**
3. **Google Drive API を有効化**
4. **OAuth 2.0 クライアント ID（ウェブアプリケーション）を作成**
5. **認可済みリダイレクト URI に追加**:
   - ローカルテスト: `http://localhost:8000`
   - GitHub Pages: `https://tanko628-a11y.github.io/komashop`
6. **クライアント ID を `gdrive-config.js` に設定**:
   ```javascript
   const GDRIVE_CLIENT_ID = 'YOUR_CLIENT_ID_HERE';
   const GDRIVE_API_KEY = 'YOUR_API_KEY_HERE';
   ```

### ローカルテスト

```bash
# Python 簡易サーバー起動
python -m http.server 8000

# http://localhost:8000 にアクセス
```

### デプロイ

GitHub Pages 自動デプロイ（main ブランチ push）

---

## トラブルシューティング

**「Google でログイン」ボタンが反応しない**
- gdrive-config.js が正しく設定されているか確認
- ブラウザのコンソール（F12）でエラーを確認

**Google Drive 保存に失敗**
- Google アカウントのアクセス許可を確認
- API キーの有効期限確認

**複数 PC で同期されない**
- 同じ Google アカウントでログインしているか確認
- Google Drive に `x-post-generator-state.json` ファイルが存在するか確認

---

Koma（コマ式 FX 練成会）  
2026-04-22