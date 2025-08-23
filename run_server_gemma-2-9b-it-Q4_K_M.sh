~/llama.cpp/build/bin/llama-server \
  -m ~/models/gemma-2-9b-it/gemma-2-9b-it-Q4_K_M.gguf \
  -ngl 22 \
  -c 4096 \
  -b 64 \
  -t 8 \
  --port 8080 \
  --host 0.0.0.0
