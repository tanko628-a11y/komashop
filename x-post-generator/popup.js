// パターンテンプレート
const patterns = {
  1: (instrument, entry, exit, pips, hashtags) =>
    `${instrument} M5 LONG ${entry}→${exit} +${pips}pips確保。黄色矢印で方向感確認、VWAP付近でシグナル待機、Laguerre RSIでタイミング最適化。順張りの基本を貫いた結果。#MT4 #FX ${hashtags}`,
  2: (instrument, entry, exit, pips, hashtags) =>
    `朝のトレード。方向感→黄色矢印で確認。エントリー→VWAP付近で待機。タイミング→Laguerre RSIで検出。決済→+${pips}pips。順張りに徹することの重要性を再確認。#MT4 #FX ${hashtags}`,
  3: (instrument, entry, exit, pips, hashtags) =>
    `${instrument} +${pips}pips。このトレードから学べるのは、黄色・ピンク矢印の方向感確認がいかに重要かということ。VWAP付近でのエントリーと、Laguerre RSIでのタイミング検出が勝率を左右する。#MT4 #FX ${hashtags}`,
  4: (instrument, entry, exit, pips, hashtags) =>
    `多くのトレーダーが見落としている。黄色・ピンク矢印で方向感を確認する重要性。VWAP付近からのエントリー、Laguerre RSIでのタイミング。この3つを実行できれば、${instrument} M5で+${pips}pipsは現実的。#MT4 #FX ${hashtags}`,
  5: (instrument, entry, exit, pips, hashtags) =>
    `基本ルール検証：黄色矢印→VWAP付近→Laguerre RSI→順張り。この流れで ${instrument} M5 LONG ${entry}→${exit} +${pips}pips。毎回同じ手法で利益が出ることが、トレードの信頼度を高める。#MT4 #FX ${hashtags}`
};

const titles = {
  1: 'パターン 1：実績先行型',
  2: 'パターン 2：プロセス重視型',
  3: 'パターン 3：学び抽出型',
  4: 'パターン 4：問題提起型（推奨）',
  5: 'パターン 5：検証報告型'
};

// ハッシュタグチェックボックスの変更を監視
document.querySelectorAll('.hashtag-checkbox').forEach(checkbox => {
  checkbox.addEventListener('change', saveState);
});

// 入力フィールドの変更を監視
['entryPrice', 'exitPrice', 'instrument', 'direction', 'customHashtags'].forEach(id => {
  document.getElementById(id).addEventListener('change', saveState);
});

// 状態を chrome.storage.sync に保存
function saveState() {
  const state = {
    entryPrice: document.getElementById('entryPrice').value,
    exitPrice: document.getElementById('exitPrice').value,
    instrument: document.getElementById('instrument').value,
    direction: document.getElementById('direction').value,
    customHashtags: document.getElementById('customHashtags').value,
    selectedHashtags: Array.from(document.querySelectorAll('.hashtag-checkbox:checked')).map(cb => cb.value)
  };
  chrome.storage.sync.set({ appState: state });
}

// 状態を chrome.storage.sync から復元
function loadState() {
  chrome.storage.sync.get(['appState'], (result) => {
    if (result.appState) {
      const state = result.appState;
      document.getElementById('entryPrice').value = state.entryPrice || '';
      document.getElementById('exitPrice').value = state.exitPrice || '';
      document.getElementById('instrument').value = state.instrument || 'GOLD';
      document.getElementById('direction').value = state.direction || 'LONG';
      document.getElementById('customHashtags').value = state.customHashtags || '';

      // チェックボックスを復元
      state.selectedHashtags?.forEach(value => {
        const checkbox = document.querySelector(`input[value="${value}"]`);
        if (checkbox) checkbox.checked = true;
      });
    }
  });
}

// ページ読み込み時に状態を復元
loadState();

// 投稿文生成
document.getElementById('generateBtn').addEventListener('click', () => {
  const entry = document.getElementById('entryPrice').value || '0';
  const exit = document.getElementById('exitPrice').value || '0';
  const instrument = document.getElementById('instrument').value;
  const customHashtags = document.getElementById('customHashtags').value.trim();

  const pips = Math.round((parseFloat(exit) - parseFloat(entry)) * 100);

  // 選択されたハッシュタグを取得
  const selectedHashtags = Array.from(document.querySelectorAll('.hashtag-checkbox:checked'))
    .map(cb => cb.value)
    .join(' ');

  // 推奨ハッシュタグ
  const recommendedHashtags = '#コマ式FX練成会 #Koma_Ultimate #複数指標検証';

  // 全てのハッシュタグを統合
  const allHashtags = [selectedHashtags, recommendedHashtags, customHashtags]
    .filter(tag => tag.length > 0)
    .join(' ');

  const container = document.getElementById('postsContainer');
  container.innerHTML = '';

  // 5パターン全て生成
  for (let i = 1; i <= 5; i++) {
    const post = patterns[i](instrument, entry, exit, pips, allHashtags);
    const charCount = post.length;
    const isBeyondLimit = charCount > 280;

    const card = document.createElement('div');
    card.className = 'post-card' + (i === 4 ? ' recommended' : '');

    card.innerHTML = `
      <div class="post-header">
        <h3>${titles[i]}</h3>
        <div class="post-actions">
          <span class="char-count ${isBeyondLimit ? 'over-limit' : ''}">${charCount}/280</span>
          <button class="btn-copy" onclick="copyPost(this)">コピー</button>
        </div>
      </div>
      <div class="post-text" data-post="${post.replace(/"/g, '&quot;')}">${post}</div>
    `;

    container.appendChild(card);
  }

  // 状態を保存
  saveState();
});

// コピー機能
function copyPost(button) {
  const postDiv = button.closest('.post-card').querySelector('.post-text');
  const text = postDiv.getAttribute('data-post');
  navigator.clipboard.writeText(text).then(() => {
    const originalText = button.textContent;
    button.textContent = 'コピー済み!';
    setTimeout(() => {
      button.textContent = originalText;
    }, 2000);
  });
}
