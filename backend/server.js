require('dotenv').config();
const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json({ limit: '20mb' }));

app.get('/health', (req, res) => {
  res.json({ ok: true, status: 'running' });
});

app.post('/api/generate', async (req, res) => {
  try {
    const { imageData, prompt, effect } = req.body || {};

    if (!imageData) {
      return res.status(400).json({ success: false, error: 'imageData est requis.' });
    }

    const apiKey = process.env.AGNES_API_KEY;
    if (!apiKey) {
      return res.status(500).json({ success: false, error: 'AGNES_API_KEY manquante.' });
    }

    const body = {
      image: imageData,
      prompt: `${effect || 'cinematic'}. ${prompt || 'Create a dramatic cinematic video with motion and lighting.'}`,
      duration: 5,
      format: 'mp4'
    };

    const response = await fetch('https://api.agnes.ai/v1/video/generate', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(body)
    });

    const data = await response.json().catch(() => ({}));

    if (!response.ok) {
      return res.status(500).json({
        success: false,
        error: data.error || 'Erreur côté API Agnes.'
      });
    }

    return res.json({
      success: true,
      video_url: data.video_url || data.url || data.output || ''
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: error.message || 'Erreur interne du serveur.'
    });
  }
});

app.listen(PORT, () => {
  console.log(`AI Studio backend running on http://localhost:${PORT}`);
});
