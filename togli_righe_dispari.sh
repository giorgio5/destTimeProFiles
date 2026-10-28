#!/bin/bash

# Nome del file di input
input_file="BaumgardtGlobularParameter.dat"

# Nome del file di output
output_file="BaumgardtGlobularParameter_comp.dat"

# Rimuove le righe dispari
awk 'NR % 2 == 0' "$input_file" > "$output_file"

echo "Righe dispari rimosse. Risultato salvato in $output_file."
