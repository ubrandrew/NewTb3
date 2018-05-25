#!flask/bin/python
from flask import Flask, jsonify, request, make_response
import requests
import json
import os
import plotly
import plotly.graph_objs as go
import random
import sys


app = Flask(__name__)

@app.route('/webhook', methods=['POST'])
def webhook():
    req = request.get_json(silent=True, force=True)

    print("Request:")
    print(json.dumps(req, indent=4))

    res = makeWebhookResult(req)

    res = json.dumps(res, indent=4)
    print(res)
    r = make_response(res)
    r.headers['Content-Type'] = 'application/json'
    return r

def makeWebhookResult(req):
    print(req)
    if req.get("queryResult").get("action") != "test":
        print("I don't know this action")
        return {}
    parameters = req.get("parameters")
    #zone = parameters.get("shipping-zone")

    speech = "Hello, world!!!"

    print("Response:")
    print(speech)

    return {
        "fulfillmentText": speech,
        #"displayText": speech,
        #"data": {},
        # "contextOut": [],
        #"source": "notsurethismatters"
    }

@app.route('/')
def index():
    return "Hello, World!"

data_list = [
    {
        'id': 1,
        'title': u'Buy groceries',
        'description': u'Milk, Cheese, Pizza, Fruit, Tylenol',
        'done': False
    },
    {
        'id': 2,
        'title': u'Learn Python',
        'description': u'Need to find a good Python tutorial on the web',
        'done': False
    }
]

cwd = os.getcwd()

backTranslations = {
    "entertainment" : ['Manicure', 'museum', 'investing', 'Hotel', 'Hair Salon', 'Goldfish', 'Cosmetics',  'drugs', 'car rental', 'enterntainment',  'Night Club', 'movie_theater', 'hair_care', 'Travel', 'porn'],
    "food" : ['Food/Drink', 'coffee', 'Groceries', 'Restaurant', 'fast food', 'American Restaurant', 'Pizza Restaurant', 'Food and Beverage', 'Salads'],
    "transportation" : ['gas', 'gas_station', 'Transport'],
    "health" : ['electronics', 'hospital', 'health'],
    "shopping" : ['Clothes', 'Shopping', 'post_office', 'Utility Stores', 'loan', 'supermarket', 'furniture_store', 'School Supplies', 'home_goods_store', 'shoe_store']
}
translations = {}
for key, value in backTranslations.items():
    for val in value:
        translations[val] = key

merchantsJson = json.load(open(cwd+'/Data/merchantsJson.txt'))
transfersJson = json.load((open(cwd+'/Data/transfersJson.txt')))
#customersJson = json.load((open(cwd+'/Data/customersJson.txt')))
accountsJson = json.load(open(cwd+'/Data/accountsJson.txt'))



def graphByMerchant(customerID, merchantsJson, transfersJson):
    idToName = {}
    cwd = os.getcwd()

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
            title='Merchants with Largest Spending',
            font=dict(family='Courier New, monospace', size=16, color='#1E8449'),
            xaxis=dict(
                title='Merchant',
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

        plotly.offline.plot(fig, filename=cwd + '/Graphs/MerchantSpending.html')
        return True



def graphByCategory(customerID, merchantsJson, transfersJson, translations):
    idToCategory = {}
    cwd = os.getcwd()

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
                        if category in translations:
                            if category not in spending:
                                spending[translations[category]] = 0
                            try:
                                spending[translations[category]]+=float(transfer['amount'])
                            except:
                                spending[translations[category]] += 0

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

        plotly.offline.plot(fig, filename=cwd+'/Graphs/GeneralCategories.html')
        return True


def getPercentSaved(customerID, accountsJson, transfersJson):
    spending = 0
    balance = -1
    print("Savings:\n")
    for transfer in transfersJson['results']:
        if transfer['payer_id'] == customerID:
            spending += transfer['amount']
    print("Spending ", spending)
    for account in accountsJson['results']:
        if account['_id'] == customerID:
            balance = account['balance']
    if balance == -1 or balance == 0:
        return 0
    print("Balance ", balance)
    return 100-(spending/(balance+spending))*100

@app.route('/todo/api/v1.0/datavis/<int:data_id>', methods=['GET'])
def get_data_id(data_id):
    data = [data for data in data_list if data['id'] == data_id]

    print(len(accountsJson))
    print(len(accountsJson['results']))

    getPercentSaved(accountsJson['results'][data_id]['_id'], accountsJson, transfersJson)
    graphByMerchant(accountsJson['results'][data_id]['_id'], merchantsJson, transfersJson)

    return jsonify({'data_list': accountsJson['results'][data_id]})



if __name__ == '__main__':
    app.run(debug=True)
