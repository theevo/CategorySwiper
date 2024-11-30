//
//  Transaction.swift
//  CategorySwiper
//
//  Created by Tana Vora on 11/29/24.
//

import Foundation

struct TopLevelObject: Decodable {
    var transactions: [Transaction]
}

struct Transaction: Decodable {
    var id: Int
    var date: String // "2024-11-01"
    var amount: String
    var to_base: Float // 261
    var currency: String // "usd"
    var payee: String // "Apple Card"
    var category_id: Int? // 909229
    var category_name: String? // "Groceries"
    var category_group_id: Int? // 984522
    var category_group_name: String? // "Food"
    var is_income: Bool
    var status: Status // "cleared"
    var created_at: String // "2024-11-02T19:10:02.328Z"
    var updated_at: String // "2024-11-10T21:51:30.898Z"
    
    /*
                
            
                "is_pending": false,
                "original_name": "APPLECARD GSBANK PAYMENT 51581010 WEB ID: 9999999999",
                
                "has_children": false,
                "group_id": null,
                "is_group": false,
                "asset_id": null,
                "asset_institution_name": null,
                "asset_name": null,
                "asset_display_name": null,
                "asset_status": null,
                "plaid_account_id": 139734,
                "plaid_account_name": "Theo Checking",
                "plaid_account_mask": "3753",
                "institution_name": "Chase",
                "plaid_account_display_name": "Checking",
                "plaid_metadata": "{\"account_id\":\"QP7J8rYNpdhqMX618eBru3YkxYX64nC9xkvXz\",\"account_owner\":null,\"amount\":261,\"authorized_date\":\"2024-11-01\",\"authorized_datetime\":null,\"category\":[\"Payment\",\"Credit Card\"],\"category_id\":\"16001000\",\"check_number\":null,\"counterparties\":[{\"confidence_level\":\"VERY_HIGH\",\"entity_id\":\"4rqo0YXdgJe3rDed2VoaEnWnLD67bmeMzXmqW\",\"logo_url\":\"https://plaid-counterparty-logos.plaid.com/apple_card_336.png\",\"name\":\"Apple Card\",\"phone_number\":null,\"type\":\"financial_institution\",\"website\":\"card.apple.com\"}],\"date\":\"2024-11-01\",\"datetime\":null,\"iso_currency_code\":\"USD\",\"location\":{\"address\":null,\"city\":null,\"country\":null,\"lat\":null,\"lon\":null,\"postal_code\":null,\"region\":null,\"store_number\":null},\"logo_url\":null,\"merchant_entity_id\":null,\"merchant_name\":\"Apple Card\",\"name\":\"APPLECARD GSBANK PAYMENT 51581010 WEB ID: 9999999999\",\"payment_channel\":\"other\",\"payment_meta\":{\"by_order_of\":null,\"payee\":null,\"payer\":null,\"payment_method\":null,\"payment_processor\":null,\"ppd_id\":null,\"reason\":null,\"reference_number\":null},\"pending\":false,\"pending_transaction_id\":\"Ev4byQ8xpZTLdzp87XVYHYypE9yK5rsdaM19d\",\"personal_finance_category\":{\"confidence_level\":\"VERY_HIGH\",\"detailed\":\"LOAN_PAYMENTS_CREDIT_CARD_PAYMENT\",\"primary\":\"LOAN_PAYMENTS\"},\"personal_finance_category_icon_url\":\"https://plaid-category-icons.plaid.com/PFC_LOAN_PAYMENTS.png\",\"transaction_code\":null,\"transaction_id\":\"4rZBag1LX5sr3MN1wBxDIe7OBmX4P5SJMLVbV\",\"transaction_type\":\"special\",\"unofficial_currency_code\":null,\"website\":null}",
                "source": "plaid",
                "display_name": "Apple Card",
                "display_notes": null,
                "account_display_name": "Checking",
                "tags":
                [],
                "external_id": null
     */
    
    ///  One of the following:
    /// - cleared: User has reviewed the transaction
    /// - uncleared: User has not yet reviewed the transaction
    /// - pending: Imported transaction is marked as pending. This should be a temporary state.
    enum Status: String, Decodable {
        case cleared
        case uncleared
        case pending
    }
}
