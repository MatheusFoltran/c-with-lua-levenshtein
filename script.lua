-- Script Lua para usar com interpretador embarcado
-- Agora chama diretamente a função C registrada

-- Função auxiliar para logs padronizados
function log(msg)
    print("[LUA] " .. msg)
end

log("Iniciando script Levenshtein com funções C embarcadas")
print("=" .. string.rep("=", 50))

-- Função para calcular distância usando função C registrada
function calcular_levenshtein_embarcado(str1, str2)
    -- Validação de entrada
    if not str1 or not str2 then
        log("Erro: strings não podem ser nil")
        return nil
    end
    
    if str1 == "" or str2 == "" then
        log("Aviso: uma das strings está vazia")
    end
    
    log(string.format("Calculando distância entre '%s' e '%s'", str1, str2))
    
    -- Chama diretamente a função C registrada
    local success, resultado = pcall(levenshtein, str1, str2)
    
    if not success then
        log("Erro ao chamar função C: " .. tostring(resultado))
        return nil
    end
    
    log(string.format("Resultado recebido da função C: %d", resultado))
    return resultado
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
    {"chave", "bolsa"},
    {"", "teste"},  -- Teste com string vazia
    {"teste", ""},  -- Teste com string vazia
    {"abc", "abc"}  -- Teste strings iguais
}

-- Executar testes
log("Executando testes com função C embarcada...")
local resultados = {}

for i, teste in ipairs(testes) do
    print(string.format("\n--- Teste %d ---", i))
    local distancia = calcular_levenshtein_embarcado(teste[1], teste[2])
    
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
    print(string.format(" Testes executados: %d", #resultados))
    print(string.format(" Sucessos: %d", #distancias_validas))
    print(string.format(" Falhas: %d", #resultados - #distancias_validas))
    print(string.format(" Distância média: %.2f", media))
    print(string.format(" Menor distância: %d", menor))
    print(string.format(" Maior distância: %d", maior))
else
    log("Nenhum teste foi executado com sucesso!")
end

-- Demonstrar funcionalidade adicional do Lua
log("Demonstrando processamento adicional em Lua...")

-- Criar tabela de similaridade baseada na distância
local similaridades = {}
for _, resultado in ipairs(resultados) do
    if resultado.distancia then
        local max_len = math.max(#resultado.str1, #resultado.str2)
        local similaridade = 0
        if max_len > 0 then
            similaridade = 100.0 * (1.0 - resultado.distancia / max_len)
        else
            similaridade = 100.0  -- Strings vazias são 100% similares
        end
        
        table.insert(similaridades, {
            par = resultado.str1 .. " <-> " .. resultado.str2,
            similaridade = similaridade
        })
    end
end

-- Ordenar por similaridade (maior para menor)
table.sort(similaridades, function(a, b) return a.similaridade > b.similaridade end)

print("\n" .. string.rep("-", 30))
log("Top 5 pares mais similares:")
for i = 1, math.min(5, #similaridades) do
    local item = similaridades[i]
    print(string.format(" %d. %s: %.2f%%", i, item.par, item.similaridade))
end

log("Script finalizado!")
print("=" .. string.rep("=", 50))