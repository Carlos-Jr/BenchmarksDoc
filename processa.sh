#!/bin/bash

# Verifica se o diretório foi passado como argumento
if [ $# -ne 1 ]; then
    echo "Uso: $0 <caminho_para_pasta>"
    exit 1
fi

PASTA="$1"

# Cabeçalho CSV (adicionados memory e tempo)
echo "arquivo,inputs,outputs,gates,levels,energy,memory(MiB),time(s)"

# Itera sobre arquivos .v na pasta
for arquivo in "$PASTA"/*.v; do
    nome_base=$(basename "$arquivo" .v)

    # Executa bit-combs e captura toda a saída
    saida1=$(./bit-combs -o temp.output "$arquivo")
    if [ $? -ne 0 ]; then
        continue
    fi

    # Extrai os valores com grep
    inputs=$(echo "$saida1" | grep -oP 'inputs\s*=\s*\K[0-9]+')
    outputs=$(echo "$saida1" | grep -oP 'outputs\s*=\s*\K[0-9]+')
    gates=$(echo "$saida1" | grep -oP 'gates\s*=\s*\K[0-9]+')
    levels=$(echo "$saida1" | grep -oP 'levels\s*=\s*\K[0-9]+')

    # Extrai energia via join-combs
    energy=$(./join-combs temp.output | grep -oP 'energy\s*=\s*\K[0-9.]+' | tail -n1)

    # Extrai uso de memória (valor numérico antes de "MiB")
    memory=$(echo "$saida1" | grep -oP 'memory\s*=\s*\K[0-9.]+(?=\s*MiB)')

    # Extrai tempo de simulação (última ocorrência de time = ...s)
    tempo=$(echo "$saida1" | grep -oP 'time\s*=\s*\K[0-9.]+(?=s)' | tail -n1)

    # Imprime linha CSV com todos os campos
    echo "$nome_base,$inputs,$outputs,$gates,$levels,$energy,$memory,$tempo"
done
