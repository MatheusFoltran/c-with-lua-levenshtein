#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "levenshtein.h"

#define MAX_STRING_LENGTH 1000

// Função wrapper para expor levenshtein ao Lua
static int lua_levenshtein(lua_State *L) {
    // Verifica se recebeu 2 argumentos string
    if (lua_gettop(L) != 2) {
        return luaL_error(L, "levenshtein() espera exatamente 2 argumentos");
    }
    
    const char *str1 = luaL_checkstring(L, 1);
    const char *str2 = luaL_checkstring(L, 2);
    
    // Validação básica
    if (!str1 || !str2) {
        return luaL_error(L, "Strings não podem ser NULL");
    }
    
    size_t len1 = strlen(str1);
    size_t len2 = strlen(str2);
    
    // Verificação de tamanho
    if (len1 > MAX_STRING_LENGTH || len2 > MAX_STRING_LENGTH) {
        return luaL_error(L, "Strings muito longas (máximo %d caracteres)", MAX_STRING_LENGTH);
    }
    
    printf("[C->LUA] Calculando distância entre '%s' e '%s'\n", str1, str2);
    
    // Chama a função C
    size_t resultado = levenshtein(str1, str2);
    
    printf("[C->LUA] Resultado: %zu\n", resultado);
    
    // Retorna o resultado para Lua
    lua_pushinteger(L, resultado);
    return 1;
}

// Função para registrar funções C no Lua
static void registrar_funcoes_c(lua_State *L) {
    // Registra a função levenshtein
    lua_register(L, "levenshtein", lua_levenshtein);
    
    printf("[MAIN C] Função levenshtein registrada no ambiente Lua\n");
}

int main(int argc, char *argv[]) {
    printf("[MAIN C] Iniciando programa com Lua embarcado\n");
    printf("==================================================\n");
    
    // Modo 1: Execução direta via argumentos (compatibilidade)
    if (argc == 3) {
        printf("[MAIN C] Modo compatibilidade - executando via argumentos\n");
        
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
        
        // Validação do resultado
        size_t max_len = (len1 > len2) ? len1 : len2;
        if (distancia > max_len) {
            fprintf(stderr, "Erro: Resultado inválido da biblioteca (%zu > %zu).\n", distancia, max_len);
            return 4;
        }
        
        printf("[MAIN C] Distância calculada: %zu\n", distancia);
        printf("[MAIN C] Similaridade: %.2f%%\n",
               100.0 * (1.0 - (double)distancia / (double)max_len));
        printf("RESULTADO: %zu\n", distancia);
        
        return 0;
    }
    
    // Modo 2: Execução com Lua embarcado (objetivo do projeto)
    printf("[MAIN C] Modo Lua embarcado - inicializando interpretador\n");
    
    // Inicializa estado Lua
    lua_State *L = luaL_newstate();
    if (L == NULL) {
        fprintf(stderr, "Erro: Não foi possível criar estado Lua\n");
        return 1;
    }
    
    printf("[MAIN C] Estado Lua criado com sucesso\n");
    
    // Abre bibliotecas padrão do Lua
    luaL_openlibs(L);
    printf("[MAIN C] Bibliotecas padrão do Lua carregadas\n");
    
    // Registra funções C no ambiente Lua
    registrar_funcoes_c(L);
    
    // Executa o script Lua
    printf("[MAIN C] Executando script Lua...\n");
    printf("--------------------------------------------------\n");
    
    int resultado = luaL_dofile(L, "script.lua");
    
    if (resultado != LUA_OK) {
        fprintf(stderr, "[MAIN C] Erro ao executar script Lua: %s\n", 
                lua_tostring(L, -1));
        lua_close(L);
        return 1;
    }
    
    printf("--------------------------------------------------\n");
    printf("[MAIN C] Script Lua executado com sucesso\n");
    
    // Limpa estado Lua
    lua_close(L);
    printf("[MAIN C] Estado Lua finalizado\n");
    
    printf("[MAIN C] Programa finalizado com sucesso\n");
    return 0;
}