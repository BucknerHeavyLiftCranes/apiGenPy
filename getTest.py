#This file is for connecting to a given endpoint 
from makeRequests import makeRequest
import json

def getTest(id):
    if id is None:
        raise Exception("Failed to get retrieve data, ID required")
    

    #This holds the data that is returned from the endpoint
    data_filtered = []

    endpoint ="" #put endpoint url here

    data = makeRequest(endpoint)

    #Uncomment the following line to dump the data to a json file
    #with open('data.json', 'w') as f:
    #    json.dump(data, f)

    if data is None:
        raise Exception("Failed to get retrieve data")

    #This section is for filtering the data to only return the data that is needed
    #This is where the magic happens
    #Modify this code to only return the specific data that is needed
    for item in data:
        data_filtered.append(item)

    return(filtered_data)