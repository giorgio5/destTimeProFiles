#!/bin/bash

# Cicla attraverso tutti i file .txt nella directory corrente
for file in *.dat; do
    # Controlla se il file esiste
    if [[ -e "$file" ]]; then
        # Rimuovi gli spazi prima dell'estensione
        new_name=$(echo "$file" | sed 's/ \+.txt/.txt/')
        # Rinominare il file solo se il nuovo nome è diverso dal vecchio
        if [[ "$file" != "$new_name" ]]; then
            mv "$file" "$new_name"
            echo "Rinominato: '$file' a '$new_name'"
        fi
    fi
done
Puoi utilizzare uno script Bash per rinominare i file di testo e rimuovere gli spazi prima dell'estensione `.txt`. Ecco un esempio di come fare:

```bash
#!/bin/bash

# Cicla attraverso tutti i file .txt nella directory corrente
for file in *.txt; do
    # Controlla se il file esiste
    if [[ -e "$file" ]]; then
        # Rimuovi gli spazi prima dell'estensione
        new_name=$(echo "$file" | sed 's/ \+.txt/.txt/')
        # Rinominare il file solo se il nuovo nome è diverso dal vecchio
        if [[ "$file" != "$new_name" ]]; then
            mv "$file" "$new_name"
            echo "Rinominato: '$file' a '$new_name'"
        fi
    fi
done
```

### Spiegazione dello script:

1. `for file in *.txt; do`: questo ciclo itera su tutti i file con estensione `.txt` nella directory corrente.
2. `if [[ -e "$file" ]]; then`: verifica se il file esiste.
3. `new_name=$(echo "$file" | sed 's/ \+.txt/.txt/')`: utilizza il comando `sed` per sostituire uno o più spazi prima dell'estensione `.txt` con solo `.txt`.
4. `if [[ "$file" != "$new_name" ]]; then`: controlla se il nuovo nome è diverso dal vecchio nome.
5. `mv "$file" "$new_name"`: rinomina il file.
6. `echo "Rinominato: '$file' a '$new_name'"`: stampa il risultato della rinomina.

### Come utilizzare lo script:

1. Copia il codice in un file di testo, ad esempio `rename_files.sh`.
2. Rendi eseguibile lo script con il comando:
   ```bash
   chmod +x rename_files.sh
   ```
3. Esegui lo script nella directory contenente i file `.txt`:
   ```bash
   ./rename_files.sh
   ```

Questo script rimuoverà gli spazi prima dell'estensione `.txt` per tutti i file nella directory corrente. Assicurati di eseguire una copia di backup dei tuoi file prima di eseguire lo script, nel caso in cui ci siano errori.
