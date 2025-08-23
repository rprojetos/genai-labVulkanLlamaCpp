~/llama.cpp/build/bin/llama-server \
  -m ~/models/unsloth/Llama-3.1-8B-Instruct-GGUF/Llama-3.1-8B-Instruct-Q4_K_M.gguf \
  -c 4096 -t 8 -ngl 28 \
  --host 0.0.0.0 --port 8080 \
  --api-key p2r0o2@p2r0o2-llama-cpp

