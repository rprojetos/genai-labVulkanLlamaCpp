~/llama.cpp/build/bin/llama-server \
  -m ~/models/gemma-3n-E4B-it-Q4_K_M/gemma-3n-E4B-it-Q4_K_M.gguf \
  -c 4096 \
  -ngl 26 \
  -b 256 \
  -t 8 \
  --port 8080 \
  --host 0.0.0.0
