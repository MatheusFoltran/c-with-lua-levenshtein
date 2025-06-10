# Projeto Levenshtein Integrado (C + Lua)

Este projeto demonstra **três níveis de integração** entre linguagens de programação:

1. **C → C**: Uso direto de biblioteca externa em C
2. **C → Lua**: Interpretador Lua embarcado em aplicação C
3. **Lua → C**: Script Lua estendido com funções C nativas

O objetivo é ilustrar como diferentes linguagens podem trabalhar juntas, aproveitando as vantagens de cada uma: **performance do C** para algoritmos críticos e **flexibilidade do Lua** para lógica de controle e processamento de dados.

---

## 📦 Estrutura do Projeto

```
├── main.c          # Programa principal em C (todos os níveis de integração)
├── levenshtein.c   # Biblioteca externa para distância de Levenshtein
├── levenshtein.h   # Header da biblioteca externa
├── script.lua      # Script Lua que usa funções C registradas
├── Makefile        # Automatiza compilação e execução
├── src/            # Código-fonte do interpretador Lua
├── LICENSE         # Licença MIT (da biblioteca original)
└── README.md       # Este arquivo
```

---

## 🔧 Níveis de Integração Implementados

### **Nível 1: C → C (Biblioteca Externa)**
- Programa principal em C usa biblioteca externa `levenshtein.c`
- Demonstra integração direta entre módulos C
- **Execução**: `./programa "string1" "string2"`

### **Nível 2: C → Lua (Interpretador Embarcado)**
- Aplicação C embarca interpretador Lua completo
- Script Lua executa dentro do processo C
- **Execução**: `./programa` (sem argumentos)

### **Nível 3: Lua → C (Extensão Nativa)**
- Funções C são registradas no ambiente Lua
- Script Lua chama funções C como se fossem nativas
- **Execução**: Automática quando roda o script Lua

---

## 🚀 Como Executar

### **Compilação**
```bash
make
```

### **Execução Completa (Demonstração de Todos os Níveis)**
```bash
make run
```
Este comando executa:
1. Teste direto C → C com exemplos
2. Teste completo C → Lua → C com múltiplos casos

### **Execução por Nível**

#### **Modo C Direto (Nível 1)**
```bash
./programa "gato" "rato"
./programa "hello" "world"
./programa "casa" "carro"
```

#### **Modo Lua Embarcado (Níveis 2+3)**
```bash
./programa
```
Executa o script Lua com:
- 13 casos de teste automatizados
- Cálculos estatísticos (média, menor, maior distância)
- Ranking de similaridade entre strings
- Validação de entrada e tratamento de erros

---

## 🛠️ Comandos do Makefile

| Comando | Descrição |
|---------|-----------|
| `make` | **Compilação padrão** - Compila o programa principal |
| `make run` | **Demonstração completa** - Executa todos os níveis de integração |
| `make c-direct` | **Teste C direto** - Executa apenas o modo C → C |
| `make lua-embedded` | **Teste Lua embarcado** - Executa apenas o modo C → Lua → C |
| `make clean` | **Limpeza** - Remove executável e arquivos objeto |

### **Exemplos de Uso:**

```bash
# Compilar projeto
make

# Demonstração completa
make run

# Teste específico do nível C → C
make c-direct

# Teste específico dos níveis C → Lua → C
make lua-embedded

# Limpeza
make clean
```

---

## 💡 Fluxo de Execução

### **Modo C Direto**
```
Usuario → ./programa "str1" "str2" → main.c → levenshtein.c → Resultado
```

### **Modo Lua Embarcado**
```
Usuario → ./programa → main.c → Lua embarcado → script.lua → função C registrada → levenshtein.c → Resultado processado
```

---

## 📊 Funcionalidades do Script Lua

O script Lua (`script.lua`) demonstra o poder da integração oferecendo:

- **Testes automatizados**: 13 pares de strings predefinidos
- **Validação robusta**: Tratamento de strings vazias e erros
- **Estatísticas**: Cálculo de média, valores mínimo e máximo
- **Processamento avançado**: Ordenação por similaridade
- **Logs detalhados**: Rastreamento completo da execução

### **Exemplo de Saída:**
```
[LUA] Calculando distância entre 'casa' e 'carro'
[C->LUA] Calculando distância entre 'casa' e 'carro'
[C->LUA] Resultado: 3
casa -> carro: 3 caracteres

Estatísticas:
 Testes executados: 13
 Sucessos: 13
 Distância média: 3.46
 Menor distância: 0
 Maior distância: 5

Top 5 pares mais similares:
 1. lua <-> lua: 100.00%
 2. programando <-> programador: 81.82%
 3. cadeira <-> madeira: 71.43%
```

---

## 🎯 Objetivos Alcançados

✅ **Integração C ↔ C**: Biblioteca externa usada diretamente  
✅ **Integração C ↔ Lua**: Interpretador Lua embarcado  
✅ **Integração Lua ↔ C**: Funções C registradas no ambiente Lua  
✅ **Makefile completo**: Regras `make`, `make run`, `make clean`  
✅ **Demonstração prática**: Múltiplos casos de teste  

---

## 📌 Notas Técnicas

- **Biblioteca externa**: Código original da biblioteca Levenshtein não foi modificado
- **Interpretador Lua**: Versão 5.4 totalmente embarcada no executável
- **Compatibilidade**: Testado com GCC em sistemas Linux
- **Dependências**: Apenas bibliotecas padrão do sistema (libm, libdl)

---

## 🔗 Repositório

[📁 Acesse o código completo no GitHub](https://github.com/MatheusFoltran/c-with-lua-levenshtein)

---

## 📄 Licença

Este projeto utiliza a licença MIT, mantendo a licença original da biblioteca Levenshtein externa.