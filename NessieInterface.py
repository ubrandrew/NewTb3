import requests
import json
import os
import plotly
import plotly.graph_objs as go


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



merchantsJson = json.load(open(cwd+'/Data/merchantsJson.txt'))
transfersJson = json.load((open(cwd+'/Data/transfersJson.txt')))
customersJson = json.load((open(cwd+'/Data/customersJson.txt')))
accountsJson = json.load(open(cwd+'/Data/accountsJson.txt'))




def graphByCategory(customerID, merchantsJson, transfersJson):
    idToCategory = {}
    for merchant in merchantsJson['results']:
        if 'category' in merchant:
            idToCategory[merchant['_id']] = merchant['category']
        else:
            idToCategory[merchant['_id']] = ['Unknown']
    spending = {}
    for transfer in transfersJson['results']:
        if 'transaction_date' in transfer:
            if transfer['transaction_date'][0:7] == "2016-02":
                for category in idToCategory[transfer['payee_id']]:
                    if category not in spending:
                        spending[category] = 0
                    try:
                        spending[category]+=float(transfer['amount'])
                        print(float(transfer['amount']))
                    except:
                        spending[category] += 0
    print(spending)

    if spending:
        x = list()
        y = list()
        for key in spending:
            x.append(key)
            y.append(spending[key])

        trace = go.Bar(x = x, y=y)

        data = [trace]
        layout = go.Layout(
            title='On-Scene Delay by Unit Type',
            font=dict(family='Courier New, monospace', size=16, color='#1E8449'),
            xaxis=dict(
                title='Unit Type',
                titlefont=dict(
                    family='Courier New, monospace',
                    size=14,
                    color='#7D3C98'
                )
            ),
            yaxis=dict(
                title='Average Delay to get On the Scene (seconds)',
                titlefont=dict(
                    family='Courier New, monospace',
                    size=14,
                    color='#7D3C98'
                )
            )
        )
        fig = go.Figure(data=data, layout=layout)

        plotly.offline.plot(fig, filename=cwd+'/Graphs/Test.html')

graphByCategory(accountsJson['results'][69]['_id'], merchantsJson, transfersJson)