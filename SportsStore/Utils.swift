//
//  Utils.swift
//  SportsStore
//
//  Created by Tim Pryor on 2015-09-12.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

import Foundation

class Utils {
    
    class func currencyStringFromNumber(number:Double)->String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        // a ?? b
        // nil coalescing operator unwraps an optional if a contains a value 
        // or returns default value b if a is nil
        // shorthand for:
        // a != nil a! : b
        return formatter.stringFromNumber(number) ?? ""   
        
    }
}