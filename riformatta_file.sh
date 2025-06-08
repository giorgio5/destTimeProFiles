#!/bin/bash

# Nome del file di input
input_file="BaumgardtGlobularParameter_all_with_comp.dat"
output_file="BaumgardtGlobularParameter_new.dat"

awk '
NR >= 3 {
  # Dividi la riga in due parti: prima di 24 caratteri e dopo
  prefix = substr($0, 1, 24)
  rest = substr($0, 25)

  # Dividi la parte restante in campi usando spazio come delimitatore
  # (Puoi adattare il delimitatore se i campi sono separati da altro carattere)
  n = split(rest, fields, /[ \t]+/)

  # Ricostruisci la riga inserendo due spazi tra i campi
  new_rest = ""
  for (i = 1; i <= n; i++) {
    new_rest = new_rest fields[i]
    if (i < n) {
      new_rest = new_rest "  "  # due spazi come separatori
    }
  }

  # Stampa la riga modificata
  print prefix new_rest
}
NR < 3 {
  # Per le prime due righe, lascia inalterato
  print
}
' $input_file > $output_file

