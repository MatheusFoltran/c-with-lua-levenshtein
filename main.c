#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "levenshtein.h"

int main(int argc, char *argv[]) {
    // Verifica se recebeu argumentos corretos
    if (argc != 3) {
        printf("Uso: %s <string1> <string2>\n", argv[0]);
        printf("Exemplo: %s \"casa\" \"carro\"\n", argv[0]);
        return 1;
    }
    
    const char *str1 = argv[1];
    const char *str2 = argv[2];
    
    printf("[MAIN C] Recebendo strings:\n");
    printf("  String 1: \"%s\"\n", str1);
    printf("  String 2: \"%s\"\n", str2);
    
    // Chama sua lib Levenshtein
    printf("[MAIN C] Chamando lib Levenshtein...\n");
    size_t distancia = levenshtein(str1, str2);
    
    printf("[MAIN C] Distância calculada: %zu\n", distancia);
    
    // Retorna resultado via exit code ou stdout
    // Para Lua, vamos usar stdout
    printf("RESULTADO: %zu\n", distancia);
    
    return 0;
}