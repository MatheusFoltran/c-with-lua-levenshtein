#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "levenshtein.h"

#define MAX_STRING_LENGTH 1000

int main(int argc, char *argv[]) {
    // Verifica se recebeu argumentos corretos
    if (argc != 3) {
        fprintf(stderr, "Erro: Número incorreto de argumentos.\n");
        fprintf(stderr, "Uso: %s <string1> <string2>\n", argv[0]);
        fprintf(stderr, "Exemplo: %s \"casa\" \"carro\"\n", argv[0]);
        return 1;
    }
    
    const char *str1 = argv[1];
    const char *str2 = argv[2];
    
    // Validação básica das strings
    if (str1 == NULL || str2 == NULL) {
        fprintf(stderr, "Erro: Strings não podem ser NULL.\n");
        return 2;
    }
    
    size_t len1 = strlen(str1);
    size_t len2 = strlen(str2);
    
    // Verificação de tamanho para evitar overflow
    if (len1 > MAX_STRING_LENGTH || len2 > MAX_STRING_LENGTH) {
        fprintf(stderr, "Erro: Strings muito longas (máximo %d caracteres).\n", MAX_STRING_LENGTH);
        return 3;
    }
    
    // Log das informações recebidas
    printf("[MAIN C] Recebendo strings:\n");
    printf(" String 1: \"%s\" (tamanho: %zu)\n", str1, len1);
    printf(" String 2: \"%s\" (tamanho: %zu)\n", str2, len2);
    
    // Caso especial: strings idênticas
    if (strcmp(str1, str2) == 0) {
        printf("[MAIN C] Strings idênticas detectadas.\n");
        printf("[MAIN C] Distância: 0\n");
        printf("RESULTADO: 0\n");
        return 0;
    }
    
    // Caso especial: uma string vazia
    if (len1 == 0) {
        printf("[MAIN C] String 1 vazia, distância = tamanho da string 2\n");
        printf("[MAIN C] Distância: %zu\n", len2);
        printf("RESULTADO: %zu\n", len2);
        return 0;
    }
    
    if (len2 == 0) {
        printf("[MAIN C] String 2 vazia, distância = tamanho da string 1\n");
        printf("[MAIN C] Distância: %zu\n", len1);
        printf("RESULTADO: %zu\n", len1);
        return 0;
    }
    
    // Chama a biblioteca Levenshtein
    printf("[MAIN C] Chamando biblioteca Levenshtein...\n");
    
    size_t distancia = levenshtein(str1, str2);
    
    // Validação do resultado (distância não pode ser maior que a maior string)
    size_t max_len = (len1 > len2) ? len1 : len2;
    if (distancia > max_len) {
        fprintf(stderr, "Erro: Resultado inválido da biblioteca (%zu > %zu).\n", distancia, max_len);
        return 4;
    }
    
    printf("[MAIN C] Distância calculada: %zu\n", distancia);
    
    // Informações adicionais para debug
    printf("[MAIN C] Similaridade: %.2f%%\n", 
           100.0 * (1.0 - (double)distancia / (double)max_len));
    
    // Resultado final para o script Lua
    printf("RESULTADO: %zu\n", distancia);
    
    return 0;
}