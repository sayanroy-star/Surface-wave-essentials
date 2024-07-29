
#!/bin/bash

root_dir="/home/seismology/Downloads/Sayandip_data_July_24"
output_file="sac_coordinates.txt"

# Remove the output file if it exists
rm -f "$output_file"

# Ensure GSAC is installed and accessible
if ! command -v gsac &> /dev/null; then
  echo "GSAC could not be found. Please install GSAC and ensure it is in your PATH."
  exit 1
fi

# Add header to the output file
echo "File STLA STLO EVLA EVLO" > "$output_file"

# Find all .LHZ files in the root directory and subdirectories
find "$root_dir" -type f -name "*.LHZ" | while IFS= read -r sac_file; do
  echo "Processing file: $sac_file"
  if [ -f "$sac_file" ]; then
    # Use GSAC to extract header information
    gsac_output=$(gsac <<EOF
read "$sac_file"
lh
STLA
STLO
EVLA
EVLO
quit
EOF
    )
    
    # Check if GSAC command was successful
    if [ $? -ne 0 ]; then
      echo "Error reading $sac_file with GSAC."
      continue
    fi
    
    # Extract relevant header information
    stla=$(echo "$gsac_output" | grep 'STLA' | awk '{for(i=1;i<=NF;i++) if ($i == "STLA") print $(i+1)}')
    stlo=$(echo "$gsac_output" | grep 'STLO' | awk '{for(i=1;i<=NF;i++) if ($i == "STLO") print $(i+1)}')
    evla=$(echo "$gsac_output" | grep 'EVLA' | awk '{for(i=1;i<=NF;i++) if ($i == "EVLA") print $(i+1)}')
    evlo=$(echo "$gsac_output" | grep 'EVLO' | awk '{for(i=1;i<=NF;i++) if ($i == "EVLO") print $(i+1)}')
    # Debugging output to trace issues
    echo "GSAC Output:"
    echo "$gsac_output"
    echo "Extracted STLA: $stla"
    echo "Extracted STLO: $stlo"
    echo "Extracted EVLA: $evla"
    echo "Extracted EVLO: $evlo"
    
    # Check if values were extracted
    if [ -n "$stla" ] && [ -n "$stlo" ] && [ -n "$evla" ] && [ -n "$evlo" ]; then
      echo "$sac_file $stla $stlo $evla $evlo" >> "$output_file"
    else
      echo "Incomplete information extracted from $sac_file"
    fi
  else
    echo "$sac_file is not a valid file."
  fi
done











