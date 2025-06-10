# Makefile para compilar programa com Levenshtein e Lua embarcado
CC = gcc
CFLAGS = -Wall -O2 -std=c99 -Isrc
TARGET = programa

# Arquivos fonte do Lua (na pasta src)
LUA_SOURCES = src/lapi.c src/lcode.c src/lctype.c src/ldebug.c src/ldo.c \
              src/ldump.c src/lfunc.c src/lgc.c src/llex.c src/lmem.c \
              src/lobject.c src/lopcodes.c src/lparser.c src/lstate.c \
              src/lstring.c src/ltable.c src/ltm.c src/lundump.c \
              src/lvm.c src/lzio.c src/lauxlib.c src/lbaselib.c \
              src/ldblib.c src/liolib.c src/lmathlib.c src/loslib.c \
              src/ltablib.c src/lstrlib.c src/lutf8lib.c src/loadlib.c \
              src/lcorolib.c src/linit.c

# Arquivos objeto
LUA_OBJECTS = $(LUA_SOURCES:.c=.o)
OBJECTS = main.o levenshtein.o $(LUA_OBJECTS)

# Regra padrão (make)
$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -o $(TARGET) -lm -ldl

# Compilação dos arquivos
main.o: main.c levenshtein.h
	$(CC) $(CFLAGS) -c main.c

levenshtein.o: levenshtein.c levenshtein.h
	$(CC) $(CFLAGS) -c levenshtein.c

src/%.o: src/%.c
	$(CC) $(CFLAGS) -DLUA_COMPAT_5_3 -c $< -o $@

src/loslib.o: src/loslib.c
	$(CC) $(CFLAGS) -DLUA_COMPAT_5_3 -Wno-deprecated-declarations -c $< -o $@

# COMANDOS OBRIGATÓRIOS DA ESPECIFICAÇÃO

# Demonstração completa (todos os níveis)
run: $(TARGET)
	@echo "========================================="
	@echo "          DEMONSTRAÇÃO COMPLETA			"
	@echo "========================================="
	@make c-direct
	@make lua-embedded
	@echo "=========================================="

# Limpeza
clean:
	rm -f $(TARGET) $(OBJECTS)

# COMANDOS POR NÍVEL DE INTEGRAÇÃO

# Nível 1: C chamando C diretamente
c-direct: $(TARGET)
	@echo "=== C -> C (direto) ==="
	./$(TARGET) "casa" "carro"
	./$(TARGET) "gato" "rato"
	./$(TARGET) "hello" "world"
	@echo ""

# Nível 2+3: Lua embarcado + Lua chamando C
lua-embedded: $(TARGET)
	@echo "=== C -> Lua -> C ==="
	./$(TARGET)
	@echo ""

.PHONY: clean run c-direct lua-embedded