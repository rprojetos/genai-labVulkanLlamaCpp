~/llama.cpp/build/bin/llama-server \
  -m ~/models/unsloth/Llama-3.1-8B-Instruct-GGUF/Llama-3.1-8B-Instruct-Q4_K_M.gguf \
  -c 4096 \
  -ngl 28 \
  --host 0.0.0.0 \
  --port 8080
  