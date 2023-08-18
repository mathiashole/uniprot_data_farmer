#!/bin/bash

# Global variable
tag=$1
listID=$2

# Function to show the version of the program
show_version(){
  echo -e "\nUniprot farmer v0.0.1\n"
}

show_help(){
  # show help message
  echo "Usage: Uniprot farmer 👩🏻‍🌾"
  echo
  echo "🎃 OPTIONS:"
  echo "  -h, --help    Show this help"
  echo "  -v, --version   Show version"
  echo "  -fas, --fasta   Download fasta output file"
  echo "  -json, --json   Download json output file"
  echo "  -gff, --gff   Download gff output file"
  echo "  -tsv, --tsv   Download tsv output file"
  echo
  echo "🎃 ARGUMENTS:"
  echo "  First vector of accession in text format."
  echo
  echo "🐮 CONTACT"
  echo "  https://github.com/mathiashole"
  echo "  https://twitter.com/joaquinmangino"
  echo
  echo "  MIT © Mathias Mangino"

  exit 1
}

getfile_data(){
  # Check if the "seqDownload" folder exists; if not, create it
  if [ ! -d "fileDownload" ]; then
    mkdir fileDownload
  fi

  # Check if the text file exists
  if [ -f "$listID" ]; then
    # Iterate over each line in the text file
    while IFS= read -r id
    do
      # Check if the line contains a valid ID
      if [[ $id =~ ^[A-Za-z0-9]+$ ]]; then
        # Download the FASTA file for each valid ID
        url="https://rest.uniprot.org/uniprotkb/stream?format=${extension}&query=accession%3A${id}"
        file_name="uniprot_${id}.${extension}"
        output_path="fileDownload/$file_name"
        curl -o "$output_path" "$url"
        echo "The file $file_name has been downloaded successfully."
      else
        echo "Invalid ID in the file: $id"
      fi
    done < "$listID"
  else
    echo "The file $listID does not exist. You must provide a list of proteins"
    exit 1
  fi
}

# Define mapping from tags to extensions in an associative array
declare -A tag_extension
tag_extension["-json"]="json"
tag_extension["-fasta"]="fasta"
tag_extension["-gff"]="gff"
tag_extension["-tsv"]="tsv"

declare -A name_format
name_format["-accession"]="accession%3A"
name_format["-gene"]="%28"

# Check if a text file was provided as an argument
if [ $# -eq 0 ] || [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then

  show_help

elif [[ $1 == "-v" ]] || [[ $1 == "--version" ]]; then
  
  show_version

elif [[ -n "${tag_extension[$tag]}" ]]; then # Check if the tag is a valid key in the associative array
  # Get the corresponding extension from the array
  extension="${tag_extension[$tag]}"
  #echo $extension
  if [[ -n ]]
  # Execute main function download and make directory
  getfile_data

else
  echo "Invalid extension in the program: $tag"
fi

