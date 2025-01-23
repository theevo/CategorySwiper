# Discovery Tree

## UI

- Bug: clear items each time we enter swiping state

- 👉 Bug: app is stuck in Fetching state even after force quit[^33]
    - immediately load transactions after exiting Settings
    - ✅ show green check if the token is good
        - ✅ delete token
    - ✅ save LunchMoney Bearer Token securely
        - ✅ add Debounce to SecureField[^35]
    - ✅ create Settings menu
    - ✅ handle URLSession error

- ✅ Surface uncleared transactions before current month
    - ✅ bug: if last card is swiped left, the user cannot edit[^32]
        - ✅ bug: last card is swiped left, the state is stuck in swiping 
        - ✅ test isDoneSwiping
    - ✅ limit the number of swipes
    - ❌ batch clear transactions BEFORE asking for new ones[^31]
    - ✅ set state to Swiping after Go pressed
    - ✅ show small sheet with date of oldest
        - ✅ get transactions from previous months after swiping done
        - ✅ get transactions from previous months if nothing this month
        - ✅ refactor: rename to getUnclearedTransactions
        - ✅ get the oldest transaction
        - ✅ test `MonthRangeBuilder(:precedingMonthsBeforeThisMonth:)`
        - ✅ find 1 transaction from last 12 months
    - ✅ preview SwipedAllCardsView with transactions requiring scrolling 
    - ✅ edit NoTransactionsView to "no uncleared transactions this month" 

- ✅ make "Uncategorized" category the default placeholder
    - ✅ refactor: find() will return placeholder Category if not found
    - ✅ "Uncategorized" vs "No Matching Category"[^19]
    - ✅ add previews for uncategorized Transaction
        - ✅ CategoriesSelectorView
        - ✅ CardView
    - ✅ add example of uncategorized Transaction

- ✅ 4 states
    - ✅ onAppear calls load -> Spinner
    - ✅ load returns no transactions -> NoTransactionsView
    - ✅ load returns transactions -> swipe cards
    - ✅ all cards swiped -> SwipedAllCardsView, batch API updates calls

- ✅ UpdateProgressView
    - ✅ run 2 child spinners that complete parent spinner
    - ✅ create array of ProgressItems in InterfaceManager
        - ✅ run UpdateProgressViewModel on main thread
        - ✅ queue items from processSwipes
        - ✅ inject items via SwipedAllCardsView
        - ✅ make UpdateProgressView subview of SwipedAllCardsView
        - ❌ load sample items in local interface[^29]
    - ❌ init with CardViewModel[^28]
        - ✅ alias the closure
    - ✅ run 2 spinners
    - ✅ run 1 spinner for random amount of time

- ✅ First run
    - ✅ batch process the swipedCards
        - ✅ make `updateAndClear(newCategory:)` param optional
        - ✅ refactor: rename `LunchMoneyInterface.update()` to `updateAndClear()` 
        - ✅ update status and category in one call
            - ✅ refactor: rename UpdateTransactionCategory to UpdateCategoryAndClearStatus 
            - ✅ refactor: rename UpdateTransactionStatus to ClearStatus
            - ✅ consolidate PutBodyObject init
        - ✅ replace `update(transaction:newCategory:)` with `clear(transaction:)`
        - ✅ maintain original transaction in CardViewModel[^27]
            - ✅ refactor: ~~simplify~~ consolidate calls to update category
            - ✅ save new category in new optional property
            - ✅ remove changing of status in CardsModel
    - ✅ create StatesView[^13]
        - ✅ inform ~~StatesView~~ InterfaceManager when SwipeableCardsView swiping complete[^26]
            - call updateTopCardSwipeDirection from CategoriesSelectorView
                - ✅ fix tests
                    - ✅ refactor: DRY out setting of cleared status
                    - ✅ swipe left behavior changed. for loop is giving false expectations.
                    - ✅ check for cleared status
                - ✅ replace card in swipedCards array[^25]
                - ✅ update the card's category
            - ✅ create tests for isDoneSwiping
                - ✅ test given transactions not empty, when all cards swiped, swipedCards has correct directions[^24]
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

## States

- Fetching
    - Swiping
    - Fetch Error
    - Fetch Empty
- Fetch Error
    - Fetching
- Swiping
    - Done
- Done
    - Fetching
- Fetch Empty
    - Fetching

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
    - ✅ bearer token[^34]

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
- Format date
- prevent Preview from crashing if Save button pressed in CategoriesSelectorViewModel
- display no action taken when clear or updateAndClear returns false


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
[^24]: Thank goodness for tests. Uncovered a value-type behavior where if you get the first element of an array `var first = arr.first`, you're getting a copy. Anyway you go about it, you have to access index `[0]` to overwrite it.
[^25]: Never expected to use slight of hand here. Status quo: always remove from unswipedCards and append it to swipedCards. We need the removal from unswiped for the View's sake, but we can choose not to append if a card is swiped left (aka the old one). The bigger lesson here is to honor the Discovery Tree's need for little to no code. Keeping it high level with "replace the card" gave me room to maneuver; whereas if i wrote "pass around indexes so you can update the card later", i'm setting myself up for sabotage. My original thought of "replacement" was to find the card in the swipedCards and then remove it. But the code completion inspired something so deliciously simple that I couldn't ignore it: just append the updated card without regard of removing the old one. What if the old one was never there to begin with? For that to happen, I would have to not append the card that was just swiped left.
[^26]: It's tough keeping track of what can talk to what. The cardsModel cannot talk to its parent InterfaceManager to let it know that swiping is done. Instead, the InterfaceManager must poll the cardsModel and ask if swiping is done.
[^27]: I've given a lot of thought to LunchMoneyInterface guarding against wasteful API calls. if you swipe left and don't change the category, let's not burden the server. This makes absolute sense. That's not the case with update(transaction:newStatus:). Both swipe left and right will update status to cleared. If it's always going to happen, enforcement is not needed. This also has me thinking about whether or not SwipeableCardsModel should update a card's original transaction status. Given that we always clear every transaction, it seems I'm not writing the correct method. The protocol should not require update Transaction with new status, instead it should just CLEAR the transaction.
[^28]: My intention was to give CardViewModel a new property of type `Action`. While we're in the for loop of `processSwipes()`, we cannot assign the property of card, because it is a let. While I'm proud of myself for throwing closures around with relative ease, this just feels like too much to build. There has to be a better way.
[^29]: We cannot force InterfaceManager to load items from within UpdateProgressView, because InterfaceManager is built on the idea of a state machine, and the data won't load until it reaches a specific state (we swipe transactions, then we make Progress Items). Also, this bypassing completely destroys how the state machine is supposed to work. If we just force a bunch of sample data in there just for UpdateProgressView, how is it supposed to behave for StatesView? I'm trying to keep InterfaceManager out of the picture here and just let UpdateProgressView do its thing.
[^30]: I think limit returns the OLDEST transaction in the range.
[^31]: I wrote this with the intent to make an API call queue. After glancing at [Sundell's article](https://www.swiftbysundell.com/articles/a-deep-dive-into-grand-central-dispatch-in-swift/) on the matter, that felt like a long-term investment that would be better spent post-MVP. Could I get away with something simpler? I took a good look at `runTaskAndAdvanceState()` and concluded that indeed, the batch should be cleared by the time new transactions are fetched. I think placing a limit on the number of swipes is a good thing. It limits the number of transactions that can be batched, and it also prevents cognitive overload. If things get out of hand, I could also build in a 2 second delay before the searchPrecedingMonths starts. 
[^32]: If the last card is swiped left, the user will see the edit screen for brief moment and then see the SwipedAllCardsView. The previous transactions are batched, not the one that was "abandoned." The state advances to done before the user can change the category. Luckily, with the logic in place, the abandoned transaction is not cleared, since no new Category was given.
[^33]: I was definitely puzzled by this bug. It turns out that Environment Variables you add to a scheme don't work after the Simulator or physical iOS device (aka Run Destination) is no longer paired to a run session with Xcode. In other words, in order for an app to "see" Environment Variables, Xcode must run with that Run Destination.
[^34]: I revisited the topic of HTTP headers, because I was curious if they were encrypted over HTTPS. After looking at an [intro to URLSession](https://cocoacasts.com/networking-fundamentals-how-to-make-an-http-request-in-swift), I questioned why I put the Bearer token into the `URLSessionConfiguration` and not the `URLRequest.` This bloke wrote [an emotionally charged article](https://ampersandsoftworks.com/posts/bearer-authentication-nsurlsession/) about how he went through great lengths to discover that URLSesh Config was the answer. I had followed his advice from the beginning of this app's development without testing it myself, but now, after trying it myself with just URLRequest sans URLSesh Config, the bloke was absolutely right. URLSesh Config is absolutely required for Bearer tokens. I also want to credit this bloke for saving me hours of frustration.
[^35]: Ondrej wrote an excelllent post on the subject of a [debouncing text field](https://ondrej-kvasnovsky.medium.com/apply-textfield-changes-after-a-delay-debouncing-in-swiftui-af425446f8d8). Anselmus has a [good flow](https://medium.com/@anselmus.pavel/debouncing-user-input-in-swiftui-10dda5231bdf) for how to save the debounce value in the ViewModel after it's gone through the wringer.
