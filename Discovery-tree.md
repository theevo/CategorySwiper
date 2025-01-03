# Discovery Tree

## UI

- Format date

- display no action taken when no update returns false

- ✅ make "Uncategorized" category the default placeholder
    - ✅ refactor: find() will return placeholder Category if not found
    - ✅ "Uncategorized" vs "No Matching Category"[^19]
    - ✅ add previews for uncategorized Transaction
        - ✅ CategoriesSelectorView
        - ✅ CardView
    - ✅ add example of uncategorized Transaction

- 4 states
    - ✅ onAppear calls load -> Spinner
    - ✅ load returns no transactions -> NoTransactionsView
    - ✅ load returns transactions -> swipe cards
    - all cards swiped -> SwipedAllCardsView, batch API updates calls

- 👟 First run
    - 👉 create StatesView[^13]
        - inform StatesView when SwipeableCardsView swiping complete
            - create tests for isDoneSwiping
                - test given transactions not empty, when all cards swiped, swipedCards has correct directions
                - ✅ investigate replacing protocol func with closure property[^23]
                - ✅ test given transactions not empty, when all cards swiped, then doneSwiping is true[^22]
                - ✅ test when transactions empty, then isDoneSwiping is false
        - ✅ create ViewModels from within InterfaceManager[^15]
        - ✅ move AppStates into InterfaceManager
        - ✅ absorb the conditional logic of SwipeableCardsModel's state[^14]
    - 🔀 fix SwipeableCardsView preview 0[^11][^14]
        - ❌ add InterfaceManager.empty[^12][^14]
        - ✅ make InterfaceManager the source of truth 
        - ✅ rename CardView param from transaction to card  
    - ✅ inject InterfaceManager.categories when editing
    - ✅ convert Transactions to SwipeableCardsModel[^10]
    - ✅ load InterfaceManager with transactions, categories
    - ✅ inject InterfaceManager as EnvironmentObject
    - ✅ Delete ContentView

- ✅ CategoriesSelectorView
    - ✅ disable swiping down to dismiss modal
    - ✅ workaround: show selected item at the top 
        - ✅ show parent of selected item
        - ✅ show selected item at the top
    - ✅ make it selectable
        - ✅ make group names not selectable, children selectable
            - ❓ scroll to the bottom if the last item is selected[^4]
            - ✅ disable group names
            - ✅ indent children in Picker
        - ❌ add checkmarks like in Settings > General > Dictionary (`pickerStyle: .inline` can)
            - ✅ make it work with Picker[^3]
    - ✅ show children under groups
    - ✅ show all categories flat 

- ✅ create InterfaceManager to manage Network (live app) vs Local (SwiftUI Preview)
    - ✅ tidy up calls from tests[^9]
    - ✅ update transaction status
    - ✅ get transactions
    - ✅ update transaction category
    - ✅ get categories
    - ✅ call async vs non-async func[^8]

- ✅ Connect swipe with behavior
    - ✅ swipe left calls LMNetworkInterface.update
        - ✅ find where update should be called
            - ✅ update category with local interface
                - ✅ call update
                - ✅ implement update category for LMLocalInterface
            - ✅ create method to facilitate update of transaction's category
        - ✅ show CategoriesSelectorView as modal after swipe left
            - ✅ make SwipeableCardsView.cardToEdit an obvious dummy
            - ✅ fix selected category name in CategoriesSelectorView
            - ✅ add Environment dismiss
            - ✅ add Binding bool showingSheet
            - ✅ make the SwipeableCardsView.cardToEdit not optional[^7]
            - ❌ fetch all Categories during CategoriesSelectorViewModel.init[^6]
            - ✅ show Merchant name and amount in CategoriesSelectorView
                - ✅ handle empty case
                - ✅ remove failable init; return first if find fails
                - ✅ init CategoriesSelectorViewModel with 2 params: categories, card
                - ❌ synthesize Category in CardViewModel.init[^5]
                - ✅ init CategoriesSelectorViewModel with CardViewModel
                    - ✅ search children for category
            - ✅ send Transaction's category to modal
            - ✅ show modal after last card swiped left
                - ✅ share state of showingSheet
            - ✅ show simple modal after swipe left
    - ✅ find where UI calls update
        - ✅ implement for swipe right

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

- ✅ investigate API response for date range[^21]
    - ✅ change urlResponse to httpResponse 

- ✅ stop View from loading during testing[^17]

- ✅ query by month
    - ✅ integrate MonthRangeBuilder in LMQueryParams
    - ✅ generate strings for first, last day of month
        - ✅ format in ISO8601 (YYYY-MM-DD)
        - ✅ test Time package[^18]
    - ✅ refactor Filters (now LMQueryParams)
        - ✅ make StartDate and EndDate travel together
        - ✅ rename to LMQueryParams
        - ✅ create 2 groups: Transactions, Categories
        - ✅ allow getTransactions to accept only LMQueryParams.Transactions
        - ✅ allow getCategories to accept only LMQueryParams.Categories
    - ✅ get transactions from previous month (12/2024)
    - ✅ fix tests due to InterfaceManager changes
        - ✅ @MainActor
        - ✅ dataSource param

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

- ✅ update transaction category
    - ✅ refactor: rename to `Request.updateTransactionSTATUS` 
    - ✅ refactor: improve branching in Request.makeRequest()
    - ✅ get true in response
        - ✅ make UpdateTransactionObject properties optional
    - ❓ Filter.CategoryFormatIsNested should only apply to getCategories
    - ✅ get categories
        - ✅ add getCategories to LunchMoneyInterface protocol
        - ✅ create Decodable structs
        - ✅ add LMNetworkInterface.getCategories()
        - ✅ remove getCategories() from URLSessionBuilder
        - ✅ rename LunchMoneyTransactionLoader (we're working with categories too!)
        - ✅ choose flattened or **nested**[^2]


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

- Surface uncleared transactions before current month
    - why? the web app offers no visual indication if transactions in previous months are uncleared unless you change the date range. the web app only surfaces uncleared transactions for the date range you specify. this date range defaults to the current month.
    - could it be less of a grind? rather than make the user advance backward in time in 1 month increments, could we make it appear intelligent? get one year's worth of transactions and limit the search to 1 uncleared transaction. "You have uncleared transactions from MM/YY." "Let's go" Button will jump the user to that month.
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
- History
    - transaction + action you took
    - http links to changes
- relay 404 status code errors ([example](https://lunchmoney.dev/#update-transaction))


[^1]: a putRequest requires a PutBodyObject, which requires a Transaction 
[^2]: [Get All Categories](https://lunchmoney.dev/#get-all-categories) takes an optional Query param: Flattened (default) or Nested. Flattened will show a Category more than once if it belongs to a Category Group. The said category appears the first time in the "first level" of the array (as if it had no parent) and a second time as a child of the Group (within its children array). Either way, you want to present your UI in a tree like structure. I think Flattened makes sense if you prefer piecing together the child with its parent by its id. On the other hand, you could get the same result with Nested by traversing into children array when you reach a Category Group. With Nested, there's never a fear of duplicating a category.
[^3]: Valuable lessons learned from using my own ViewModel with Picker: 1) make the ViewModel conform to ObservableObject 2) if your selection: parameter is an instance of yourObject, add `.tag(yourObject)` next to `Text(yourObject.name)`. This will let the Picker know you are selecting this instance of yourObject and not the string `name`. 3) add `@Published` to the properties of the ViewModel to receive 2-way binding in the View.
[^4]: I tried wrapping `CategoriesSelectorView.body` with a `ScrollViewReader` so I could call `proxy.scrollTo(model.selectedCategory)`, but it does not work. My guess is that the proxy can't see it. It would likely require creation of a new view, which I'm not willing to do at this time for such a small feature. 
[^5]: This is not technically possible. To make this possible, `Category` would need to see the list of categories and then search for the `Category` by the card's category id. Currently, I've only given this list to `CategoriesSelectorViewModel`, so I can continue to develop with just this. I need to remember that `CategoriesSelectorView` needs a list of categories and provides the selected category. Since it's already holding on to the list, it can synthesize a Category from the incoming Card.
[^6]: Changed my mind. I think some other object will inject the list of categories.
[^7]: At some point, you must create certainty. You can't hide a nil value forever.
[^8]: I declared the LunchMoneyInterace protocol with `async throws`. It seems that if that is the type that is used, Swift assumes that you will be calling it with async even if the concrete type doesn't use async.
[^9]: Interesting refactor. If you write do-try-catch in a test, you can add `throws` to the test method and remove the do-try-catch frame, leaving the contents of the do block.
[^10]: It doesn't feel right for a View to initiate an API call and then transform the received data into ViewModels. Curious if there's a better way.
[^11]: Having a "0" preview is ambiguous. There are two unique states where transactions could be zero. First, if we load transactions and the return completes with no new transactions. Second, we load 1+ transactions and swipe through all of them. I wonder if the states can be clearly captured in a single view. This will be necessary for MVP but not necessary for a First Run. 
[^12]: Not possible if the view calls manager.load. Maybe we need a 3rd LMInterface named LMLocalEmptyInterface?
[^13]: Because I present a sheet after the card is swiped left, the removal of the said card takes place BEFORE the user chooses a new category. I'm not sure how the app can know to watch the swipedCards array for a recently appended card that was swiped left and then call the API to update its category. Another possibility, which seems inevitable now, is to process all swipedCards in batch after all swiping is complete.
[^14]: I'm embracing non-linear development. I was able to accomplish returning zero transactions by creating a new LunchMoneyInterface: LMEmptyInterface. What forced this to happen was the need for an empty case in the just minted StatesView.
[^15]: I decided to address the nested ObservableObjects problem by making the ViewModels simple structs, removing their ObservableObject conformance, and making them Published properties of InterfaceManager. Blogger [rhonabwy](https://rhonabwy.com/2021/02/13/nested-observable-objects-in-swiftui/) suggests rethinking the model. Taking manual control of Publshing seems like a huge distraction to this app, and this seemed like a necessary evil to achieve a first run.
[^16]: My wish to have separation between query params that belong to two distinct groups ran into a problem. These query params feed into a URLRequest builder which demanded a concrete type. How do I satisfy this need to have separation between the groups and not duplicate the URLRequest builder in order to satistfy each group? Answer: Protocol. I can tell the URLRequest builder that it will receive some type that conforms to the Protocol. Each group will conform to the protocol. 😸
[^17]: The print statements I added in InterfaceManager revealed that my app was loading data from Production during unit testing. The solution turned out to be quite simple. Thank you, Reid-San. [Bypass SwiftUI App Launch During Unit Testing](https://qualitycoding.org/bypass-swiftui-app-launch-unit-testing/)
[^18]: Dave DeLong's Swift Package: [Time](https://github.com/davedelong/time)
[^19]: Discovered a strange case in CategoriesSelectorView. (This likelihood of this happening is small, but it bugs me). "Uncategorized" is the category name given to a transaction when its `category_id` is nil. If a Transaction has a non-nil `category_id`, what if it doesn't match against list of categories? "Uncategorized" would be wrong, because it is categorized; we just can't find it's category in our category list. "No matching Category" is one way to describe this scenario. My problem here is I can't tell if the nil selectedCategory was passed in the first place or written there because it wasn't found during the `find()`. The ugly way to do it is to `find()` again before returning the string name. Rather than say "No matching Category", I will suffix the CardViewModel's category name with "❌🔎"
[^20]: Refactor: rather than selectedCategoryName run another `find()`, I could have `find()` return a placeholder Category with the name "\(card.categoryName) ❌🔎"
[^21]: If a date range is not specified for a GET request of all transactions, the server will process the request with the current month. Does the response contain the date range? Honestly, I'm expressing laziness at the idea of implementing a date range UI. It seems inevitable. 😮‍💨 Answer: it does not. `httpResponse.url = Optional(https://dev.lunchmoney.app/v1/transactions?status=uncleared)`
[^22]: async problem. InterfaceManager(.Local) loads Transactions which is async according to the protocol LunchMoneyInterface. test completes before the transactions load. Solution: Protocol. if a protocol function is marked `async`, then the compiler will enforce calls with `await` even if the concrete type is not async. We create a new protocol, duplicate the function signature without the `async`, then conform it to the Protocol that requires `async`. Now this has me thinking about protocol functions as stored properties. rather than defining async in the protocol function, can we instead require a stored property of type closure instead. Can this stored property be async?
[^23]: A closure property must also be declared as `async` or `throws`. It seems you can't hide away this fact. If the body says `await` or `try`, the compiler won't budge until you make the correct declarations. 
