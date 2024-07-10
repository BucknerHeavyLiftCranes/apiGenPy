import os
import subprocess
import shutil
from pathlib import Path
import requests
import importlib.util
import sys

def cleanup(project_name):
    if project_name and os.path.exists(f"{os.path.expanduser('~')}/Projects/{project_name}"):
        print("\nExiting Wizard")
        print("Cleaning up...")
        shutil.rmtree(f"{os.path.expanduser('~')}/Projects/{project_name}")
    print("Exiting Wizard...")
    exit(1)

def create_project():
    while True:
        project_name = input("Please enter the name of the project: ")
        if project_name.isalnum() or all(c.isalnum() or c in '-_' for c in project_name):
            project_path = Path(f"{os.path.expanduser('~')}/Projects/{project_name}")
            if project_path.exists():
                overwrite = input(f"Directory {project_name} already exists. Overwrite? (y/n): ")
                if overwrite.lower() == 'y':
                    shutil.rmtree(project_path)
                    break
            else:
                break
        else:
            print("Invalid project name. Use only letters, numbers, hyphens, and underscores.")
    
    return project_name, project_path

def download_file_from_github(github_url, local_filename):
    # Send a GET request to the GitHub raw content URL
    response = requests.get(github_url)
    
    # Check if the request was successful
    if response.status_code == 200:
        # Write the content to a local file
        with open(local_filename, 'wb') as file:
            file.write(response.content)
        print(f"Successfully downloaded: {local_filename}")
    else:
        print(f"Failed to download file. Status code: {response.status_code}")


def check_and_install(package, install_command):
    if shutil.which(package) is None:
        install = input(f"{package} is required but not found. Install? (y/n): ")
        if install.lower() == 'y':
            subprocess.run(install_command, shell=True, check=True)
        else:
            print(f"{package} is required. Exiting...")
            exit(1)

def setup_project_files(project_path):
    os.makedirs(project_path, exist_ok=True)
    os.chdir(project_path)
    # Create files
    Path('README.md').write_text(f"{project_path.name} is a project created by the Buckner Heavy Lift Cranes API team.")
    Path('.gitignore').write_text(".gitignore\n.env\n")
    Path('requirements.txt').write_text("python-dotenv\nrequests\n")
    download_file_from_github("https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGenPy/main/endpoints.py", "endpoints.py")


def setup_auth(project_path):
    auth_type = input("Select authorization type:\n1) OAuth\n2) Bearer Token\nEnter selection [1, 2]: ")
    env_file = project_path / '.env'
    
    if auth_type == '1':
        env_file.write_text("CLIENT_ID=\nCLIENT_SECRET=\nTENET=\n")
        download_file_from_github("https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGenPy/main/pyFiles/OAuth.py", "auth.py")
    elif auth_type == '2':
        env_file.write_text("API_KEY=\nUSERNAME=\nPASSWORD=\n")
        download_file_from_github("https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGenPy/main/pyFiles/bearer.py", "auth.py")

def setup_database(project_path):
    db_type = input("Select database:\n1) Stark Tower SQLServer\nEnter selection [1]: ")
    
    if db_type == '1':
        with open(project_path / '.env', 'a') as f:
            f.write("DB_URL=\nDB_NAME=\nDB_USER=\nDB_PASSWORD=\n")
        download_file_from_github("https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGenPy/main/pyFiles/starkMain.py", "main.py")
        subprocess.run(["brew", "install", "unixodbc"])
        with open(project_path / 'requirements.txt', 'a') as f:
            f.write("pyodbc\n")
    else:
        download_file_from_github("https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGenPy/main/pyFiles/defaultMain.py", "main.py")
        pass

def run_endpoints_script():
    try:
        spec = importlib.util.spec_from_file_location("endpoints", "endpoints.py")
        endpoints_module = importlib.util.module_from_spec(spec)
        sys.modules["endpoints"] = endpoints_module
        spec.loader.exec_module(endpoints_module)
        
        # Assuming endpoints.py has a main() function
        endpoints_module.main()
    except Exception as e:
        print(f"Error running endpoints.py: {e}")

def main():
    try:
        project_name, project_path = create_project()
        
        check_and_install('brew', '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')
        subprocess.run(["brew", "update"])
        
        check_and_install('python3', 'brew install python')
        
        setup_project_files(project_path)
        setup_auth(project_path)
        setup_database(project_path)

        os.chdir(project_path)
        run_endpoints_script()
        
        print(f"\nProject {project_name} created successfully")
        print("You can now start developing your API")
        print("Define secrets in .env and specify endpoint URLs in each endpoint file")
        print("Create more endpoint files by running this script again")
        print(f"Run your API integration with: python3 {project_path}/main.py")
        
    except KeyboardInterrupt:
        cleanup(project_name)
    except Exception as e:
        print(f"An error occurred: {e}")
        cleanup(project_name)

if __name__ == "__main__":
    main()