# genai-labVulkanLlamaCpp
**Ubuntu 20.04 LTS**

Utilização do vulkan com llama.cpp

### 1) Habilite o universe (se ainda não estiver)
sudo add-apt-repository universe
sudo apt update

### 2) Instale o compilador de shaders + headers/libs
sudo apt install -y glslc libshaderc-dev glslang-tools libvulkan-dev mesa-vulkan-drivers

### 3) Verificando se o vulkan esta ativo e glslc version
> vulkaninfo | grep apiVersion

> which glslc && glslc --version

### 4) Baixe e compile o llama.cpp com Vulkan
> git clone https://github.com/ggerganov/llama.cpp

> cd llama.cpp

> cd ~/llama.cpp

> cmake -B build -DGGML_VULKAN=ON

> cmake --build build --config Release -j"$(nproc)"

## huggingface-cli com token
### Versão python para instalar o huggingface_hub
Os pacotes huggingface são instalados utilizando o gerenciador de pacotes pip.

O gerenciamento da versão Python a ser utilizada pode ser utilizando o pyenv.

Segue link com o passo a passo:
[pyenv](https://github.com/rprojetos/genai-pyenv)

### Instalação do huggingface_hub

Crie um token em: https://huggingface.co/settings/tokens (Scope: “Read”)
No terminal:

> python3 -m pip install -U huggingface_hub

### Autenticação com huggingface-cli

> huggingface-cli login 

"vai ser solicitado então o token-gerado-no-huggingface"

## Monitoramento da GPU
### 1. radeontop (Mais popular):
> sudo apt install radeontop

## Comando para rodar com llama.cpp + Vulkan no prompt:

```bash
~/llama.cpp/build/bin/llama-cli \
-m ~/models/phi-3-mini/Phi-3-mini-4k-instruct-q4.gguf \
-ngl 40 -n 50 \
-p "Explique em uma frase o que é aprendizado de máquina."
```

- -ngl = "Number of GPU Layers"
- -n = "number of tokens" máximo de tokens (palavras/pedaços de palavra) que o modelo vai gerar na resposta

## Comando para rodar com llama.cpp + Vulkan no servidor:
### Exemplo com Phi-3 Mini
```bash
~/llama.cpp/build/bin/llama-server \
  -m ~/models/phi-3-mini/Phi-3-mini-4k-instruct-q4.gguf \
  -c 4096 \
  -ngl 40 \
  --port 8080 \
  --host 0.0.0.0
```

Onde:
- -m → caminho do modelo.
- -c 4096 → contexto (tokens que o modelo consegue "lembrar" na janela). 

Recomendo colocar explicitamente.
- -ngl 40 → número de camadas offloaded para a GPU (se sua RX580 aguentar).
- --port 8080 → porta da API.
- --host 0.0.0.0 → expõe em todas as interfaces de rede.


### Para modelos maiores, ajuste -ngl (número de camadas na GPU)
```bash
~/llama.cpp/build/llama-server -m ~/models/mistral-7b/mistral-7b-instruct-v0.2.Q4_K_M.gguf -ngl 32 --port 8080
```

### Parâmetros importantes:

#### -ngl (Number of GPU Layers)
- -ngl: número de camadas na GPU (comece com 35, ajuste conforme necessário)
- Monitore o uso de VRAM com radeontop ou gpu-viewer
Se estourar VRAM, diminua o -ngl

- Recomendo começar com o Phi-3 Mini para testar sua configuração, depois partir para o Mistral 7B se quiser mais qualidade!

Valores típicos para RX 580 8GB:

- Phi-3 Mini: -ngl 35-40
- Mistral 7B Q4: -ngl 28-32
- Llama 3.1 8B Q4: -ngl 25-30

#### -n (number of tokens)
Recomendações:
- Para uma frase
    > -n 30

- Para um parágrafo  
    > -n 100

- Para explicação detalhada
    > -n 500

- Para ensaio/artigo
    > -n 1000

- Para resposta máxima possível
    > -n -1


## Baixar modelos
### 1. Phi-3 Mini (Melhor custo-benefício):
- ~2-3GB VRAM
- Excelente qualidade para o tamanho
- Roda muito bem no Vulkan

    > huggingface-cli download microsoft/Phi-3-mini-4k-instruct-gguf --local-dir ~/models/phi-3-mini

### 2. Llama 3.2 3B:
- ~2-3GB VRAM
- Muito boa qualidade

    > huggingface-cli download hugging-quants/Llama-3.2-3B-Instruct-Q4_K_M-GGUF --local-dir ~/models/llama-3.2-3b

### 3. Mistral 7B (Aproveitando os 8GB):
- ~5-6GB VRAM (Q4_K_M)
- Excelente qualidade geral

    > huggingface-cli download TheBloke/Mistral-7B-Instruct-v0.2-GGUF --local-dir ~/models/mistral-7b

### 4. Llama 3.1 8B (Máximo da sua GPU):
- ~6-7GB VRAM
- Estado da arte, mas pode ser mais lento

    > huggingface-cli download hugging-quants/Meta-Llama-3.1-8B-Instruct-Q4_K_M-GGUF --local-dir ~/models/llama-3.1-8b


### 5. gemma-3-4b-it-Q4_K_M.gguf

```bash
huggingface-cli download tensorblock/gemma-3-4b-it-GGUF \
  --include "gemma-3-4b-it-Q4_K_M.gguf" \
  --local-dir ~/models/gemma-3-4b-it

```

## Interagindo com os modelos via API

### Instruction/Chat Models:
use: /v1/chat/completions
geralmente no nome do llm tem "instruct", "chat" ou "it"

```bash
curl -X POST http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {
        "role": "user", 
        "content": "Explique em uma frase o que é aprendizado de máquina."
      }
    ],
    "max_tokens": 100,
    "temperature": 0.7
  }'
```

### Para modelos base (sem instruct):
Use o endpoint /completion

```bash
curl -X POST http://localhost:8080/completion \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "A inteligência artificial é",
    "n_predict": 50,
    "temperature": 0.7
  }'
```

## Acessando de outra máquina na rede:
http://<ip-maquina-rodando-llama-server>:<port>
http://192.168.0.50:8080

Atenção:
- verifique o ip com ifconfig
- use: http para acesso na rede local

Usando API em outra máquina na rede:

```bash
curl -X POST http://192.168.0.50:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "phi-3-mini-4k-instruct-q4",
    "messages": [
      {"role": "user", "content": "Explique em uma frase o que é aprendizado de máquina."}
    ],
    "max_tokens": 100,
    "temperature": 0.7
  }'

```
