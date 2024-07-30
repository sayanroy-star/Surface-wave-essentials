#!/bin/bash

# Define the main directory and the subset directory
main_dir="/home/seismology/Downloads/Sayandip_data_July25_24"
subset_dir="/home/seismology/Downloads/Sayandip_data_July_24_subset"

# Ensure subset directory exists
mkdir -p "$subset_dir"

# Loop through each subdirectory in the main directory
for subfolder in "$main_dir"/*; do
  # Check if it is a directory
  if [ -d "$subfolder" ]; then
    # Extract the subfolder name
    subfolder_name=$(basename "$subfolder")

    # Check if the corresponding subfolder exists in the subset directory
    if [ -d "$subset_dir/$subfolder_name" ]; then
      # Find and copy minter files to the corresponding subfolder in the subset directory
      find "$subfolder" -name "minter_MFA_*" -type f -exec cp {} "$subset_dir/$subfolder_name/" \;
    else
      echo "Warning: Subfolder $subfolder_name does not exist in the subset directory."
    fi
  fi
done

echo "Minter files copied successfully."

