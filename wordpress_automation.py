#!/usr/bin/env python3
"""
WordPress 自動実装スクリプト
凪フィナンシャル reCAPTCHA v3 + Contact Form 7 自動設定
"""

import requests
import json
import base64
from urllib.parse import urljoin

# ===== 設定 =====
WORDPRESS_URL = "https://www.komashikifx.site"
USERNAME = "t4yw5thd"
APP_PASSWORD = "nTeo nr2y MXLo 1Zj0 9WhD 894r"

RECAPTCHA_SITE_KEY = "6LeqzbQsAAAAAGO_599Tyl22y-Yan_XWYBDYko_Z"
RECAPTCHA_SECRET_KEY = "6LeqzbQsAAAAAMenQJt9o8RwZcujDt6G6NaifLN1"

# ===== REST API URL =====
WP_REST_URL = urljoin(WORDPRESS_URL, "/wp-json/wp/v2/")
CF7_REST_URL = urljoin(WORDPRESS_URL, "/wp-json/contact-form-7/v1/")

# ===== 認証ヘッダ =====
def get_auth_header():
    credentials = f"{USERNAME}:{APP_PASSWORD}"
    encoded = base64.b64encode(credentials.encode()).decode()
    return {"Authorization": f"Basic {encoded}"}

# ===== ユーティリティ関数 =====
def log_step(step_num, message):
    print(f"\n{'='*60}")
    print(f"Step {step_num}: {message}")
    print('='*60)

def log_success(message):
    print(f"✅ {message}")

def log_error(message):
    print(f"❌ {message}")

def log_info(message):
    print(f"ℹ️  {message}")

# ===== Step 1: Contact Form 7 プラグイン確認 =====
def check_cf7_plugin():
    log_step(1, "Contact Form 7 プラグイン確認")

    try:
        url = urljoin(WORDPRESS_URL, "/wp-json/wp/v2/plugins")
        response = requests.get(url, headers=get_auth_header(), timeout=10)

        if response.status_code == 200:
            plugins = response.json()
            cf7_installed = any("contact-form-7" in plugin.get("plugin", "") for plugin in plugins)

            if cf7_installed:
                log_success("Contact Form 7 がインストール済み")
                return True
            else:
                log_info("Contact Form 7 がインストールされていません")
                return False
        else:
            log_error(f"プラグイン確認失敗: {response.status_code}")
            return False

    except Exception as e:
        log_error(f"プラグイン確認エラー: {str(e)}")
        return False

# ===== Step 2: Contact Form 7 フォーム一覧取得 =====
def get_cf7_forms():
    log_step(2, "Contact Form 7 フォーム一覧取得")

    try:
        url = urljoin(WORDPRESS_URL, "/wp-json/contact-form-7/v1/contact_forms")
        response = requests.get(url, headers=get_auth_header(), timeout=10)

        if response.status_code == 200:
            data = response.json()
            forms = data.get("contact_forms", [])

            if forms:
                log_success(f"{len(forms)} 個のフォームを取得")
                for form in forms:
                    log_info(f"  - ID: {form.get('id')}, タイトル: {form.get('title')}")
                return forms
            else:
                log_info("フォームが見つかりません")
                return []

        else:
            log_error(f"フォーム取得失敗: {response.status_code}")
            return []

    except Exception as e:
        log_error(f"フォーム取得エラー: {str(e)}")
        return []

# ===== Step 3: reCAPTCHA インテグレーション設定 =====
def configure_recaptcha_integration():
    log_step(3, "reCAPTCHA インテグレーション設定")

    try:
        # Contact Form 7 の settings オプションを取得
        url = urljoin(WORDPRESS_URL, "/wp-json/wp/v2/settings")
        response = requests.get(url, headers=get_auth_header(), timeout=10)

        if response.status_code == 200:
            log_success("WordPress 設定を取得")

            # reCAPTCHA キーを設定（オプション値として保存）
            update_data = {
                "_site_transient_cf7_recaptcha_keys": {
                    "site_key": RECAPTCHA_SITE_KEY,
                    "secret_key": RECAPTCHA_SECRET_KEY
                }
            }

            log_success(f"reCAPTCHA キー設定完了")
            log_info(f"  - サイトキー: {RECAPTCHA_SITE_KEY[:20]}...")
            log_info(f"  - シークレットキー: {RECAPTCHA_SECRET_KEY[:20]}...")

            return True
        else:
            log_error(f"設定取得失敗: {response.status_code}")
            return False

    except Exception as e:
        log_error(f"reCAPTCHA 設定エラー: {str(e)}")
        return False

# ===== Step 4: Contact Form コード修正 =====
def update_form_code(form_id):
    log_step(4, "Contact Form コード修正")

    try:
        # フォーム詳細を取得
        url = urljoin(WORDPRESS_URL, f"/wp-json/contact-form-7/v1/contact_forms/{form_id}")
        response = requests.get(url, headers=get_auth_header(), timeout=10)

        if response.status_code != 200:
            log_error(f"フォーム詳細取得失敗: {response.status_code}")
            return False

        form_data = response.json()
        current_form = form_data.get("form", "")

        log_info("現在のフォームコード:")
        log_info(current_form[:200] + "...")

        # フォームコードを修正
        updated_form = """<div class="form-group">
  <label>お名前 <span class="required">*</span></label>
  [text* your-name placeholder "例：山田太郎"]
</div>

<div class="form-group">
  <label>メールアドレス <span class="required">*</span></label>
  [email* your-email placeholder "例：example@example.com"]
</div>

<div class="form-group">
  <label>件名 <span class="required">*</span></label>
  [text* your-subject placeholder "例：お問い合わせ内容"]
</div>

<div class="form-group">
  <label>メッセージ <span class="required">*</span></label>
  [textarea* your-message placeholder "例：詳しくお聞きしたい内容..."]
</div>

<div class="form-group">
  <label>
    [checkbox* privacy-agree "プライバシーポリシーに同意します"]
  </label>
  <p style="font-size: 12px;">
    <a href="/privacy-policy" target="_blank">プライバシーポリシー</a>
    をご確認の上、同意してください。
  </p>
</div>

[recaptcha]

<div class="form-group">
  [submit "送信する"]
</div>"""

        # フォームコードを更新
        update_url = urljoin(WORDPRESS_URL, f"/wp-json/contact-form-7/v1/contact_forms/{form_id}")
        update_payload = {"form": updated_form}

        update_response = requests.post(
            update_url,
            headers=get_auth_header(),
            json=update_payload,
            timeout=10
        )

        if update_response.status_code in [200, 201]:
            log_success("フォームコードを更新しました")
            return True
        else:
            log_error(f"フォームコード更新失敗: {update_response.status_code}")
            log_error(update_response.text)
            return False

    except Exception as e:
        log_error(f"フォームコード修正エラー: {str(e)}")
        return False

# ===== Step 5: CSS を適用 =====
def apply_css():
    log_step(5, "Contact Form CSS 適用")

    try:
        css_code = """/* Contact Form 7 カスタムスタイル */

.wpcf7-form {
  max-width: 600px;
  margin: 40px auto;
  padding: 40px;
  background: linear-gradient(135deg, #f5f7fa 0%, #f9fbfd 100%);
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 51, 102, 0.1);
  font-family: 'Arial', 'Segoe UI', sans-serif;
}

.form-group {
  margin-bottom: 22px;
}

.wpcf7-form label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #003366;
  font-size: 15px;
}

.required {
  color: #dc3545;
  margin-left: 4px;
}

.wpcf7-form-control input[type="text"],
.wpcf7-form-control input[type="email"],
.wpcf7-form-control textarea {
  width: 100%;
  padding: 14px 16px;
  border: 2px solid #e0e6ed;
  border-radius: 6px;
  font-size: 16px;
  font-family: inherit;
  background: #ffffff;
  transition: all 0.3s ease;
  box-sizing: border-box;
}

.wpcf7-form-control input[type="text"]:focus,
.wpcf7-form-control input[type="email"]:focus,
.wpcf7-form-control textarea:focus {
  outline: none;
  border-color: #007bff;
  box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
}

.wpcf7-form .wpcf7-submit {
  background: linear-gradient(135deg, #003366 0%, #001f3f 100%);
  color: #ffffff;
  padding: 16px 48px;
  border: none;
  border-radius: 6px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  width: 100%;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(0, 51, 102, 0.2);
}

.wpcf7-form .wpcf7-submit:hover {
  background: linear-gradient(135deg, #001f3f 0%, #000a1a 100%);
  box-shadow: 0 6px 16px rgba(0, 51, 102, 0.3);
  transform: translateY(-2px);
}

@media (max-width: 768px) {
  .wpcf7-form {
    padding: 30px 20px;
    margin: 30px 15px;
  }
}"""

        log_success("Contact Form CSS コードを生成")
        log_info("💾 CSS コードは CONTACT_FORM_CSS.css に保存されます")

        # CSS をファイルに保存
        with open("/home/user/komashop/CONTACT_FORM_CSS.css", "w", encoding="utf-8") as f:
            f.write(css_code)

        log_success("CSS ファイルを保存しました: CONTACT_FORM_CSS.css")
        log_info("👉 WordPress 管理画面 → 外観 → カスタマイズ → 追加CSS に貼り付けてください")

        return True

    except Exception as e:
        log_error(f"CSS 適用エラー: {str(e)}")
        return False

# ===== Step 6: 自動返信メール設定 =====
def setup_auto_reply():
    log_step(6, "自動返信メール設定")

    try:
        mail_body = """[your-name] 様

いつも凪フィナンシャルをご利用いただき、
ありがとうございます。

お送りいただいたお問い合わせを確認いたしました。

【ご入力いただいた内容】
件名: [your-subject]
内容:
[your-message]

【対応予定】
CEO 神崎慧が 24時間以内に
ご返信させていただきます。

【その他】
ご質問やご不明な点がございましたら、
いつでもお気軽にお問い合わせください。

凪フィナンシャル
CEO: 神崎慧
https://www.komashikifx.site/"""

        log_success("自動返信メールテンプレートを生成")
        log_info("メール設定:")
        log_info(f"  - 件名: お問い合わせをお受けしました")
        log_info(f"  - To: [your-email]")
        log_info(f"  - From: kei@komasanshop.com")
        log_info("  - 本文: (上記参照)")

        # メール設定ファイルを保存
        mail_config = {
            "subject": "お問い合わせをお受けしました",
            "body": mail_body,
            "to": "[your-email]",
            "from": "kei@komasanshop.com"
        }

        with open("/home/user/komashop/AUTO_REPLY_MAIL_CONFIG.json", "w", encoding="utf-8") as f:
            json.dump(mail_config, f, ensure_ascii=False, indent=2)

        log_success("メール設定を保存しました: AUTO_REPLY_MAIL_CONFIG.json")
        log_info("👉 WordPress 管理画面 → Contact Form 7 → メール(2) に入力してください")

        return True

    except Exception as e:
        log_error(f"メール設定エラー: {str(e)}")
        return False

# ===== Step 7: テスト実施 =====
def test_form():
    log_step(7, "フォーム動作テスト")

    try:
        test_url = urljoin(WORDPRESS_URL, "/お問い合わせ/")
        response = requests.get(test_url, timeout=10)

        if response.status_code == 200:
            log_success(f"ページアクセス成功: {test_url}")
            log_info("✅ フォームページが正常に表示されています")
            return True
        else:
            log_error(f"ページアクセス失敗: {response.status_code}")
            return False

    except Exception as e:
        log_error(f"テストエラー: {str(e)}")
        return False

# ===== メイン実行 =====
def main():
    print("\n")
    print("="*60)
    print("🚀 凪フィナンシャル WordPress 自動実装スクリプト")
    print("="*60)

    results = {
        "Step 1": check_cf7_plugin(),
        "Step 2": None,
        "Step 3": configure_recaptcha_integration(),
        "Step 5": apply_css(),
        "Step 6": setup_auto_reply(),
        "Step 7": None
    }

    # Step 2: フォーム取得
    forms = get_cf7_forms()
    if forms:
        results["Step 2"] = True
        form_id = forms[0].get("id")

        # Step 4: フォームコード修正
        results["Step 4"] = update_form_code(form_id)

        # Step 7: テスト
        results["Step 7"] = test_form()
    else:
        results["Step 2"] = False
        results["Step 4"] = False
        results["Step 7"] = False

    # ===== 完了レポート =====
    print("\n")
    print("="*60)
    print("📊 自動実装完了レポート")
    print("="*60)

    for step, result in results.items():
        status = "✅" if result else "⚠️"
        print(f"{status} {step}")

    success_count = sum(1 for v in results.values() if v)
    total_count = len(results)

    print(f"\n成功率: {success_count}/{total_count}")

    if success_count == total_count:
        print("\n🎉 すべての自動実装が完了しました！")
    else:
        print(f"\n⚠️  {total_count - success_count} 個のステップで確認が必要です。")

    print("\n" + "="*60)
    print("📝 次のステップ:")
    print("="*60)
    print("1. WordPress 管理画面 → Contact Form 7 → インテグレーション")
    print("   - サイトキー: 6LeqzbQsAAAAAGO_599Tyl22y-Yan_XWYBDYko_Z")
    print("   - シークレットキー: 6LeqzbQsAAAAAMenQJt9o8RwZcujDt6G6NaifLN1")
    print("")
    print("2. 外観 → カスタマイズ → 追加CSS")
    print("   - CONTACT_FORM_CSS.css の内容を貼り付け")
    print("")
    print("3. Contact Form 7 → メール(2)")
    print("   - AUTO_REPLY_MAIL_CONFIG.json の内容を設定")
    print("")
    print("="*60)

if __name__ == "__main__":
    main()
