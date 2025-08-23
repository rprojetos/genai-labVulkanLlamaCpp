~/llama.cpp/build/bin/llama-server \
  -m ~/models/gemma-3-4b-it/gemma-3-4b-it-Q4_K_M.gguf \
  -c 4096 \
  -ngl 26 \
  -b 256 \
  -t 8 \
  --port 8080 \
  --host 0.0.0.0
