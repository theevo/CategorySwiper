# Discovery Tree

## UI

- Format date

✅ Swipeable Cards
    ✅ SwipeableCardsView
        ✅ message when you reach bottom
        ✅ swipe
            ✅ gesture
            ✅ rename TransactionViewModel to CardViewModel 
            ✅ TransactionViewModel has swipe direction
            ✅ ObservableObject SwipeableCardsModel
        ✅ stack the cards
             ✅ get a variety of transactions
                 ✅ integrate into Preview
                 ✅ get N transactions from LocalTransactionLoader
                 ✅ TransactionsLoader becomes protocol
                     ✅ LocalTransactionsLoader loads from local JSON
                         ✅ integrate into tests
                     ✅ LunchMoneyTransactionsLoader actually loads from API
             ✅ ZStack
         ✅ make the CardView look like a card
             ✅ inject size
             ✅ add shadow and radius 
         rename Deck?
         ✅ inject array of TransactionViewModels
     ✅ TransactionViewModel: Identifiable

✅ Use the Transaction's Currency

✅ CardView
     ✅ TransactionViewModel
         ✅ TransactionViewModel Example
             ✅ Transaction Example


## Decode JSON

✅ abstract the JSONDecoder block

✅ Create Model 

## API calls

- Connect swipe with behavior
    - update Transaction

- Separate network vs local tests

✅ filter transactions where status is UNCLEARED
     ✅ Move Transaction into its own file

✅ Move NetworkInterface into its own file

✅ Wrap NetworkInterface in Result
     ✅ create type to hold Reponse (NetworkInterface.Response)

✅ inject good or bad key


✅ if 401 status, data.isEmpty? NO
	 ✅ assert contains "name: Error"

✅ assert status 200
	 ✅ handle optional URLSession

## Housekeeping
✅ remove example-transactions from git history
✅ change bearer token


## ✅ Rough Draft
	 ✅ rough draft UI
	✅ talk to API
		✅ bearer token

## Ideas

- Activity Log
