#!/bin/bash

# Input and output file paths
ENV_FILE=".env"
INPUT_FILE="services-template.yaml"
OUTPUT_FILE="services.yaml"

# Check if the .env file exists
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: .env file not found."
  echo "There is a .env.template file that you can fill"
  echo "to create the .env file"
  exit 1
fi

# Check if the template file exists
if [[ ! -f "$INPUT_FILE" ]]; then
  echo "Error: $INPUT_FILE not found."
  exit 1
fi

# Load environment variables from the .env file
set -a
source "$ENV_FILE"
set +a

# Copy the input file to the output file
cp "$INPUT_FILE" "$OUTPUT_FILE"

# Perform substitutions
while IFS='=' read -r key value; do
  # Remove surrounding quotes if they exist
  value=$(echo "$value" | sed 's/^\"//;s/\"$//')

  if [[ "$key" =~ ^HOMEPAGE_VAR_ ]]; then
    placeholder="{{${key}}}"
    # Replace all occurrences of the placeholder with the value in the output file
    sed -i "s|$placeholder|$value|g" "$OUTPUT_FILE"
  fi
done < "$ENV_FILE"

# Inform the user
echo "Substitutions complete. Output written to $OUTPUT_FILE."