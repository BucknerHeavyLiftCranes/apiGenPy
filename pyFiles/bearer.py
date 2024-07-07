
import requests
from dotenv import load_dotenv
import os
import traceback

# Load the environment variables
load_dotenv()

# Function to retrieve the authorization token

token = None

def get_auth_token():
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
            # Extract the token from the response
            
            token = response.cookies['authToken']
            print("Authorization token exported successfully.")
            return token
        else:
            print(f"Failed to retrieve authorization token. Status code: {response.status_code}, Response body: {response.text}")
            print(response.cookies)
            return
    
    except requests.exceptions.RequestException as e:
        print("Failed to connect to the API.")
        print(f"Exception type: {e.__class__.__name__}, Message: {e}, Traceback: {traceback.format_exc()}")
        return
    except Exception as e:
        print("An error occurred:" + str(e))
        print(f"Exception type: {e.__class__.__name__}, Message: {e}, Traceback: {traceback.format_exc()}")
        return
