#Main binary thaht creates project 

echo "Please enter the name of the project"

read -p porjectName

echo "Creating project $projectName"

cd ~/Projects 

#Set up project directory
mkdir $projectName
cd $projectName

#Set up project files and add to gitignore
touch README.md
touch .gitignore

echo ".gitignore" >> .gitignore
echo ".env" >> .gitignore



#Set up repo and make intial commit

git init 

git add .

git commit -m "Initial commit"

git remote add origin https://github.com/BucknerHeavyLiftCranes/$projectName.git

git push -u origin master

echo "Project $projectName created and pushed to github"