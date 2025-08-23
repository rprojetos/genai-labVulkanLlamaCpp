~/llama.cpp/build/bin/llama-server \
  -m ~/models/phi-3-mini/Phi-3-mini-4k-instruct-q4.gguf \
  -c 4096 \
  -ngl 40 \
  --port 8080 \
  --host 0.0.0.0