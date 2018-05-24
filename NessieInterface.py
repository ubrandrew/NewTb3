import requests
import json
import os
import plotly
import plotly.graph_objs as go


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




def graphByCategory(customerID):
    idToCategory = {}
    for dict in merchantsJson['results']:
        idToCategory[dict['_id']] = dict['category']
    spending = {}
    invalid = {}
    for transfer in transfersJson['results']:
        if(transfer['payer_id']==customerID):
            cont = False
            for merchant in merchantsJson['results']:
                if transfer['payee_id'] in invalid:
                    break
                if merchant['_id'] == transfer['payee_id']:
                    cont = True
                    break
            if not cont:
                invalid[transfer['payee_id']] = True
            if cont:
                print("SQUAD UP")
                for category in idToCategory[transfer['payee_id']]:
                    spending[category]+=transfer['amount']
    if spending:
        print("SQUAD UP")

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

for i,transfer in enumerate(transfersJson['results']):
    graphByCategory(transfer['payer_id'])