#!/bin/bash

# Parent folder
parent_folder="/opt/cert/proxy-config/certificates"

# Get the most recently modified folder based on modification time
recent_folder=$(ls -td "$parent_folder"/*/ | head -n 1)

# Check if the recent_folder is not empty
if [ -n "$recent_folder" ]; then
    # Extract the basename of the recent folder
    recent_folder=$(basename "$recent_folder")

    # Check if both certificate and key files exist
    cert="$parent_folder/$recent_folder/$recent_folder.crt"
    key="$parent_folder/$recent_folder/$recent_folder.key"

    if [ -e "$cert" ] && [ -e "$key" ]; then
        # Verify the consistency between the certificate and key using SHA256
        if [ "$(openssl x509 -in "$cert" -pubkey -noout -outform pem | openssl sha256)" == "$(openssl pkey -in "$key" -pubout -outform pem | openssl sha256)" ]; then
            echo "Certificate and Key for $recent_folder are matched."
        else
            echo "Error: Certificate and Key for $recent_folder do not match."
        fi
    else
        echo "Error: Certificate or Key files not found for $recent_folder."
    fi
else
    echo "Error: No recent folder found in $parent_folder."
fi
