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


#depositRequest = "http://api.reimaginebanking.com/enterprise/deposits?key=c49ecda776f1db2451f202eb71f21c1d"
#depositsJson = requests.get(depositRequest).json()

#with open(cwd+'/Data/depositsJson.txt', 'w+') as outfile:
#     json.dump(depositsJson, outfile)

categories = ['entertainment', 'transportation', 'food', 'health', 'shopping']

merchantsJson = json.load(open(cwd+'/Data/merchantsJson.txt'))
transfersJson = json.load((open(cwd+'/Data/transfersJson.txt')))
#customersJson = json.load((open(cwd+'/Data/customersJson.txt')))
accountsJson = json.load(open(cwd+'/Data/accountsJson.txt'))
depositsJson = json.load(open(cwd+ '/Data/depositsJson.txt'))


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


def getPercentSaved(customerID, accountsJson, transfersJson):
    spending = 0
    revenue = -1
    for transfer in transfersJson['results']:
        if transfer['payer_id'] == customerID:
            spending += transfer['amount']
    for deposits in depositsJson['results']:
        if deposits['payee_id'] == customerID:
            if revenue<0:
                revenue = 0
            revenue += deposits['amount']
    if revenue == 0 or revenue ==-1:
        return 0
    return spending/revenue*100

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




    


# cats = set()
# for merchant in ((merchantsJson['results'])):
#     if 'category' in merchant:
#         if type(merchant['category']) == list:
#             for c in merchant['category']:
#                 cats.add(c)
#         else:
#             cats.add(merchant['category'])
# print(cats)

# for i in range(len(accountsJson['results'])):
#     x = int(random.random()*len(accountsJson['results']))
#     print(x)
#     print(getPercentSaved(accountsJson['results'][x]['_id'], accountsJson, transfersJson))
#     print("Cash back", getCashBack(accountsJson['results'][x]['_id'], accountsJson, transfersJson, depositsJson))
#     if graphByMerchant(accountsJson['results'][x]['_id'], merchantsJson, transfersJson):
#         break
print("Percent saved",getPercentSaved("79c66be6a73e492741507b6b", accountsJson,transfersJson))
print("Cash back", getCashBack("79c66be6a73e492741507b6b", accountsJson,transfersJson, depositsJson))
#graphByMerchant("79c66be6a73e492741507b6b", merchantsJson,transfersJson)
#graphByCategory("79c66be6a73e492741507b6b", merchantsJson,transfersJson,translations)
print(getPercentChangeFromAverage("79c66be6a73e492741507b6b", depositsJson, transfersJson, categories, translations))
print(findBestAlternatives("79c66be6a73e492741507b6b", depositsJson, transfersJson, categories, translations, "health", merchantsJson))

#681 is solid