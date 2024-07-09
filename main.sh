#!/bin/bash
# Trap for cleanup on exit or error
cleanup() {
    if [ -z "$projectName" ]; then
        echo -e "\nExiting Wizard..."
        sleep 1.5
        clear
        exit 1
    elif [ -d "$HOME/Projects/$projectName" ]; then
        echo -e "\nExiting Wizard"
        echo "Cleaning up..."
        trash-cli "$HOME/Projects/$projectName"
        sleep 1.5
        clear
    fi
    exit 1
}
trap cleanup SIGINT SIGTERM 


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

# Check if Homebrew is installed
echo "Checking if Homebrew is installed"
if ! command -v brew &> /dev/null
then
    echo "Homebrew is required but not found. Do you want to install Homebrew? (y/n): "
    read installHomebrew
    if [[ "$installHomebrew" == "y" || "$installHomebrew" == "Y" ]]; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for the current session
        eval "$(/opt/homebrew/bin/brew shellenv)"
        
        echo "Homebrew installed successfully."
    else
        echo "Homebrew is required for this project. Exiting..."
        exit 1
    fi
else
    brew update
fi

echo "Checking if Python is installed"
if ! command -v python3 &> /dev/null
then
    echo "Python not found. Do you want to install Python? (y/n): "
    read installPython
    if [[ "$installPython" == "y" || "$installPython" == "Y" ]]; then
        echo "Installing Python..."
        brew install python
        echo "Python installed successfully."
    else
        echo "Python is required for this project. Exiting..."
        exit 1
    fi
else
    echo "Python is already installed."
fi


echo "Creating project $projectName"

#Set up project directory
mkdir ~/Projects/$projectName
cd ~/Projects/$projectName


#Set up project files and add to gitignore
touch README.md
touch .gitignore
touch requirements.txt
echo "python-dotenv" >> requirements.txt
echo "requests" >> requirements.txt

echo "$projectName is a project created by the Buckner Heavy Lift Cranes API team. This project is used to interact with the $projectName API" > README.md


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
curl https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/pyFiles/makeRequests.py > makeRequests.py

#setting up database connection
echo "What database would you like to connect to?"
echo "1) Stark Tower SQLServer"
echo "Enter selection [1]. Press any other key to continue without setting up DB"
read dbType

case $dbType in
    1)
        echo "DB_URL=" >> .env
        echo "DB_NAME=" >> .env
        echo "DB_USER=" >> .env
        echo "DB_PASSWORD=" >> .env
        curl https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/pyFiles/starkMain.py >> main.py
        echo "Downloading PyODBC driver"
        # Check if unixODBC is installed
        if ! brew list unixodbc &> /dev/null
        then
            echo "unixODBC not found. Installing unixODBC..."
            brew install unixodbc
            echo "unixODBC installed successfully."
        else
            echo "unixODBC is already installed."
        fi
        echo "pyodbc" >> requirements.txt
        ;;
    *)
        $dbType = 0
        touch main.py
        ;;
esac
echo "You will need to manually add DB credentials to the .env file"

echo "Installing requirements"
python3 -m pip install --upgrade pip
pip3 install -r requirements.txt

#download endpoint creation script
curl https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/endpoints.sh > endpoints.sh
chmod +x endpoints.sh

echo "Running endpoint creation script \n"
echo -ne 'Loading: [                    ] (0%)\r'
sleep 0.3
echo -ne 'Loading: [#####               ] (25%)\r'
sleep 0.3
echo -ne 'Loading: [##########          ] (50%)\r'
sleep 0.3
echo -ne 'Loading: [###############     ] (75%)\r'
sleep 0.3
echo -ne 'Loading: [####################] (100%)\r'
echo -ne '\n'

./endpoints.sh

trap - SIGINT SIGTERM EXIT

#Set up repo and make intial commit

# git init 

# git add .

# git commit -m "Initial commit"

# git remote add origin https://github.com/BucknerHeavyLiftCranes/$projectName.git

# git push -u origin master

# echo "Project $projectName created and pushed to github"

echo -e "\nProject $projectName created successfully"
echo "You can now start developing your API"
echo "You will need to define any acrets in the .env file and specify the endpoint urls in each of your endpoint files"
echo "You can create more endpoint fiels at anytime by running ./endpoints.sh"
echo "Type python3 main.py to run your API integration"
echo "Exiting the wizard..."
echo -e "\n"
sleep .5
