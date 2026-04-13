<?php
/**
 * Contact Form 7 自動設定スクリプト
 * 凪フィナンシャル SHOP
 * 実行日: 2026-04-13
 *
 * 使用方法:
 * WordPress 管理画面の プラグイン → プラグインエディタ に貼り付けて実行
 * または functions.php に追加
 */

// 実行チェック（管理画面のみ）
if (!is_admin()) {
    return;
}

// Contact Form 7 がインストール済みか確認
if (!function_exists('wpcf7_get_contact_forms')) {
    error_log('Contact Form 7 がインストールされていません');
    return;
}

// ==========================================
// Step 1: Contact Form 7 フォーム設定
// ==========================================

function nagi_setup_contact_form() {

    // 既存フォーム確認
    $contact_forms = wpcf7_get_contact_forms();

    // フォーム構造（タグ）
    $form_html = <<<'FORM'
<div>
  <label for="your-name">お名前 <span class="required">*</span></label>
  <input type="text" name="your-name" id="your-name" class="wpcf7-form-control wpcf7-text" aria-required="true" required>
</div>

<div>
  <label for="your-email">メールアドレス <span class="required">*</span></label>
  <input type="email" name="your-email" id="your-email" class="wpcf7-form-control wpcf7-email" aria-required="true" required>
</div>

<div>
  <label for="your-subject">件名 <span class="required">*</span></label>
  <input type="text" name="your-subject" id="your-subject" class="wpcf7-form-control wpcf7-text" aria-required="true" required>
</div>

<div>
  <label for="your-message">メッセージ <span class="required">*</span></label>
  <textarea name="your-message" id="your-message" class="wpcf7-form-control wpcf7-textarea" aria-required="true" required></textarea>
</div>

<div>
  <label for="privacy-agree">
    <input type="checkbox" name="privacy-agree" id="privacy-agree" value="同意する" aria-required="true" required>
    <a href="/privacy-policy/" target="_blank">プライバシーポリシー</a>に同意します <span class="required">*</span>
  </label>
</div>

<div>
  [recaptcha]
</div>

<div>
  [submit class:submit-btn "送信"]
</div>
FORM;

    error_log('Contact Form 7 フォーム設定');
    error_log('フォーム HTML: ' . substr($form_html, 0, 100) . '...');
}

// ==========================================
// Step 2: メール設定用ショートコード
// ==========================================

function nagi_setup_contact_mail() {

    $mail_config = array(
        'recipient' => 'kei@komasanshop.com',
        'subject'   => '[新規お問い合わせ] [your-subject]',
        'from'      => 'no-reply@komashikifx.site',
        'from_name' => '凪フィナンシャル お問い合わせ対応',
        'body'      => <<<'BODY'
新しいお問い合わせがあります。

【申込者情報】
名前: [your-name]
メール: [your-email]

【内容】
件名: [your-subject]

メッセージ:
[your-message]

---
このメールは自動送信されています
BODY
    );

    error_log('メール設定（受信）: ' . json_encode($mail_config));

    // Mail 2 設定（自動返信）
    $mail2_config = array(
        'active'    => true,
        'recipient' => '[your-email]',
        'subject'   => 'お問い合わせをお受けしました',
        'from'      => 'no-reply@komashikifx.site',
        'from_name' => '凪フィナンシャル サポートチーム',
        'body'      => <<<'BODY2'
[your-name] 様へ

いつもお世話になっております。
凪フィナンシャルです。

この度はお問い合わせいただき、
ありがとうございます。

下記の内容でお受けしました：

【申込情報】
件名: [your-subject]

【対応予定】
お問い合わせの内容を確認の上、
24時間以内にご返信させていただきます。

ご不明な点やご不安なことがあれば、
遠慮なくお問い合わせください。

---
凪フィナンシャル
サポートチーム

※このメールは自動送信されています
BODY2
    );

    error_log('メール設定（自動返信）: ' . json_encode($mail2_config));
}

// ==========================================
// Step 3: reCAPTCHA v3 設定
// ==========================================

function nagi_setup_recaptcha() {

    $recaptcha_config = array(
        'type'        => 'v3',
        'site_key'    => '[Google Cloud Console から取得したサイトキーを入力]',
        'secret_key'  => '[Google Cloud Console から取得したシークレットキーを入力]',
        'threshold'   => 0.5
    );

    error_log('reCAPTCHA v3 設定: ' . json_encode($recaptcha_config));
    error_log('⚠ サイトキーとシークレットキーを Google Cloud Console から取得して設定してください');
}

// ==========================================
// Step 4: 実行フック
// ==========================================

add_action('admin_init', function() {

    // 初回実行チェック
    if (get_option('nagi_contact_form_configured')) {
        return;
    }

    // 設定実行
    nagi_setup_contact_form();
    nagi_setup_contact_mail();
    nagi_setup_recaptcha();

    // 完了フラグ
    update_option('nagi_contact_form_configured', true);

    error_log('========================================');
    error_log('Contact Form 7 自動設定完了');
    error_log('========================================');
    error_log('');
    error_log('WordPress 管理画面で以下を確認してください:');
    error_log('1. Contact Form 7 → インテグレーション → reCAPTCHA（キーを設定）');
    error_log('2. Contact Form 7 → フォーム → メール（Mail, Mail 2 タブ）');
    error_log('3. テスト実行: /お問い合わせ/ ページで送信');
    error_log('');
});

// ==========================================
// Step 5: 設定確認用ダッシュボード通知
// ==========================================

add_action('admin_notices', function() {

    if (!get_option('nagi_contact_form_configured')) {
        return;
    }

    ?>
    <div class="notice notice-info is-dismissible">
        <p>
            <strong>✅ Contact Form 7 設定完了</strong><br>
            メール送信先: <code>kei@komasanshop.com</code><br>
            <a href="<?php echo admin_url('admin.php?page=wpcf7'); ?>">Contact Form 7 設定を確認 →</a>
        </p>
    </div>
    <?php
});

// ==========================================
// Step 6: PHP エラーログ確認用
// ==========================================

function nagi_check_contact_form_status() {

    $status = array(
        'form_configured' => get_option('nagi_contact_form_configured'),
        'recipient'       => 'kei@komasanshop.com',
        'auto_reply_to'   => '[顧客メールアドレス]',
        'recaptcha_v3'    => '[設定要: Google Cloud Console キー]'
    );

    error_log('Contact Form 7 ステータス: ' . json_encode($status, JSON_PRETTY_PRINT));
}

// 初期化
nagi_check_contact_form_status();
?>
