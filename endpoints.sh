echo "Welcome to the endpoint wizard 🧙‍♂️🪄"
echo "This script will help you create connections to the api endpoints" 


#set up endpoint files
echo "Please enter the names of the files you would like to create for the endpoints." 
echo "Begin each name with 'get' followed by the name of the rescource you are trying to retive."
echo "Type 'q' when done: "

while true; do
    read -p "Enter file name: " endpointName
    if [["$endpointName" = "q"  || "$endpointName" = "Q" ]]; then
        break
    fi
    if [[ $endpointName != get* ]]; then
        echo "Error: The file name must begin with 'get'. Please try again."
        continue
    fi
    touch $endpointName.py
    curl https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/pyFiles/endpoint.py > $endpointName.py
    sed -i 'getThing/${endpointName}' $endpointName.py
    echo "Created file: $endpointName"
done

echo "All files have been created."