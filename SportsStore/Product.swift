//
//  Product.swift
//  SportsStore
//
//  Created by Tim Pryor on 2015-09-12.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

import Foundation


class Product: NSObject, NSCopying {
    
    // private(set) means property can be read from code in other files in the same module
    // but set by code only in Productswift
    // has the effect of allowing the values to be set using the arguments passed to the
    // class initializer but not otherwise
    
    private(set) var name: String
    private(set) var productDescription: String
    private(set) var category: String
    
    // private hides whatever it is appled to from code outside the current file
    // has effect of making properties invisible to rest of appliction, because
    // it is only thing in the Product.swift file
    private var stockLevelBackingValue: Int = 0
    private var priceBackingValue: Double = 0
    
    init(name:String, description:String, category:String, price:Double, stockLevel:Int) {
        self.name = name
        self.productDescription = description
        self.category = category
        
        // initializers of subclasses invoke the initializer of their superclass, but 
        // this must be done after the stored properties have been set and before the computed
        // properties are used
        super.init()
        
        self.price = price
        self.stockLevel = stockLevel
    }
    
    var stockLevel: Int {
        get {
            return stockLevelBackingValue
        }
        set {
            stockLevelBackingValue = max(0, newValue)
        }
    }
    
    
    private(set) var price: Double {
        get { return priceBackingValue }
        set { priceBackingValue = max(1, newValue) }
    }
    
    var stockValue: Double {
        get {
            return price * Double(stockLevel)
        }
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
      //  return Product(name: self.name, description: self.description, category: self.category, price: self.price, stockLevel:self)
        return Product(name: self.name, description: self.productDescription, category: self.category, price: self.price, stockLevel: self.stockLevel)
    }
    
}


