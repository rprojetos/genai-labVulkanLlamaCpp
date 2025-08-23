~/llama.cpp/build/bin/llama-server \
  -m ~/models/ggml-org/Qwen2.5-Omni-3B-GGUF/Qwen2.5-Omni-3B-Q4_K_M.gguf \
  -c 4096 \
  -ngl 24 \
  --host 0.0.0.0 \
  --port 8080
