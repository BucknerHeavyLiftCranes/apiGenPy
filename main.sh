#Main binary thaht creates project 

echo "Please enter the name of the project: "

read projectName

echo "Creating project $projectName"

#Set up project directory
mkdir ~/Projects/$projectName



#Set up project files and add to gitignore
touch ~/Projects/$projectName/README.md
touch ~/Projects/$projectName/.gitignore
touch ~/Projects/$projectName/auth.py
touch ~/Projects/$projectName/main.py
touch ~/Projects/$projectName/make_request.py


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
        cat ./pyfiles/OAuth.py > ~/Projects/$projectName/auth.py
        ;;
    2) 
        echo "API_KEY=" >> ~/Projects/$projectName/.env
        echo "USERNAME=" >> ~/Projects/$projectName/.env
        echo "PASSWORD=" >> ~/Projects/$projectName/.env
        cat ./pyfiles/BearToken.py > ~/Projects/$projectName/auth.py
        ;;
    *)
        $authType = 0
        ;;
esac

#Set up project files



#Set up repo and make intial commit

# git init 

# git add .

# git commit -m "Initial commit"

# git remote add origin https://github.com/BucknerHeavyLiftCranes/$projectName.git

# git push -u origin master

# echo "Project $projectName created and pushed to github"