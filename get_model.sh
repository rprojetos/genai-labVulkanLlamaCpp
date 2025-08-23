#!/usr/bin/env bash
# Uso:
#   ./get_model.sh <repo_id> [include_glob]
# Exemplo:
#   ./get_model.sh OuteAI/OuteTTS-1.0-0.6B-GGUF "*.gguf"
#   ./get_model.sh microsoft/Phi-3-mini-4k-instruct-gguf "Phi-3-mini-4k-instruct-q4.gguf"
#   ./get_model.sh OuteAI/OuteTTS-1.0-0.6B-GGUF ALL

set -euo pipefail

REPO_ID="${1:-}"
INCLUDE="${2:-"*.gguf"}"    # padrão: só arquivos .gguf
PYVER="3.11.13"

if [[ -z "$REPO_ID" ]]; then
  echo "ERRO: informe o <repo_id>, ex.: OuteAI/OuteTTS-1.0-0.6B-GGUF"
  exit 1
fi

# ---- Mostrar progresso do HF Hub ----
# (garante que as barras não sejam suprimidas)
export HF_HUB_DISABLE_PROGRESS_BARS=0
export HF_HUB_VERBOSITY=info
export PYTHONUNBUFFERED=1

# 1) Inicializa pyenv
export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
export PATH="$PYENV_ROOT/bin:$PATH"
if ! command -v pyenv >/dev/null 2>&1; then
  echo "ERRO: pyenv não encontrado em $PYENV_ROOT."
  exit 1
fi
eval "$(pyenv init -)"

# 2) Seleciona Python
pyenv install -s "$PYVER"
export PYENV_VERSION="$PYVER"

# 3) CLI HF + rehash
pyenv exec python -m pip install -U pip >/dev/null
pyenv exec pip install -U "huggingface_hub[cli]" >/dev/null
pyenv rehash

# 4) Decide CLI (prefere 'hf')
CLI=""
if pyenv which hf >/dev/null 2>&1; then
  CLI="hf"
elif pyenv which huggingface-cli >/dev/null 2>&1; then
  CLI="huggingface-cli"
else
  echo "ERRO: nem 'hf' nem 'huggingface-cli' encontrados no Python $PYVER."
  exit 1
fi

# 5) Destino
TARGET_DIR="$HOME/models/$REPO_ID"
mkdir -p "$TARGET_DIR"

# 6) Flags de include
INC_FLAGS=()
if [[ "$INCLUDE" != "ALL" ]]; then
  INC_FLAGS=(--include "$INCLUDE")
fi

# 7) Download COM PROGRESSO (sem --quiet)
echo "Baixando $REPO_ID para $TARGET_DIR (Python $PYVER via pyenv; CLI='$CLI')…"

# Força *line buffering* para a saída aparecer em tempo real
stdbuf -oL -eL pyenv exec "$CLI" download "$REPO_ID" \
  "${INC_FLAGS[@]}" \
  --local-dir "$TARGET_DIR"

echo
echo "✅ Concluído:"
echo "   $TARGET_DIR"
