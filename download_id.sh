#!/bin/bash

# Global variable
tag=$1
listID=$2

# Define mapping from tags to extensions in an associative array
declare -A tag_extension
tag_extension["-json"]=".json"
tag_extension["-fasta"]=".fasta"
tag_extension["-gff"]=".gff"

# Check if a text file was provided as an argument
if [[ $# -eq 0 || $# -eq 1 ]]; then
  show_help
elif [ $# -eq 1 ] && [ $1 == "-h" ] && [ $1 == "--help" ]; then
  show_help
fi

# Check if the tag is a valid key in the associative array
if [[ -n "${tag_extension[$tag]}" ]]; then
  # Get the corresponding extension from the array
  extension="${tag_extension[$tag]}"
  #echo $extension
else
  echo "Invalid extension in the program: $tag"
fi


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
      url="https://rest.uniprot.org/uniprotkb/${id}${extension}"
      file_name="uniprot_${id}${extension}"
      output_path="seqDownload/$file_name"
      curl -o "$output_path" "$url"
      echo "The file $file_name has been downloaded successfully."
    else
      echo "Invalid ID in the file: $id"
    fi
  done < "$listID"
else
  echo "The file $listID does not exist."
  exit 1
fi

show_help(){
  # show help message
  echo "Usage: Uniprot farmer 👩🏻‍🌾"
  echo
  echo "🎃 OPTIONS:"
  echo "  -h, --help    Show this help"
  echo "  -fas, --fasta   Download fasta file"
  echo "  -json, --json   Download json file"
  echo "  -gff, --gff   Download gff file"
  echo
  echo "🎃 ARGUMENTS:"
  echo "  First vector of accession in text format."
  echo
  echo "🐮 CONTACT"
  echo "  https://github.com/mathiashole"
  echo "  joacomangino@gmail.com"
  echo "  https://twitter.com/joaquinmangino"
  echo
  echo "  MIT © Mathias Mangino"

  exit 1
}

# Function to show the version of the program
show_version() {
  echo "Uniprot farmer v0.0.1"\n;
}

