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

    var canMakePurchases: Bool { SKPaymentQueue.canMakePayments()  }
    
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
            log(IAPHandlerAlertType.setProductIds.message)
            fatalError(IAPHandlerAlertType.setProductIds.message)
        } else {
            productsRequest = SKProductsRequest(productIdentifiers: Set(self.productIds))
            productsRequest.delegate = self
            productsRequest.start()
        }
    }
    
    //MARK:- Private
    fileprivate func log <T> (_ object: T) {
        if isLogEnabled {
            NSLog("\(object)")
        }
    }
}

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    // REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        
        if (response.products.count > 0) {
            if let completion = self.fetchProductCompletion {
                completion(response.products)
            }
        }
    }
        
    // IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction: AnyObject in transactions {
            if let paymentTrans = transaction as? SKPaymentTransaction {
                switch paymentTrans.transactionState {
                case .purchased:
                    log("Product purchase done")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let completion = self.purchaseProductCompletion {
                        completion(IAPHandlerAlertType.purchased, self.productToPurchase, paymentTrans)
                    }
                    break
                    
                case .failed:
                    log("Product purchase failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let completion = self.purchaseProductCompletion {
                        completion(IAPHandlerAlertType.failed, self.productToPurchase, paymentTrans)
                    }
                    break
                case .restored:
                    log("Product restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default:
                    break
                }
            }
        }
    }
}

