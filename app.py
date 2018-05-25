#!flask/bin/python
from flask import Flask, jsonify, request, make_response
import requests
import json
import os
import plotly
import plotly.graph_objs as go
import random
import sys
#from googleplaces import GooglePlaces, types, lang


app = Flask(__name__)

customerIDTest = "79c66be6a73e492741507b6b"


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
"entertainment" : ['entertainment','Manicure', 'museum', 'investing', 'Hotel', 'Hair Salon', 'Goldfish', 'Cosmetics',  'drugs', 'car rental', 'enterntainment',  'Night Club', 'movie_theater', 'hair_care', 'Travel', 'porn'],
"food" : ['food','Food/Drink', 'coffee', 'Groceries', 'Restaurant', 'fast food', 'American Restaurant', 'Pizza Restaurant', 'Food and Beverage', 'Salads'],
"transportation" : ['transportation','gas', 'gas_station', 'Transport'],
"health" : ['health','electronics', 'hospital', 'health'],
"shopping" : ['shopping','Clothes', 'Shopping', 'post_office', 'Utility Stores', 'loan', 'supermarket', 'furniture_store', 'School Supplies', 'home_goods_store', 'shoe_store']
}
translations = {}
for key, value in backTranslations.items():
    for val in value:
        translations[val] = key

categories = ['entertainment', 'transportation', 'food', 'health', 'shopping']
merchantsJson = json.load(open(cwd+'/Data/merchantsJson.txt'))
transfersJson = json.load((open(cwd+'/Data/transfersJson.txt')))
#customersJson = json.load((open(cwd+'/Data/customersJson.txt')))
accountsJson = json.load(open(cwd+'/Data/accountsJson.txt'))
depositsJson = json.load(open(cwd+ '/Data/depositsJson.txt'))

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

    '''
    if "whats my budget",  then
        compare to average customer data
        displays spend less in specific Categories

    else if "How can i spend less on _____"
        action is "suggest"

        ex: how can i spend less on food:
        checks accounts with higher progress and same bracket

        '''

    queryResult = req.get("queryResult")
    if queryResult.get("action") == "budget":
        speech = ""
        #this is how you compare to other users:
        percent_change = getPercentChangeFromAverage(customerIDTest, depositsJson, transfersJson, categories, translations)
        print(percent_change.items())
        for key, val in percent_change.items():
            speech += "In the " + key + " category, you are spending " + str(val) + "% more than the average user."

        print("Response:")
        print(speech)

        return {
            "fulfillmentText": str(speech),
        }
    elif queryResult.get("action") == "suggest":
        parameters = queryResult.get("parameters")

        temp = parameters.get("spendingType")
        speech = ""
        #print(str(temp))
        alternative_shop = findBestAlternatives(customerIDTest, depositsJson, transfersJson, categories, translations, temp, merchantsJson)
        print("YEE " + alternative_shop)
        if alternative_shop == "None":
            speech += "Well done! You're budgeting great!"

        else:
            speech += "Based on other users who are budgeting well, we suggest that you shop from " + alternative_shop + " instead."
            print("Response:")
            print(speech)


        return {
            "fulfillmentText": str(speech),
        }

    elif queryResult.get("action") == "occasion":
        parameters = queryResult.get("parameters")

        YOUR_API_KEY = 'AIzaSyBbzFWxQXttnJ3zYWB6sHUkoQIP9MpkEb0'
        google_places = GooglePlaces(YOUR_API_KEY)

        location = ""
        for add in customerID['address']:
            location = location + ", " + add

        radius = 2000
        types = types.TYPE_FOOD
        queryRes = google_places.nearby_search(location, radius, types)



        for place in queryRes:
            place.get_details()
            price = place.price_level
            for review in place.reviews:
                rating = review["rating"]
                aspects = review["aspects"]

        result = ""
        if(parameters.get("love")!=NONE):
            for place in queryRes:
                place_temp = place.name
                place.get_details()
                price = place.price_level

            for review in place.reviews:
                rating = review["rating"]

                if(int(price)>3 and int(rating)>4):
                    result = place.temp

                if result == "":
                    result = place.temp
        elif(parameters.get("family")!=NONE):
            for place in queryRes:
                place_temp = place.name
                place.get_details()
                price = place.price_level

            for review in place.reviews:
                rating = review["rating"]

                if(int(price)<4 and int(rating)>3):
                    result = place.temp
                if result == "":
                    result = place.temp
        result = "You should consider the following place near you " + result
        return {
            "fulfillmentText": str(result),
        }



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




def graphByCategory(customerID, merchantsJson, transfersJson, translations):
    idToCategory = {}
    for merchant in merchantsJson['results']:
        if 'category' in merchant:
            idToCategory[merchant['_id']] = merchant['category']
        else:
            idToCategory[merchant['_id']] = ['Unknown']
    spending = {}
    for transfer in transfersJson['results']:
        if transfer['payer_id'] == customerID:
            #if 'transaction_date' in transfer:
                if 1:#transfer['transaction_date'][0:7] == "2016-02":
                    for category in idToCategory[transfer['payee_id']]:
                        if category in translations:
                            if category not in spending:
                                spending[translations[category]] = 0
                            try:
                                spending[translations[category]]+=float(transfer['amount'])
                            except:
                                spending[translations[category]] += 0

    print(spending)
    return jsonify({"data" : spending})



#how much money saved
def getPercentSavings(customerID, accountsJson, transfersJson, depositsJson):
    spending = 0
    balance = -1
    revenue = 0
    for transfer in transfersJson['results']:
        if transfer['payer_id'] == customerID:
            spending += transfer['amount']

    for deposits in depositsJson['results']:
        if deposits['payee_id'] == customerID:
            revenue += deposits['amount']
    print("Revenue", revenue)
    if revenue == 0:
        return 0
    return spending/revenue


def getCashBack(customerID, accountsJson, transfersJson, depositsJson):
    spending = 0
    balance = -1
    revenue = 0
    for transfer in transfersJson['results']:
        if transfer['payer_id'] == customerID:
            spending += transfer['amount']

    for deposits in depositsJson['results']:
        if deposits['payee_id'] == customerID:
            revenue += deposits['amount']
    print("Revenue", revenue)
    if revenue == 0:
        return 0
    moneyBack = (.01+spending/revenue*.1) * revenue

    if moneyBack <= 0:
        return 0
    return moneyBack

def getAccountDistribution(customerID, depositsJson, transfersJson,categories, translations):
    idToCategory = {}
    for merchant in merchantsJson['results']:
        if 'category' in merchant:
            idToCategory[merchant['_id']] = merchant['category']
        else:
            idToCategory[merchant['_id']] = ['Unknown']
    spending = {}
    for transfer in transfersJson['results']:
        if transfer['payer_id'] == customerID:
            for category in idToCategory[transfer['payee_id']]:
                if category in translations:
                    if translations[category] not in spending:
                        spending[translations[category]] = 0
                    try:
                        spending[translations[category]] += float(transfer['amount'])
                    except:
                        spending[translations[category]] += 0
    return spending


#compares user with others
def getPercentChangeFromAverage(customerID, depositsJson, transfersJson, categories, translations):
    revenues = {}
    numAccounts = 0
    averages = {}
    for key in categories:
        averages[key] = 0
    for deposit in depositsJson['results']:
        if deposit['payee_id'] not in revenues:
            revenues[deposit['payee_id']] = 0
        try:
            revenues[deposit['payee_id']] += float(deposit['amount'])
        except:
            revenues[deposit['payee_id']] += 0
    customerRevenue = revenues[customerID]
    for id, revenue in revenues.items():
        if id != customerID:
            #if ((revenue-customerRevenue)/revenue)**2<=.1:
            #Commented out for data creation purposes, but the above would be used if the data in Nessie wasn't fake
            if revenue == customerRevenue:
                spending = getAccountDistribution(id, depositsJson, transfersJson, categories, translations)
                numAccounts+=1
                for key, value in spending.items():
                    if key not in averages:
                        averages[key] = 0
                    averages[key] += value*customerRevenue/revenue
    for key, value in averages.items():
        averages[key] = averages[key]/numAccounts
    zeroCategories = list()
    for key, value in averages.items():
        if value == 0:
            zeroCategories.append(key)
    for key in zeroCategories:
        del averages[key]
    spending = getAccountDistribution(customerID, depositsJson, transfersJson, categories, translations)
    percentChange = {}
    for key, value in averages.items():
        percentChange[key] = (spending[key]-value)/value*100
    zeroCategories.clear()
    for key, value in percentChange.items():
        if value <= 0:
            zeroCategories.append(key)
    for key in zeroCategories:
        del percentChange[key]
    return percentChange

# brackets, You could spend less in.... (suggest)
def findBestAlternatives(customerID, depositsJson, transfersJson, categories, translations, category, merchantsJson):
    idToName = {}
    for merchant in merchantsJson['results']:
        if 'name' in merchant:
            idToName[merchant['_id']] = merchant['name'].title()
        else:
            idToName[merchant['_id']] = ['Unknown']
    idToCategory = {}
    for merchant in merchantsJson['results']:
        if 'category' in merchant:
            idToCategory[merchant['_id']] = merchant['category']
        else:
            idToCategory[merchant['_id']] = ['Unknown']
    revenues = {}
    numAccounts = 0
    averages = {}
    for key in categories:
        averages[key] = 0
    for deposit in depositsJson['results']:
        if deposit['payee_id'] not in revenues:
            revenues[deposit['payee_id']] = 0
        try:
            revenues[deposit['payee_id']] += float(deposit['amount'])
        except:
            revenues[deposit['payee_id']] += 0
    customerRevenue = revenues[customerID]
    alternatives = {}
    for id, revenue in revenues.items():
        if id != customerID:
            # if ((revenue-customerRevenue)/revenue)**2<=.1:
            # Commented out and made the below == for data creation purposes, but the above would be used if the data in Nessie wasn't fake
            if revenue == customerRevenue:
                for transfer in transfersJson['results']:
                    if id == transfer['payer_id']:
                        if category in idToCategory[transfer['payee_id']]:
                            if idToName[transfer['payee_id']] not in alternatives:
                                alternatives[idToName[transfer['payee_id']]] =0
                            alternatives[idToName[transfer['payee_id']]] +=1
    max = -1
    maxKey = "None"
    for key, value in alternatives.items():
        if value > max:
            max = value
            maxKey = key
    return maxKey



@app.route('/todo/api/v1.0/datavis/<string:data_id>', methods=['GET'])
def get_data_id(data_id):
    data = [data for data in data_list if data['id'] == data_id]

    print(len(accountsJson))
    print(len(accountsJson['results']))


    return graphByCategory(data_id, merchantsJson, transfersJson, translations)


if __name__ == '__main__':
    app.run(debug=True)
