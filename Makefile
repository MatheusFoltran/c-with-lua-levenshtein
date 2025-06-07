# Makefile para compilar programa com Levenshtein

CC = gcc
CFLAGS = -Wall -O2 -std=c99
TARGET = programa
SOURCES = main.c levenshtein.c

all: $(TARGET)

$(TARGET): $(SOURCES)
	$(CC) $(CFLAGS) -o $(TARGET) $(SOURCES)

clean:
	rm -f $(TARGET) *.o

# Teste individual do programa C
test-c: $(TARGET)
	@echo "=== Teste direto do programa C ==="
	./$(TARGET) "casa" "carro"
	./$(TARGET) "gato" "rato"

# Teste via Lua (o workflow completo)
test: $(TARGET)
	@echo "=== Teste via Lua ==="
	lua script.lua

# Regra exigida na especificação
run: test

# Teste rápido
quick: $(TARGET)
	./$(TARGET) "hello" "world"

.PHONY: all clean test test-c run quick
