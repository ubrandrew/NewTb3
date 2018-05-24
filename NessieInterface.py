import requests
import json
import os
import plotly
import plotly.graph_objs as go
import random


cwd = os.getcwd()
#
# merchantsRequest = "http://api.reimaginebanking.com/enterprise/merchants?key=c49ecda776f1db2451f202eb71f21c1d"
# #transfersRequest = "http://api.reimaginebanking.com/enterprise/transfers?key=c49ecda776f1db2451f202eb71f21c1d"
# customersRequest = "http://api.reimaginebanking.com/customers?key=c49ecda776f1db2451f202eb71f21c1d"
# accountsRequest = "http://api.reimaginebanking.com/enterprise/accounts?key=c49ecda776f1db2451f202eb71f21c1d"
#
# merchantsJson = requests.get(merchantsRequest).json()
# #transfersJson = requests.get(transfersRequest).json()
# customersJson = requests.get(customersRequest).json()
# accountsJson = requests.get(accountsRequest).json()
#
# with open(cwd+'/Data/merchantsJson.txt', 'w+') as outfile:
#     json.dump(merchantsJson, outfile)
#
# #with open(cwd+'/Data/transfersJson.txt', 'w+') as outfile:
# #    json.dump(transfersJson, outfile)
#
# with open(cwd+'/Data/customersJson.txt', 'w+') as outfile:
#     json.dump(customersJson, outfile)
#
# with open(cwd+'/Data/accountsJson.txt', 'w+') as outfile:
#     json.dump(accountsJson, outfile)

categories = ['entertainment', 'transportation', 'food', 'health', 'shopping']

merchantsJson = json.load(open(cwd+'/Data/merchantsJson.txt'))
transfersJson = json.load((open(cwd+'/Data/transfersJson.txt')))
#customersJson = json.load((open(cwd+'/Data/customersJson.txt')))
accountsJson = json.load(open(cwd+'/Data/accountsJson.txt'))


def graphByMerchant(customerID, merchantsJson, transfersJson):
    idToName = {}
    for merchant in merchantsJson['results']:
        if 'name' in merchant:
            idToName[merchant['_id']] = merchant['name'].title()
        else:
            idToName[merchant['_id']] = ['Unknown']
    spending = {}
    for transfer in transfersJson['results']:
        if transfer['payer_id'] == customerID:
            if idToName[transfer['payee_id']] not in spending:
                spending[idToName[transfer['payee_id']]] = 0
            spending[idToName[transfer['payee_id']]] += transfer['amount']
    if spending:
        x = list()
        y = list()
        for key in spending:
            x.append(key)
            y.append(spending[key])

        trace = go.Bar(x=x, y=y)

        data = [trace]
        layout = go.Layout(
            title='Categories of Largest Spending',
            font=dict(family='Courier New, monospace', size=16, color='#1E8449'),
            xaxis=dict(
                title='Category',
                titlefont=dict(
                    family='Courier New, monospace',
                    size=14,
                    color='#7D3C98'
                )
            ),
            yaxis=dict(
                title='Spending (USD)',
                titlefont=dict(
                    family='Courier New, monospace',
                    size=14,
                    color='#7D3C98'
                )
            )
        )
        fig = go.Figure(data=data, layout=layout)

        plotly.offline.plot(fig, filename=cwd + '/Graphs/Test.html')
        return True



def graphByCategory(customerID, merchantsJson, transfersJson):
    idToCategory = {}
    for merchant in merchantsJson['results']:
        if 'category' in merchant:
            idToCategory[merchant['_id']] = merchant['category']
        else:
            idToCategory[merchant['_id']] = ['Unknown']
    spending = {}
    for transfer in transfersJson['results']:
        if transfer['payer_id'] == customerID:
            if 'transaction_date' in transfer:
                if 1:#transfer['transaction_date'][0:7] == "2016-02":
                    for category in idToCategory[transfer['payee_id']]:
                        if category not in spending:
                            spending[category] = 0
                        try:
                            spending[category]+=float(transfer['amount'])
                        except:
                            spending[category] += 0

    if spending:
        
        x = list()
        y = list()
        for key in spending:
            x.append(key)
            y.append(spending[key])

        for i in range(len(x)):
            x[i] = x[i].title()

        trace = go.Bar(x = x, y=y)

        data = [trace]
        layout = go.Layout(
            title='Categories of Largest Spending',
            font=dict(family='Courier New, monospace', size=16, color='#1E8449'),
            xaxis=dict(
                title='Category',
                titlefont=dict(
                    family='Courier New, monospace',
                    size=14,
                    color='#7D3C98'
                )
            ),
            yaxis=dict(
                title='Spending (USD)',
                titlefont=dict(
                    family='Courier New, monospace',
                    size=14,
                    color='#7D3C98'
                )
            )
        )
        fig = go.Figure(data=data, layout=layout)

        plotly.offline.plot(fig, filename=cwd+'/Graphs/Test.html')
        return True

# cats = set()
# for merchant in ((merchantsJson['results'])):
#     if 'category' in merchant:
#         if type(merchant['category']) == list:
#             for c in merchant['category']:
#                 cats.add(c)
#         else:
#             cats.add(merchant['category'])
# print(cats)

for i in range(len(accountsJson['results'])):
    x = int(random.random()*len(accountsJson['results']))
    print(x)
    if graphByMerchant(accountsJson['results'][x]['_id'], merchantsJson, transfersJson):
        break
#681 is solid