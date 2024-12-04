# Discovery Tree

## UI

- Swipeable Cards
    - SwipeableCardsView
        - stack the cards
        - ✅ make the CardView look like a card
            - ✅ inject size
            - ✅ add shadow and radius 
        - rename Deck?
        - ✅ inject array of TransactionViewModels
    - ✅ TransactionViewModel: Identifiable

- Format date

✅ Use the Transaction's Currency

✅ CardView
    - ✅ TransactionViewModel
        - ✅ TransactionViewModel Example
            - ✅ Transaction Example


## Decode JSON

✅ abstract the JSONDecoder block

✅ Create Model 

## Refine API calls

✅ filter transactions where status is UNCLEARED
    - ✅ Move Transaction into its own file

✅ Move NetworkInterface into its own file

✅ Wrap NetworkInterface in Result
    - ✅ create type to hold Reponse (NetworkInterface.Response)

✅ inject good or bad key


✅ if 401 status, data.isEmpty? NO
	- ✅ assert contains "name: Error"

✅ assert status 200
	- ✅ handle optional URLSession

## Housekeeping
✅ change bearer token


## ✅ Rough Draft
	- ✅ rough draft UI
	- ✅ talk to API
		- ✅ bearer token
