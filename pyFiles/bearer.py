
import requests
from dotenv import load_dotenv
import os
import traceback

# Load the environment variables
load_dotenv()

# Function to retrieve the authorization token

token = None

def get_auth():
    # Make a request to the API to retrieve the authorization token
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'calamp-services-app': os.getenv('API_KEY='),
    }


    payload = {
        'username': os.getenv('USERNAME'),
        'password': os.getenv('PASSWORD')
    }
    
    # Check if the token has already been retrieved
    global token
    if token:
        return token
    
    try:
        response = requests.post('', headers=headers, params=payload)
        
        # Extract the token from the response
        if response.status_code == 200 and response.cookies:
            token = response.cookies['authToken']
            print("Authorization token exported successfully.")
            return token
        else:
            print(f"Failed to retrieve authorization token. Status code: {response.status_code}, Response body: {response.text}")
            return
    
    except requests.exceptions.RequestException as e:
        print(f"Failed to connect to the API. Exception: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")
