# Discovery Tree

## UI

- Format date

- ✅ CardView design: put expense details into gray box
    - ✅ look at more example transactions
        - ✅ allow the LocalTransactionLoader to shuffle

- ❌ CardView design: embed ReceiptView with torn bottom (see branch `receipt-design`)
    - ❌ breaks SwipeableCardsView. cannot swipe left.
    - ✅ embed in CardView
    - ✅ receipt tear at bottom
    - ✅ info top aligned

- ✅ Swipeable Cards
    - animate text of SwipedAllCardsView 🎉
    - ✅ zero transactions to start vs swiping until empty
    - ✅ improve animation if card does not cross swipeThreshold 
    - ✅ make card glow when swiped
        - ✅ glow the next card
        - ✅ glow to top card only
        - ✅ glow correctly in all SwipeDirections
    - SwipeableCardsView
        - rename to Deck?
        - ✅ message when you reach bottom
        - ✅ swipe
            - ✅ gesture
            - ✅ rename TransactionViewModel to CardViewModel 
            - ✅ TransactionViewModel has swipe direction
            - ✅ ObservableObject SwipeableCardsModel
        - ✅ stack the cards
             - ✅ get a variety of transactions
                 - ✅ integrate into Preview
                 - ✅ get N transactions from LocalTransactionLoader
                 - ✅ TransactionsLoader becomes protocol
                     - ✅ LocalTransactionsLoader loads from local JSON
                         - ✅ integrate into tests
                     - ✅ LunchMoneyTransactionsLoader actually loads from API
             - ✅ ZStack
         - ✅ make the CardView look like a card
             - ✅ inject size
             - ✅ add shadow and radius 
         - ✅ inject array of TransactionViewModels
     - ✅ TransactionViewModel: Identifiable

- ✅ Use the Transaction's Currency

- ✅ CardView
    - ✅ TransactionViewModel
         - ✅ TransactionViewModel Example
             - ✅ Transaction Example

## API calls

- ✅ divorce LunchMoney specifics from NetworkInterface (now URLSessionBuilder)
    - ✅ remove lunchMoney strings from URLSessionBuilder
    - ✅ refactor getTransactions similar to update(transaction:)
    - ✅ move access token from URLSessionBuilder to LMNetworkInterface
    - ✅ rename LunchMoneyURL to Request
    - ✅ inject URLRequest into URLSessionBuilder
    - ✅ move LunchMoney Codable structs to LMNetworkInterface
        - ✅ create new file for LMNetworkInterface (大きすぎます！)
    - ✅ move LunchMoneyURL from URLSessionBuilder to LMNetworkInterface
    - ✅ rename instances
        - ✅ LMLocalInterface() -> interface
        - LMNetworkInterface() -> interface
        - ✅ URLSessionBuilder() -> session
    - ✅ rename load(showUnclearedOnly:) to getTransactions(showUnclearedOnly:)
    - ✅ move URLSessionBuilder.Filter to LunchMoneyInterface
    - ✅ rename
        - ✅ NetworkInterface -> URLSessionBuilder
        - ✅ LoaderError.NetworkInterfaceError -> .SessionErrorThrown
        - ✅ TransactionLoader -> LunchMoneyInterface
        - ✅ LocalTransactionsLoader -> LMLocalInterface
        - ✅ LunchMoneyTransactionsLoader -> LMNetworkInterface

- ✅ getTransactions returns only TopLevelObject
    - ✅ rename TopLevelObject to TransactionsResponseWrapper
    - ✅ rename result to response in tests
    - ✅ remove of empty TopLevelObject var
    - ✅ remove statusCode from LMNetworkInterface
    - ❌ getTransactions throws error if statusCode is not 200 (it's already handled in URLSessionBuilder)

- Connect swipe with behavior
    - call LunchMoneyTransactionsLoader.update from UI
        - Distinguish between Preview (Local) vs Live (LunchMoney)
    - Edit Category UI
        - implement for swipe left
        - update transaction category
            - get categories
                - NetworkInterface.Filter.CategoryFormatIsNested should only apply to getCategories
                    - 👉 add getCategories to LunchMoneyInterface protocol
                    - ✅ create Decodable structs
                    - ✅ add LMNetworkInterface.getCategories()
                    - ✅ remove getCategories() from URLSessionBuilder
                    - ✅ rename LunchMoneyTransactionLoader (we're working with categories too!)
                - ✅ choose flattened or **nested**[^2]
    - ✅ find where UI calls update
        - ✅ implement for swipe right
    - ✅ update Transaction
        - ✅ implement in LocalTransactionsLoader
        - ✅ remove throws from NetworkInterface.update
        - ✅ unwrap Response.data
            - ✅ implement in LunchMoneyTransactionsLoader
            - ✅ add useful unit test
                - ✅ assert API returns updated:true
                - ✅ make 401 response code Result.failure
                - ✅ refactor URLSession
                    - ✅ eliminate force unwrap in baseURL
                    - ⁇ distinguish between BadURL and BadURLRequest
                    - ✅ eliminate invalid paths like LunchMoneyURL.GetTransactions.putRequest
                        - ✅ construct URLRequest according to case
                        - ✅ give UpdateTransaction Transaction, not id[^1]
                    - ✅ DRY URLRequest
                    - ✅ DRY URLSession, include config
            - ✅ make Response properties non-optional
        - ✅ wrap the UpdateTransaction object in a PutBody object (PUT can accept multiple parameters)
        - ✅ add update object to httpBody
        - ✅ UpdateTransaction object
        - ✅ append id of Transaction to URL as path component
        - ✅ PUT request
    - ✅ Separate network vs local tests

- ✅ filter transactions where status is UNCLEARED
     - ✅ Move Transaction into its own file

- ✅ Move NetworkInterface into its own file

- ✅ Wrap NetworkInterface in Result
     - ✅ create type to hold Reponse (NetworkInterface.Response)

- ✅ inject good or bad key


- ✅ if 401 status, data.isEmpty? NO
    - ✅ assert contains "name: Error"

- ✅ assert status 200
    - ✅ handle optional URLSession

## Housekeeping
- ✅ remove example-transactions from git history
    - ✅ remove redundant commits

- ✅ change bearer token

## ✅ Decode JSON

- ✅ abstract the JSONDecoder block
- ✅ Create Model 

## ✅ Rough Draft
- ✅ rough draft UI
- ✅ talk to API
    - ✅ bearer token

## Ideas for later

- Add Transaction.account_display_name
    - why? to help the user understand where the expense landed and to help them decide faster
- Activity Log
    - example: 5 transactions checked on Wednesday, 2 transactions checked on Tuesday
- Read Plaid metadata
    - why? PayPal strings are in there, not in the payee or original_name
- Choose your animation
    - crush
    - burn
    - alien abduction
    - holy fire
    - explode
    - float away

[^1]: a putRequest requires a PutBodyObject, which requires a Transaction 
[^2]: [Get All Categories](https://lunchmoney.dev/#get-all-categories) takes an optional Query param: Flattened (default) or Nested. Flattened will show a Category more than once if it belongs to a Category Group. The said category appears the first time in the "first level" of the array (as if it had no parent) and a second time as a child of the Group (within its children array). Either way, you want to present your UI in a tree like structure. I think Flattened makes sense if you prefer piecing together the child with its parent by its id. On the other hand, you could get the same result with Nested by traversing into children array when you reach a Category Group. With Nested, there's never a fear of duplicating a category.
