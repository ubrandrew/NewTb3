mainCust = {"_id": "79c66be6a73e492741507b6b", "balance": 50000, "customer_id": "99c66be5a73e49274150728f", "nickname": "Dr.'s Account", "rewards": 24165, "type": "Checkings"}

otherCust = mainCust.copy()

otherCust['_id'] = "79c66be6a73e492741507b61"

#MainCust to Wal-Mart
mainTransfer = {"_id": "56c9c9dea2ed9af8125193de", "amount": 150, "description": "string", "medium": "balance", "payee_id": "5b06f3f8f0cec56abfa40bbc", "payer_id": "79c66be6a73e492741507b6b", "status": "cancelled", "transaction_date": "2016-02-20", "type": "p2p"}
transfer1 = mainTransfer.copy()
#MainCust to GameStop
transfer1['payee_id'] = "5b06f21ff0cec56abfa40ad2"

transfer2 = mainTransfer.copy()
#MainCust to Good Neighbor Pharmacy
transfer2['payee_id'] = "5b06f3dbf0cec56abfa40b99"

#OtherCust to Costco
otherTransfer = {"_id": "56c9c9dea2ed9af8125193de", "amount": 75, "description": "string", "medium": "balance", "payee_id": "5b06f3f8f0cec56abfa40bbe", "payer_id": "79c66be6a73e492741507b61", "status": "cancelled", "transaction_date": "2016-02-20", "type": "p2p"}

#To mainCust
mainDeposit = {"_id": "56c8dba2061b2d440baf43b5", "amount": 1000, "description": "string", "medium": "balance", "payee_id": "79c66be6a73e492741507b6b", "status": "cancelled", "transaction_date": "2016-02-20", "type": "deposit"}
#To otherCust
deposit1 = {"_id": "56c8dba2061b2d440baf43b5", "amount": 1000, "description": "string", "medium": "balance", "payee_id": "79c66be6a73e492741507b61", "status": "cancelled", "transaction_date": "2016-02-20", "type": "deposit"}

