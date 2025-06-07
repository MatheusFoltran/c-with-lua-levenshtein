-- Script Lua que chama o programa C
-- Função auxiliar para logs padronizados
function log(msg)
    print("[LUA] " .. msg)
end

log("Iniciando script de teste Levenshtein")
print("=" .. string.rep("=", 50))

-- Função para executar programa C e capturar saída
function calcular_levenshtein(str1, str2)
    -- Validação de entrada
    if not str1 or not str2 then
        log("Erro: strings não podem ser nil")
        return nil
    end
    
    if str1 == "" or str2 == "" then
        log("Aviso: uma das strings está vazia")
    end
    
    log(string.format("Calculando distância entre '%s' e '%s'", str1, str2))
    
    -- Escapar aspas duplas nas strings para evitar problemas com caracteres especiais
    local str1_escaped = str1:gsub('"', '\\"')
    local str2_escaped = str2:gsub('"', '\\"')
    
    local comando = string.format('./programa "%s" "%s"', str1_escaped, str2_escaped)
    log("Executando: " .. comando)
    
    local handle = io.popen(comando)
    local resultado = handle:read("*a")
    local success = handle:close()
    
    if not success then
        log("Erro: falha na execução do programa C")
        return nil
    end
    
    if not resultado or resultado == "" then
        log("Erro: programa C não retornou nenhuma saída")
        return nil
    end
    
    local distancia = resultado:match("RESULTADO: (%d+)")
    
    if distancia then
        distancia = tonumber(distancia)
        log(string.format("Resultado recebido: %d", distancia))
        return distancia
    else
        log("Erro: não conseguiu extrair resultado")
        log("Saída completa:")
        print(resultado)
        return nil
    end
end

-- Função para exibir resultado de forma padronizada
function exibir_resultado(rotulo, valor)
    if valor then
        print(string.format("%s: %d caracteres", rotulo, valor))
    else
        print(string.format("%s: ERRO", rotulo))
    end
end

-- Estrutura de dados para testes
local testes = {
    {"casa", "carro"},
    {"gato", "rato"},
    {"hello", "world"},
    {"lua", "lua"},
    {"tigre", "nuvem"},
    {"falha", "grama"},
    {"distancia", "instancia"},
    {"cadeira", "madeira"},
    {"programando", "programador"},
    {"chave", "bolsa"}
}

-- Executar testes
local resultados = {}
for i, teste in ipairs(testes) do
    print(string.format("\n--- Teste %d ---", i))
    local distancia = calcular_levenshtein(teste[1], teste[2])
    
    -- Armazenar resultado com informações do teste
    table.insert(resultados, {
        str1 = teste[1],
        str2 = teste[2],
        distancia = distancia
    })
end

-- Processa resultados em Lua
print("\n" .. string.rep("=", 50))
log("Processando resultados:")

local distancias_validas = {}
for _, resultado in ipairs(resultados) do
    local rotulo = string.format("%s -> %s", resultado.str1, resultado.str2)
    exibir_resultado(rotulo, resultado.distancia)
    
    -- Coletar apenas distâncias válidas para estatísticas
    if resultado.distancia then
        table.insert(distancias_validas, resultado.distancia)
    end
end

-- Calcular estatísticas
if #distancias_validas > 0 then
    local soma = 0
    local menor = distancias_validas[1]
    local maior = distancias_validas[1]
    
    for _, d in ipairs(distancias_validas) do
        soma = soma + d
        if d < menor then menor = d end
        if d > maior then maior = d end
    end
    
    local media = soma / #distancias_validas
    
    print("\n" .. string.rep("-", 30))
    log("Estatísticas:")
    print(string.format("  Testes executados: %d", #resultados))
    print(string.format("  Sucessos: %d", #distancias_validas))
    print(string.format("  Falhas: %d", #resultados - #distancias_validas))
    print(string.format("  Distância média: %.2f", media))
    print(string.format("  Menor distância: %d", menor))
    print(string.format("  Maior distância: %d", maior))
else
    log("Nenhum teste foi executado com sucesso!")
end

log("Script finalizado!")
print("=" .. string.rep("=", 50))