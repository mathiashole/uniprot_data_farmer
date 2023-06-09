#!/bin/bash

# Check if a text file was provided as an argument
if [[ ${#args[@]} -eq 0 || " ${args[@]} " =~ " -h " ]]; then
  # Mostrar mensaje de ayuda
  echo "Usage: program 😺 [arguments]"
  echo
  echo "🙀 ARGUMENTS:"
  echo "  -h      Este es un argumento de ejemplo."
  echo "  -f      Este es otro argumento de ejemplo."
  echo "  -l      Este es un tercer argumento de ejemplo."
  echo
  echo "😻 CONTACT"
  echo "  https://github.com/mathiashole"
  echo "  joacomangino@gmail.com"
  echo "  https://twitter.com/joaquinmangino"
  echo
  echo "  MIT © Mathias Mangino"

  exit 1
fi

# Check if the "seqDownload" folder exists; if not, create it
if [ ! -d "seqDownload" ]; then
  mkdir seqDownload
fi

# Check if the text file exists
if [ -f "$1" ]; then
  # Iterate over each line in the text file
  while IFS= read -r id
  do
    # Check if the line contains a valid ID
    if [[ $id =~ ^[A-Za-z0-9]+$ ]]; then
       # Download the FASTA file for each valid ID
      url="https://rest.uniprot.org/uniprotkb/${id}.fasta"
      file_name="uniprot_${id}.fasta"
      output_path="seqDownload/$file_name"
      curl -o "$output_path" "$url"
      echo "The file $file_name has been downloaded successfully."
    else
      echo "Invalid ID in the file: $id"
    fi
  done < "$1"
else
  echo "The file $1 does not exist."
  exit 1
fi


