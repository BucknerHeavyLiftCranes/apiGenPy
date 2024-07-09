from auth import get_auth
import requests
import os
from  dotenv import load_dotenv
import traceback
import pyodbc


#load the environment variables
load_dotenv()

def main():

    #connect db 
    conn_str= (
        "DRIVER={ODBC Driver 18 for SQL Server};"
        f"SERVER={os.getenv('DB_URL')};"
        f"UID={os.getenv('DB_USER')};"
        f"PWD={os.getenv('DB_PASSWORD')};"
        f"DATABASE={os.getenv('DB_NAME')}"
    )

    connection = pyodbc.connect(conn_str)
    cursor = connection.cursor()

    #Do some stuff
    #run the api calls here 

    
    
    #What do you wanna do in the db 🤷?
    try:
        query = ""

        cursor.execute(query)
        connection.commit()
    except Exception as e:
        print(f"Exception type: {e.__class__.__name__}, Message: {e}, Traceback: {traceback.format_exc()}")
        traceback.print_exc()
        connection.rollback()
    
    print("Done with db stuff")