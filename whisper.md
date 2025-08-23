## garanta que as libs de build e Vulkan estão instaladas:
```bash
sudo apt update && sudo apt install -y \
  build-essential cmake git pkg-config \
  libopenblas-dev libssl-dev \
  libfftw3-dev libsndfile1-dev \
  vulkan-tools libvulkan-dev libshaderc-dev glslang-tools
```

## Clonar e compilar o Whisper.cpp
> cd ~

> git clone https://github.com/ggerganov/whisper.cpp.git

> cd whisper.cpp

>cmake -B build -DGGML_VULKAN=ON

>cmake --build build -j$(nproc)

## Baixar modelos do whisper
Link dos modelos:
[whisper.cpp](https://huggingface.co/ggerganov/whisper.cpp)

Mais informações em:
[whisper-models](https://github.com/ggml-org/whisper.cpp/tree/master/models)

Entre dentro do ~/whisper.cpp e execute o comando para download
> bash ./models/download-ggml-model.sh base.en

O modelo acima será salvo em:
~/whisper.cpp/models/ggml-base.en.bin

## base
bash ~/whisper.cpp/models/download-ggml-model.sh base
bash ~/whisper.cpp/models/download-ggml-model.sh base.en


### small
bash ./models/download-ggml-model.sh small
bash ./models/download-ggml-model.sh small.en

### medium
bash ./models/download-ggml-model.sh medium
bash ./models/download-ggml-model.sh medium.en

### large-v3
bash ./models/download-ggml-model.sh large-v3

## ⚡ Dicas práticas
Streaming / tempo real (voz ao vivo):
- small (multilíngue) ou small.en (só EN).

Equilíbrio entre qualidade e velocidade:
- medium (multilíngue).

Transcrição final de alta fidelidade:
- large-v3.

Testes / protótipos / máquinas fracas:
- base.

## Como usar:
### Transcrever um file.wav
```shell
~/whisper.cpp/build/bin/whisper-cli \
  -m ~/whisper.cpp/models/ggml-base.en.bin \
  -f ~/workspace/sound-tests/harvard.wav \
  -t 8 \
  --print-progress
```

```shell
~/whisper.cpp/build/bin/whisper-cli \
  -m ~/whisper.cpp/models/ggml-small.bin \
  -f ~/workspace/sound-tests/Audio_File_of_Dama_Paulista,_1808.wav \
  -t 8 \
  -l pt \
  --translate \
  --print-progress
```
