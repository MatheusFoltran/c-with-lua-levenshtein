-- Script Lua que chama o programa C
print("[LUA] Iniciando script de teste Levenshtein")
print("=" .. string.rep("=", 50))

-- Função para executar programa C e capturar saída
function calcular_levenshtein(str1, str2)
    print(string.format("[LUA] Calculando distância entre '%s' e '%s'", str1, str2))
    
    -- Monta comando para executar programa C
    local comando = string.format("./programa '%s' '%s'", str1, str2)
    print("[LUA] Executando: " .. comando)
    
    -- Executa e captura saída
    local handle = io.popen(comando)
    local resultado = handle:read("*a")
    handle:close()
    
    -- Procura linha com RESULTADO
    local distancia = resultado:match("RESULTADO: (%d+)")
    
    if distancia then
        distancia = tonumber(distancia)
        print(string.format("[LUA] Resultado recebido: %d", distancia))
        return distancia
    else
        print("[LUA] Erro: não conseguiu extrair resultado")
        print("[LUA] Saída completa:")
        print(resultado)
        return nil
    end
end

-- Testes
print("\n--- Teste 1 ---")
local dist1 = calcular_levenshtein("casa", "carro")

print("\n--- Teste 2 ---") 
local dist2 = calcular_levenshtein("gato", "rato")

print("\n--- Teste 3 ---")
local dist3 = calcular_levenshtein("hello", "world")

print("\n--- Teste 4 ---")
local dist4 = calcular_levenshtein("lua", "lua")

-- Processa resultados em Lua
print("\n" .. string.rep("=", 50))
print("[LUA] Processando resultados:")

if dist1 then print(string.format("casa -> carro: %d caracteres", dist1)) end
if dist2 then print(string.format("gato -> rato: %d caracteres", dist2)) end  
if dist3 then print(string.format("hello -> world: %d caracteres", dist3)) end
if dist4 then print(string.format("lua -> lua: %d caracteres", dist4)) end

-- Calcula média das distâncias
local distancias = {}
if dist1 then table.insert(distancias, dist1) end
if dist2 then table.insert(distancias, dist2) end
if dist3 then table.insert(distancias, dist3) end
if dist4 then table.insert(distancias, dist4) end

if #distancias > 0 then
    local soma = 0
    for _, d in ipairs(distancias) do
        soma = soma + d
    end
    local media = soma / #distancias
    print(string.format("[LUA] Distância média: %.2f", media))
end

print("[LUA] Script finalizado!")
print("=" .. string.rep("=", 50))