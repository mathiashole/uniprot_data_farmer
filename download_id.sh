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
  echo "  First vector of accession in text format or vector of names genes."
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
        url="https://rest.uniprot.org/uniprotkb/stream?format=${extension}&query=${name_search}${id}" ## check name_search
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
if [ $# -eq 0 ]; then
  show_help
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      show_help
      ;;
    -v|--version)
      show_version
      ;;
    -fas|--fasta|-json|--json|-gff|--gff|-tsv|--tsv)
      tag=$1
      name_search=${name_format[$tag]}
      extension=${tag_extension[$tag]}
      shift
      ;;
    *)
      listID=$1
      shift
      ;;
  esac
done

if [ -z "$tag" ] || [ -z "$listID" ]; then
  echo "Invalid usage. Please see the help message."
  exit 1
fi

# Execute the download function
getfile_data
