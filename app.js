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

let gapiInited = false;
let currentUser = null;

function initGAPI() {
  if (gapiInited) return;

  gapi.load('client', async () => {
    try {
      await gapi.client.init({
        apiKey: GDRIVE_API_KEY,
        clientId: GDRIVE_CLIENT_ID,
        scope: 'https://www.googleapis.com/auth/drive.file'
      });
      gapiInited = true;
      setupAuthUI();
    } catch (error) {
      console.error('GAPI init failed:', error);
    }
  });
}

function setupAuthUI() {
  const tokenClient = google.accounts.oauth2.initTokenClient({
    client_id: GDRIVE_CLIENT_ID,
    scope: 'https://www.googleapis.com/auth/drive.file',
    callback: handleAuthCallback
  });

  document.getElementById('loginBtn').addEventListener('click', () => {
    tokenClient.requestAccessToken({ prompt: 'consent' });
  });
}

function handleAuthCallback(response) {
  if (response.access_token) {
    currentUser = { name: 'User', token: response.access_token };
    document.getElementById('authSection').style.display = 'none';
    document.getElementById('appSection').style.display = 'block';
    document.getElementById('userInfo').textContent = `ログイン中`;
    setupApp();
    loadStateFromDrive();
  }
}

function setupApp() {
  document.getElementById('logoutBtnApp').addEventListener('click', logout);

  document.querySelectorAll('.hashtag-checkbox').forEach(checkbox => {
    checkbox.addEventListener('change', saveStateToDrive);
  });

  ['entryPrice', 'exitPrice', 'instrument', 'direction', 'customHashtags'].forEach(id => {
    document.getElementById(id).addEventListener('change', saveStateToDrive);
  });

  document.getElementById('generateBtn').addEventListener('click', generatePosts);
}

function getState() {
  return {
    entryPrice: document.getElementById('entryPrice').value,
    exitPrice: document.getElementById('exitPrice').value,
    instrument: document.getElementById('instrument').value,
    direction: document.getElementById('direction').value,
    customHashtags: document.getElementById('customHashtags').value,
    selectedHashtags: Array.from(document.querySelectorAll('.hashtag-checkbox:checked')).map(cb => cb.value),
    timestamp: new Date().toISOString()
  };
}

function setState(state) {
  if (!state) return;
  document.getElementById('entryPrice').value = state.entryPrice || '';
  document.getElementById('exitPrice').value = state.exitPrice || '';
  document.getElementById('instrument').value = state.instrument || 'GOLD';
  document.getElementById('direction').value = state.direction || 'LONG';
  document.getElementById('customHashtags').value = state.customHashtags || '';

  state.selectedHashtags?.forEach(value => {
    const checkbox = document.querySelector(`input[value="${value}"]`);
    if (checkbox) checkbox.checked = true;
  });
}

async function saveStateToDrive() {
  if (!currentUser) return;

  const state = getState();
  updateSaveStatus('saving', '保存中...');

  try {
    const fileList = await gapi.client.drive.files.list({
      q: "name='x-post-generator-state.json' and trashed=false",
      spaces: 'drive',
      pageSize: 1
    });

    const fileName = 'x-post-generator-state.json';
    const fileBody = new Blob([JSON.stringify(state, null, 2)], { type: 'application/json' });

    if (fileList.result.files && fileList.result.files.length > 0) {
      await gapi.client.drive.files.update({
        fileId: fileList.result.files[0].id,
        media: new gapi.client.drive.Resource({ body: fileBody })
      }, { media: fileBody });
    } else {
      await gapi.client.drive.files.create({
        resource: { name: fileName, mimeType: 'application/json' },
        media: fileBody,
        fields: 'id'
      });
    }

    updateSaveStatus('saved', '✓ 保存完了');
    setTimeout(() => updateSaveStatus('', ''), 3000);
  } catch (error) {
    console.error('Save failed:', error);
    updateSaveStatus('error', 'エラー：保存失敗');
  }
}

async function loadStateFromDrive() {
  if (!currentUser) return;

  try {
    const fileList = await gapi.client.drive.files.list({
      q: "name='x-post-generator-state.json' and trashed=false",
      spaces: 'drive',
      pageSize: 1
    });

    if (fileList.result.files && fileList.result.files.length > 0) {
      const fileId = fileList.result.files[0].id;
      const response = await gapi.client.drive.files.get({
        fileId: fileId,
        alt: 'media'
      });

      setState(response.result);
    }
  } catch (error) {
    console.error('Load failed:', error);
  }
}

function updateSaveStatus(status, text) {
  const element = document.getElementById('saveStatus');
  element.className = 'save-status ' + status;
  element.textContent = text;
}

function generatePosts() {
  const entry = document.getElementById('entryPrice').value || '0';
  const exit = document.getElementById('exitPrice').value || '0';
  const instrument = document.getElementById('instrument').value;
  const customHashtags = document.getElementById('customHashtags').value.trim();

  const pips = Math.round((parseFloat(exit) - parseFloat(entry)) * 100);

  const selectedHashtags = Array.from(document.querySelectorAll('.hashtag-checkbox:checked'))
    .map(cb => cb.value)
    .join(' ');

  const recommendedHashtags = '#コマ式FX練成会 #Koma_Ultimate #複数指標検証';

  const allHashtags = [selectedHashtags, recommendedHashtags, customHashtags]
    .filter(tag => tag.length > 0)
    .join(' ');

  const container = document.getElementById('postsContainer');
  container.innerHTML = '';

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

  saveStateToDrive();
}

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

function logout() {
  google.accounts.id.revoke(currentUser?.email, () => {
    currentUser = null;
    document.getElementById('authSection').style.display = 'block';
    document.getElementById('appSection').style.display = 'none';
    document.getElementById('postsContainer').innerHTML = '';
  });
}

document.addEventListener('DOMContentLoaded', () => {
  if (typeof gapi !== 'undefined') {
    initGAPI();
  }
});
