~/llama.cpp/build/bin/llama-server \
  -m ~/models/unsloth/Qwen2.5-Omni-7B-GGUF/Qwen2.5-Omni-7B-Q4_K_M.gguf \
  -c 4096 \
  -ngl 28 \
  --host 0.0.0.0 \
  --port 8080
