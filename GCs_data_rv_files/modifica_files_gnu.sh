#!/bin/bash

# Directory corrente o specifica una directory
directory="."  # cambia con il percorso desiderato

# Loop su tutti i file con estensione .gnu
for file in "$directory"/*.gnu; do
    # Verifica se il file esiste
    [ -e "$file" ] || continue

    # Usa awk per modificare la riga 5
    awk -v OFS='\n' '
    NR == 5 {
        # Sostituisci "_" con " "
        line = gensub(/_/, " ", "g", $0);
        # Riduci le più di uno spazio consecutivo a uno
        line = gensub(/[ ]+/, " ", "g", line);
        print line;
        next;
    }
    { print }
    ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
done


