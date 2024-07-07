import requests
import os
from dotenv import load_dotenv
import traceback

load_dotenv()

def get_auth():
    #Define request
    tenet = os.getenv('TENET')
    endpoint = f''

    body = {
        'grant_type': 'client_credentials',
        'client_id': os.getenv('CLIENT_ID'),
        'client_secret': os.getenv('CLIENT_SECRET'),
        
    }
    
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
    }
    print(body)
    # Make a POST request
    try:
        response = requests.post(endpoint, data=body, headers=headers)
        print(response.json())
        response.raise_for_status()
        return(response.json().get('token'))
        

    except Exception as e:
        print('Failed tp connect to the API')
        print(f"Exception type: {e.__class__.__name__}, Message: {e}, Traceback: {traceback.format_exc()}")
        return


get_auth()
