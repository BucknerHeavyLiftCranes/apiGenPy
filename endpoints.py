import os
import re
import subprocess

def create_endpoints():
    print("This script will help you create connections to the API endpoints")

    while True:
        endpoint_name = input("Enter file name (begin with 'get', type 'q' when done): ")
        
        if endpoint_name.lower() == 'q':
            break
        
        if not endpoint_name.startswith('get'):
            print("Error: The file name must begin with 'get'. Please try again.")
            continue
        
        if not re.match(r'^[a-zA-Z_][a-zA-Z0-9_]*$', endpoint_name):
            print("Error: Invalid file name. Only letters, digits, and underscores are allowed, and it must start with 'get'.")
            continue
        
        file_path = f"{endpoint_name}.py"
        
        if os.path.exists(file_path):
            overwrite = input(f"File {file_path} already exists. Do you want to overwrite it? (y/n): ")
            if overwrite.lower() != 'y':
                print("File not overwritten. Please enter a different name.")
                continue
        
        # Create the endpoint file
        template_url = "https://raw.githubusercontent.com/BucknerHeavyLiftCranes/apiGen/main/pyFiles/endpoint.py"
        subprocess.run(["curl", "-s", template_url, "-o", file_path], check=True)
        
        # Replace 'getThing' with the actual endpoint name
        with open(file_path, 'r') as file:
            content = file.read()
        
        content = content.replace('getThing', endpoint_name)
        
        with open(file_path, 'w') as file:
            file.write(content)
        
        print(f"Created file: {file_path}")
        
        # Update main.py
        with open('main.py', 'r') as file:
            main_content = file.read()
        
        # Add import statement
        import_statement = f"from {endpoint_name} import {endpoint_name}\n"
        main_content = import_statement + main_content
        
        # Add function call
        function_call = f"{endpoint_name}Data = {endpoint_name}()\n"
        if "#run the api calls here" in main_content:
            main_content = main_content.replace("#run the api calls here", f"#run the api calls here\n{function_call}")
        else:
            print("Error: Could not find '#run the api calls here' in main.py. Manual edit may be required.")
        
        with open('main.py', 'w') as file:
            file.write(main_content)
        
        print(f"Added import and function call for {endpoint_name} to main.py")

    print("All files have been created.")

# You can call this function from your main script
if __name__ == "__main__":
    create_endpoints()