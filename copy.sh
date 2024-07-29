#!/bin/bash

# Define source directory, file, and destination directory
SOURCE_DIR="/home/sayandeep/Downloads/Sayandip_data_July_24"
FILE_NAME="only_disp_plot_gmt.sh"  # Replace with the name of the file you want to copy
DEST_DIR="/home/sayandeep/Downloads/Sayandip_data_July_24_subset"

# Check if the source file exists
if [ ! -f "$SOURCE_DIR/$FILE_NAME" ]; then
    echo "Source file does not exist."
    exit 1
fi

# Loop through each subfolder in the destination directory
for SUBFOLDER in "$DEST_DIR"/*/; do
    # Remove trailing slash from subfolder path
    SUBFOLDER=${SUBFOLDER%/}
    
    # Copy the file to the current subfolder
    cp "$SOURCE_DIR/$FILE_NAME" "$SUBFOLDER/"
    
    # Check if the copy was successful
    if [ $? -eq 0 ]; then
        echo "File copied to $SUBFOLDER successfully."
    else
        echo "Error occurred while copying the file to $SUBFOLDER."
    fi
done

