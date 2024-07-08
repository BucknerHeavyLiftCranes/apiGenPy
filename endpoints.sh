#!/bin/bash

echo "Welcome to the endpoint wizard 🧙‍♂️🪄"
echo "This script will help you create connections to the api endpoints" 


#set up endpoint files
echo "Please enter the names of the files you would like to create for the endpoints." 
echo "Begin each name with 'get' followed by the name of the resource you are trying to retrieve."
echo "Type 'q' when done: "

while true; do
    read -p "Enter file name: " endpointName
    if [[ $endpointName = "q" || $endpointName = "Q" ]]; then
        break
    elif [[ $endpointName != get* ]]; then
        echo "Error: The file name must begin with 'get'. Please try again."
        continue
    elif ! [[ $endpointName =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        echo "Error: Invalid file name. Only letters, digits, and underscores are allowed, and it must start with 'get'."
        continue
    else
        if [[ -e $endpointName.py ]]; then
            read -p "File $endpointName.py already exists. Do you want to overwrite it? (y/n): " overwrite
            if [[ $overwrite != "y" ]]; then
                echo "File not overwritten. Please enter a different name."
                continue
            fi
        fi
        touch $endpointName.py
        curl https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/pyFiles/endpoint.py > $endpointName.py
        sed -i '' "s/getThing/${endpointName}/g" $endpointName.py
        echo "Created file: $endpointName"
    fi
done

echo "All files have been created."