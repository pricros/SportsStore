//
//  ProductDataStore.swift
//  SportsStore
//
//  Created by Tim Pryor on 2015-10-08.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

import Foundation

/*
    ProductDataStore is the source for Product objects
    Product objects are obtained through the products property

*/

final class ProductDataStore {
    var callback: ((Product) -> Void)?
    private var networkQ: dispatch_queue_t
    private var uiQ: dispatch_queue_t
    lazy var products: [Product] = self.loadData()
    
    init() {
        networkQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        uiQ = dispatch_get_main_queue()
    }
    
    private func loadData() -> [Product] {
        for p in productData {
            // delays in getting stock information don't prevent more important tasks from 
            // being performed
            dispatch_async(self.networkQ) {
                let stockConn = NetworkPool.getConnection()
                let level = stockConn.getStockLevel(p.name)
                if (level != nil) {
                    p.stockLevel = level!
                    // when callback is handled, main application queue is used
                    // to ensure that updates are performed immediately and
                    // not deferred until the background tasks are completed
                    dispatch_async(self.uiQ) {
                        if (self.callback != nil) {
                            self.callback!(p)
                        }
                    
                    }
                }
                NetworkPool.returnConnection(stockConn)
            }
            
        }
        
        return productData
    }
    
    private var productData:[Product] = [
        
        Product(name: "Kayak", description: "A boat for one person", category: "Watersports", price: 275.0, stockLevel: 0),
        Product(name: "Lifejacket", description: "Protctive and fashionable", category: "Watersports", price: 48.95, stockLevel: 0),
        Product(name: "Soccer Ball", description: "FIFA-approved size and weight", category: "Soccer", price: 19.5, stockLevel: 0),
        Product(name: "Corner Flags", description: "Give your playing field a professional touch", category: "Soccer", price: 34.95, stockLevel: 0),
        Product(name: "Stadium", description: "Flat-packed 35,000-seat stadium", category: "Soccer", price: 79500.0, stockLevel: 0),
        Product(name: "Thinking Cap", description: "Improve your brain efficiency by 75%", category: "Chess", price: 16.0, stockLevel: 0),
        Product(name: "Unsteady Chair", description: "Secretly give your opponent a disadvantage", category: "Chess", price: 29.95, stockLevel: 0),
        Product(name: "Human Chess Board", description: "A fun game for the family", category: "Chess", price: 75.0, stockLevel: 0),
        Product(name: "Bling-Bling King", description: "Gold-plated, diamond-studed King", category: "Chess", price: 1200.0, stockLevel: 0),
    ]

}
