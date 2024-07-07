
import requests
from dotenv import load_dotenv
import os
from auth import get_auth
import traceback


    

def make_request(endpoint, payload, retry_count=0):
    if endpoint is None:
        raise Exception("Failed to retrieve data. No endpoint provided.")
    
    token = get_auth()
    
    if token is None:
        raise Exception("Failed to retrieve data. No token provided.")
    
    #set headers
    headers = {
        'Accept':'*/*',

    }

    #create url from endpoint passed in
    url = (f"https://connect.calamp.com/connect/{endpoint}")
    
    #makes request
    try:
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            return response.json()
        #catches error if request fails
        elif response.status_code == 401:
            if retry_count < 1:
                token = get_auth_token()
                return make_request(endpoint, payload, retry_count + 1);
            else:
                print(f"Failed to retrieve data. Token refresh failed. Status code: {response.status_code}, Response body: {response.text}, Traceback: {traceback.format_exc()}")
                return
            
        else:
            print(f"Failed to retrieve data. Status code: {response.status_code}, Response body: {response.text}, Traceback: {traceback.format_exc()}")
            return 
    except requests.exceptions.RequestException as e:
        print(f"Exception type: {e.__class__.__name__}, Message: {e}, Traceback: {traceback.format_exc()}")
        return
    except Exception as e: 
        print(f"Exception type: {e.__class__.__name__}, Message: {e}, Traceback: {traceback.format_exc()}")
        return
