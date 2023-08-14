//
//  IAPHandler.swift
//  WealthLeaderboard
//
//  Created by Benjamin Sage on 7/3/23.
//

import Foundation
import StoreKit

enum IAPHandlerAlertType {
    case setProductIds
    case disabled
    case purchased
    case failed
    
    var message: String {
        switch self {
        case .setProductIds: return "Product ids not set, call setProductIds method!"
        case .disabled: return "Purchases are disabled in your device!"
        case .purchased: return "You've successfully bought this purchase!"
        case .failed: return "Failed"
        }
    }
}


class IAPHandler: NSObject {
    static let shared = IAPHandler()
    private override init() { }
    
    fileprivate var productIds = ["unlock"]
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var fetchProductCompletion: (([SKProduct])->Void)?
    
    fileprivate var productToPurchase: SKProduct?
    fileprivate var purchaseProductCompletion: ((IAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)?
    
    var isLogEnabled: Bool = true
        
    func setProductIds(ids: [String]) {
        self.productIds = ids
    }

    var canMakePurchases: Bool { SKPaymentQueue.canMakePayments() }
    
    func purchase(product: SKProduct, completion: @escaping ((IAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)) {
        
        self.purchaseProductCompletion = completion
        self.productToPurchase = product

        if canMakePurchases {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            productID = product.productIdentifier
        }
        else {
            completion(IAPHandlerAlertType.disabled, nil, nil)
        }
    }
    
    func fetchAvailableProducts(completion: @escaping ( ([SKProduct]) -> Void) ) {
        self.fetchProductCompletion = completion
        
        if self.productIds.isEmpty {
            print(IAPHandlerAlertType.setProductIds.message)
        } else {
            productsRequest = SKProductsRequest(productIdentifiers: Set(self.productIds))
            productsRequest.delegate = self
            productsRequest.start()
        }
    }
}

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let completion = self.fetchProductCompletion {
            completion(response.products)
        }
    }
        
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                if let completion = self.purchaseProductCompletion {
                    completion(IAPHandlerAlertType.purchased, self.productToPurchase, transaction)
                }
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                if let completion = self.purchaseProductCompletion {
                    completion(IAPHandlerAlertType.failed, self.productToPurchase, transaction)
                }
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}

