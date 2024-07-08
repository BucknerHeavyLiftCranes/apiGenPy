#Main binary thaht creates project 
echo "Welcome to the Buckner Heavy Lift Cranes API project wizard 🧙‍♂️🪄"
echo "Please enter the name of the project: "

read projectName

echo "Creating project $projectName"

#Set up project directory
mkdir ~/Projects/$projectName



#Set up project files and add to gitignore
touch ~/Projects/$projectName/README.md
touch ~/Projects/$projectName/.gitignore
touch ~/Projects/$projectName/main.py

echo "$projectName is a project created by the Buckner Heavy Lift Cranes API team. This project is used to interact with the $projectName API" > ~/Projects/$projectName/README.md

#download endpoint creation script
curl https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/endpoints.sh >> ~/Projects/$projectName/endpoints.sh
chmod +x ~/Projects/$projectName/endpoints.sh
~/Projects/$projectName/endpoints.sh

echo ".gitignore" >> ~/Projects/$projectName/.gitignore
echo ".env" >> ~/Projects/$projectName/.gitignore

#Set up .env file
echo "Please select what type of authorizations the API uses:"
echo "1) OAuth"
echo "2) Bear Token, Username and Password"
echo "Enter selection [1, 2]. Press any other key to continue without setting up Authintication" 
read authType


case $authType in
    1)
        echo "CLIENT_ID=" >> ~/Projects/$projectName/.env
        echo "CLIENT_SECRET=" >> ~/Projects/$projectName/.env
        echo "TENET" >> ~/Projects/$projectName/.env
        #cat ./pyfiles/OAuth.py > ~/Projects/$projectName/auth.py
        curl https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/pyFiles/OAuth.py >> ~/Projects/$projectName/auth.py 
        ;;
    2) 
        echo "API_KEY=" >> ~/Projects/$projectName/.env
        echo "USERNAME=" >> ~/Projects/$projectName/.env
        echo "PASSWORD=" >> ~/Projects/$projectName/.env
        curl https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/pyFiles/bearer.py >> ~/Projects/$projectName/auth.py
        ;;
    *)
        $authType = 0
        ;;
esac

#Set up project files
curl https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/pyFiles/makeRequets.py >> ~/Projects/$projectName/makeRequests.py

#setting up database connection
echo "What database would you like to connect to?"
echo "1) Stark Tower SQLServer"
echo "Any key for other"
read dbType

case $dbType in
    1)
        echo "DB_URL=" >> ~/Projects/$projectName/.env
        echo "DB_NAME=" >> ~/Projects/$projectName/.env
        echo "DB_USER=" >> ~/Projects/$projectName/.env
        echo "DB_PASSWORD=" >> ~/Projects/$projectName/.env
        curl https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/pyFiles/starkMain.py >> ~/Projects/$projectName/main.py
        echo "Downloading PyODBC driver"
        sudo ACCEPT_EULA=Y apt-get install msodbcsql18 -y
        ;;
    *)
        $dbType = 0
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