MODEL=~/models/OuteAI/OuteTTS-1.0-0.6B-GGUF/OuteTTS-1.0-0.6B-Q4_K_M.gguf
cd ~/llama.cpp  # ajuste se o path for outro

# (opcional) se tiver um speaker PT-BR de ~10–15s:
SPEAKER=~/speaker_ptbr.json   # remova a linha --tts-speaker-file abaixo se não tiver

# Gera o áudio (chunking padrão ligado; bom para latência)
./build/bin/llama-tts-outetts-v1 \
  -m "$MODEL" \
  -p "Olá! Este é um teste em português do Brasil. Hello! This is a quick English test." \
  --tts-speaker-file "$SPEAKER"

# Reproduz o último WAV gerado (o exemplo TTS salva o arquivo no diretório atual)
ffplay -nodisp -autoexit "$(ls -1t *.wav | head -1)"
