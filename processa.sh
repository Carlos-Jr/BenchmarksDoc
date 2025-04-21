#!/bin/bash

# Verifica se o diretório foi passado como argumento
if [ $# -ne 1 ]; then
    echo "Uso: $0 <caminho_para_pasta>"
    exit 1
fi

PASTA="$1"

# Cabeçalho CSV
echo "arquivo,inputs,outputs,gates,levels,energy"

# Itera sobre arquivos .v na pasta
for arquivo in "$PASTA"/*.v; do
    nome_base=$(basename "$arquivo" .v)

    # Executa o primeiro comando e aguarda término
    saida1=$(./bit-combs -o temp.output "$arquivo")
    if [ $? -ne 0 ]; then
        continue
    fi

    # Extrai os valores com grep
    inputs=$(echo "$saida1" | grep -oP 'inputs\s*=\s*\K[0-9]+')
    outputs=$(echo "$saida1" | grep -oP 'outputs\s*=\s*\K[0-9]+')
    gates=$(echo "$saida1" | grep -oP 'gates\s*=\s*\K[0-9]+')
    levels=$(echo "$saida1" | grep -oP 'levels\s*=\s*\K[0-9]+')

    # Executa join-combs e extrai o último valor de energy diretamente do pipe
    energy=$(./join-combs temp.output | grep -oP 'energy\s*=\s*\K[0-9.]+' | tail -n 1)

    # Imprime linha CSV
    echo "$nome_base,$inputs,$outputs,$gates,$levels,$energy"
done

