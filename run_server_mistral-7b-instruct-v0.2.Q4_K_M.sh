~/llama.cpp/build/bin/llama-server \
  -m ~/models/mistral-7b/mistral-7b-instruct-v0.2.Q4_K_M.gguf \
  -c 4096 \
  -ngl 30 \
  --port 8080 \
  --host 0.0.0.0