# Projeto Levenshtein Integrado (C + Lua)

Este projeto demonstra a integração entre:
- **Linguagem C** (aplicação principal)
- **Biblioteca externa** para cálculo da distância de Levenshtein
- **Script em Lua**, que utiliza o executável em C como back-end

A proposta faz parte de um trabalho prático com o objetivo de ilustrar integração de múltiplas linguagens e reutilização de bibliotecas.

---

## 📦 Estrutura do Projeto

```
├── main.c           # Programa principal em C
├── levenshtein.c    # Biblioteca externa (editada levemente para compatibilidade)
├── levenshtein.h    # Header da biblioteca
├── script.lua       # Script Lua que executa e interpreta os resultados
├── Makefile         # Automatiza build, execução e testes
├── LICENSE          # Licença MIT da biblioteca original
└── README.md        # Este arquivo
```

---

## 🚀 Como executar

### 1. Compilar o projeto
```bash
make
```

### 2. Executar o script Lua com testes automáticos
```bash
make run
```

### 3. Rodar o programa C diretamente
```bash
./programa "string1" "string2"
```

**Exemplo:**
```bash
./programa "gato" "rato"
```

---

## 🛠️ Outras opções via Makefile

- `make` — Compila o projeto
- `make run` — Executa os testes com Lua
- `make test-c` — Executa o programa em C diretamente com exemplos
- `make quick` — Teste rápido com "hello" e "world"
- `make clean` — Remove o executável

---

## 📌 Observações

- A biblioteca externa não foi modificada, apenas implementada.
- O projeto atende todos os requisitos essenciais do trabalho prático, incluindo:
  - Integração entre C e Lua
  - Uso real de uma biblioteca externa em C
  - Execução automatizada via Makefile