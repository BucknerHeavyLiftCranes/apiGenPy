echo "Welcome to the endpoint wizard 🧙‍♂️🪄"
echo "This script will help you create connection to the api endpoints" 


#set up endpoint files
echo "Please enter the names of the files you would like to create for the endpoints. Type 'q' when done: "

while true; do
    read -p "Enter file name: " endpointName
    if [ "$endpointName" = "q" ]; then
        break
    fi
    curl https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/pyFiles/endpoint.py >> $endpointName.py
    echo "Created file: $endpointName"
done

echo "All files have been created."