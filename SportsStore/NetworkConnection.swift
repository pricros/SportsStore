//
//  NetworkConnection.swift
//  SportsStore
//
//  Created by Tim Pryor on 2015-10-07.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

/*
    NetworkConnection is the template for the objects managed in the object pool

*/


import Foundation

class NetworkConnection {
    
    // a dictionary containing the initial stock levels for the products
    private let stockData: [String: Int] = [
        "Kayak": 10, "Lifejacket": 14, "Soccer Ball": 32, "Corner Flags": 1,
        "Stadium": 4, "Thinking Cap": 8, "Unsteady Chair": 3,
        "Human Chess Board": 2, "Bling-Bling King": 4
    ]
    
    // this method looks up a product in the dictionary and returns the stock level value
    // NSThread.sleepForTimeInterval adds a random delay of one second to some requests
    func getStockLevel(name: String) -> Int? {
        NSThread.sleepForTimeInterval(Double(rand() % 2))
        return stockData[name]
    }
    
}