input_file='BaumgardtGlobularParameter_with_comp.dat'
output_file='BaumgardtGlobularParameter_all_with_comp.dat'
awk 'NR==1 {print; next} {
    # Trova la posizione del primo spazio
    split($0, arr, " ")
    first_word = arr[1]
    rest = substr($0, length(first_word)+1)
    # Ricostruisci la riga con il primo campo e spazi fino alla colonna 24
    printf "%s", first_word
    # Calcola quanti spazi aggiungere
    spaces_needed = 24 - length(first_word)
    for(i=0; i<spaces_needed; i++) printf " "
    # Stampa il resto della riga
    print rest
}' $input_file > $output_file
