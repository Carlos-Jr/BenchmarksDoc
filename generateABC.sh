# Para chamar este script para todos os arquivos *.v na pasta:
# for file in *.v; do ./generateABC.sh "$file"; done

#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

arquivo=$1

comandos=("resyn2" "src_rws" "resyn2a" "resyn3" "compress" "compress2" "choice" "choice2" "src_rw" "src_rs" "src_rws" "resyn2rs" "r2rs" "compress2rs" "c2rs")

for comando in "${comandos[@]}"; do
  abc -c "read_verilog $arquivo; $comando; write_verilog ./result/$comando-$arquivo; quit"
  sed -i '/^$/d' "./result/$comando-$arquivo"
  sed -i '/^\/\//d' "./result/$comando-$arquivo"
  sed -i 's/new_//g' "./result/$comando-$arquivo"
  #./getCircuitStats ./result/$comando-$arquivo >> infos.csv
done
