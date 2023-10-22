import requests
# from bs4 import BeautifulSoup
# from github import Github
import time
from itertools import product
import json
import base64
import random
import string
import sys

tokens = ["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"]
search_strs = ["client_id" , "client_secret", "tenant_id" , "subscription_id"]
qry = "client_id+client_secret+tenant_id+"
# search_strs = ["access_key" , "secret_key"]
# qry = "access_key+secret_key+"

def generate_sequence_strings(length):
    sequences = []
    for i in range(10):
        characters = string.ascii_letters + string.digits  
        random_string = ''.join(random.choice(characters) for _ in range(2))
        sequences.append(random_string)
    return sequences

def get_secrets(urls):
        
        try:
            response = requests.get(urls)
            print(urls)
            print(response)
            if response.status_code == 200:
                text = json.loads(response.text)
                decoded_bytes = base64.b64decode(text['content'])
                decoded_string = decoded_bytes.decode('utf-8')
                lines = decoded_string.split('\n')
                with open('C:/Users/Arunk/OneDrive/Desktop/POC/github/azure_creds.txt', "a") as f:
                        f.write("#############################################################################################################################" + "\n")
                        f.write(urls+"\n")
                for search_str in search_strs:
                    for line in lines:
                        if search_str in line.lower():
                            with open("C:\\Users\\Arunk\\OneDrive\\Desktop\\POC\\github\\azure_creds.txt", "a") as f:
                                
                                f.write(line+"\n")
                            print(line)
            else:
                # print(f"Failed to fetch the file. Status code: {response.status_code}")
                pass

        except requests.exceptions.RequestException as e:
            print(f"Error fetching the file: {e}")


randoms = generate_sequence_strings(3)
print(randoms)
headers = {"Authorization": "Bearer "+ tokens[0], "X-GitHub-Api-Version": "2022-11-28"}
for random in randoms:
    # try:
        query=qry+random+"+language:HCL"
        url = f"https://api.github.com/search/code?q={query}"
        response = requests.get(url, headers=headers)
        json_data = response.json()
        # print(json_data)
        print(query)
        try:
            print(json_data['total_count'])
        except:
            print(json_data)
        repos = json_data['items']
        
        for repo in repos:
            # try:
                repo_url = repo['html_url']
                print(repo_url)
                with open("C:\\Users\\Arunk\\OneDrive\\Desktop\\POC\\github\\azure_repo.txt", "a") as f:
                    f.write(repo_url+"\n")
                # get_secrets(repo_url)
            # except Exception as e:
            #     print(e)

    # except Exception as e:
    #     print(e)
