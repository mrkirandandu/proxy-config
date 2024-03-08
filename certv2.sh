#!/bin/bash

# Parent folder
parent_folder="/opt/cert/proxy-config/certificates"

# Get the most recently modified folders based on modification time (up to 10 folders)
recent_folders=($(ls -dt "$parent_folder"/ | head -n 10))

# Iterate through recent folders
for recent_folder in "${recent_folders[@]}"; do
    # Iterate through subfolders
    for subfolder in "$recent_folder"/; do
        # Check if both certificate and key files exist
        cert="$subfolder$(basename "$subfolder").crt"
        key="$subfolder$(basename "$subfolder").key"

        if [ -e "$cert" ] && [ -e "$key" ]; then
            # Verify the consistency between the certificate and key using SHA256
            if [ "$(openssl x509 -in "$cert" -pubkey -noout -outform pem | openssl sha256)" == "$(openssl pkey -in "$key" -pubout -outform pem | openssl sha256)" ]; then
                echo "Certificate and Key for $subfolder are matched."
            else
                echo "Error: Certificate and Key for $subfolder do not match."
            fi
        else
            echo "Error: Certificate or Key files not found for $subfolder."
        fi
    done
done

