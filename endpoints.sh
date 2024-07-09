#!/bin/bash

echo "$(curl -s https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/utils/endpointWizard.txt)"
echo "This script will help you create connections to the api endpoints" 


#set up endpoint files
echo "Please enter the names of the files you would like to create for the endpoints." 
echo "Begin each name with 'get' followed by the name of the resource you are trying to retrieve."

while true; do
    read -p "Enter file name. Type 'q' when done: " endpointName
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
        # Create a temporary file with the new import at the top
        echo "from $endpointName import $endpointName" > temp_main.py
        # Append the contents of the original main.py to the temporary file
        cat main.py >> temp_main.py
        # Replace the original main.py with the temporary file
        mv temp_main.py main.py
        echo "Added import for $endpointName to the top of main.py"
    fi
done

echo "All files have been created."