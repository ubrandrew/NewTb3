import json
import os
import random


cwd = os.getcwd()
#
# merchantsRequest = "http://api.reimaginebanking.com/enterprise/merchants?key=c49ecda776f1db2451f202eb71f21c1d"
# transfersRequest = "http://api.reimaginebanking.com/enterprise/transfers?key=c49ecda776f1db2451f202eb71f21c1d"
#
# merchantsJson = requests.get(merchantsRequest).json()
# transfersJson = requests.get(transfersRequest).json()
#
# with open(cwd+'/Data/merchantsJson.txt', 'w+') as outfile:
#     json.dump(merchantsJson, outfile)
#
# with open(cwd+'/Data/transfersJson.txt', 'w+') as outfile:
#     json.dump(transfersJson, outfile)
#


merchantsJson = json.load(open(cwd+'/Data/merchantsJson.txt'))
transfersJson = json.load((open(cwd+'/Data/transfersJson.txt')))

merchantList = list()
for merchant in merchantsJson['results']:
    merchantList.append(merchant['_id'])

for transfer in transfersJson['results']:
    transfer['payee_id'] = random.choice(merchantList)

with open(cwd+'/Data/transfersJson.txt', 'w+') as outfile:
    json.dump(transfersJson, outfile)