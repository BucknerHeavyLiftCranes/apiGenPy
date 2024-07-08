#!/bin/bash

#Main binary thaht creates project 
echo "$(curl -s https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/utils/apiWizard.txt)"

while true; do
    echo "Please enter the name of the project: "
    read projectName
    if [[ "$projectName" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        if [ -d "$HOME/Projects/$projectName" ]; then
            echo "Directory with the name $projectName already exists. Do you want to overwrite it? (y/n): "
            read overwrite
            if [[ "$overwrite" == "y" || "$overwrite" == "Y" ]]; then
                rm -rf $HOME/Projects/$projectName
                break
            else
                echo "Please enter a different project name."
            fi
        else
            break
        fi
    else
        echo "Invalid project name. Please use only letters, numbers, hyphens, and underscores."
    fi
done

echo "Creating project $projectName"

#Set up project directory
mkdir ~/Projects/$projectName
cd ~/Projects/$projectName


#Set up project files and add to gitignore
touch README.md
touch .gitignore


echo "$projectName is a project created by the Buckner Heavy Lift Cranes API team. This project is used to interact with the $projectName API" > README.md

#download endpoint creation script
curl https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/endpoints.sh > endpoints.sh
chmod +x endpoints.sh

echo "Running endpoint creation script \n"
echo -ne 'Loading: [                    ] (0%)\r'
sleep 0.2
echo -ne 'Loading: [#####               ] (25%)\r'
sleep 0.2
echo -ne 'Loading: [##########          ] (50%)\r'
sleep 0.2
echo -ne 'Loading: [###############     ] (75%)\r'
sleep 0.2
echo -ne 'Loading: [####################] (100%)\r'
echo -ne '\n'


clear
./endpoints.sh

echo ".gitignore" >> .gitignore
echo ".env" >> .gitignore

#Set up .env file
echo "Please select what type of authorizations the API uses:"
echo "1) OAuth"
echo "2) Bear Token, Username and Password"
echo "Enter selection [1, 2]. Press any other key to continue without setting up Authintication" 
read authType


case $authType in
    1)
        echo "CLIENT_ID=" >> .env
        echo "CLIENT_SECRET=" >> .env
        echo "TENET" >> .env
        curl https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/pyFiles/OAuth.py > auth.py 
        ;;
    2) 
        echo "API_KEY=" >> .env
        echo "USERNAME=" >> .env
        echo "PASSWORD=" >> .env
        curl https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/pyFiles/bearer.py > auth.py
        ;;
    *)
        $authType = 0
        ;;
esac

#Set up project files
curl https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/pyFiles/makeRequets.py > makeRequests.py

#setting up database connection
echo "What database would you like to connect to?"
echo "1) Stark Tower SQLServer"
echo "Any key for other"
read dbType

case $dbType in
    1)
        echo "DB_URL=" >> .env
        echo "DB_NAME=" >> .env
        echo "DB_USER=" >> .env
        echo "DB_PASSWORD=" >> .env
        curl https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/pyFiles/starkMain.py >> main.py
        echo "Downloading PyODBC driver"
        sudo ACCEPT_EULA=Y apt-get install msodbcsql18 -y
        ;;
    *)
        $dbType = 0
        touch main.py
        ;;
esac

echo "You will need to manually add DB credentials to the .env file"

#Set up repo and make intial commit

# git init 

# git add .

# git commit -m "Initial commit"

# git remote add origin https://github.com/BucknerHeavyLiftCranes/$projectName.git

# git push -u origin master

# echo "Project $projectName created and pushed to github"