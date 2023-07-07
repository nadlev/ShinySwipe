//
//  IAPManager.swift
//  ShinySwipe iOS
//
//  Created by 99999999 on 26.06.2023.
//

import SwiftUI
import StoreKit

class IAPManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @Published var isPremiumUser: Bool = false
    @Published var products: [SKProduct] = []
    private let premiumProductId = "premium"

    override init() {
        super.init()
        fetchProducts()
        SKPaymentQueue.default().add(self)
        isPremiumUser = UserDefaults.standard.bool(forKey: premiumProductId)
    }

    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: [premiumProductId])
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !response.products.isEmpty {
            products = response.products
        }
    }

    func buyProduct(productId: String) {
        guard let product = products.filter({ $0.productIdentifier == productId }).first else { return }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                UserDefaults.standard.set(true, forKey: premiumProductId)
                isPremiumUser = true
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing, .deferred:
                break
            case .failed:
                if let error = transaction.error {
                    print("Transaction failed due to error: \(error.localizedDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            @unknown default:
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    // Implement this method if you want to add functionality to restore purchases
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
