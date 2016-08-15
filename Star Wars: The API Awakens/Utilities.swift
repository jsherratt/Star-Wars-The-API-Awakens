//
//  Utilities.swift
//  Star Wars: The API Awakens
//
//  Created by Joe Sherratt on 14/08/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import Foundation

//-----------------------
//MARK: Extensions
//-----------------------

//Capatalise first letter of a string
extension String {
    
    var first: String {
        return String(characters.prefix(1))
    }
    var uppercaseFirst: String {
        return first.uppercaseString + String(characters.dropFirst())
    }
}

//Convert from metric to english (imperial) units
extension Int {
    
    var englishUnits: Double {
        
        let number = Double(self) * 0.03
        
        return number
    }
    
    var usdUnits: Int {
        
        let number = Double(self) * 10.10
        
        return Int(number)
    }
}

extension Double {
    
    var englishUnits: Double {
        
        let number = Double(self) * 3.28
        
        return number
    }
}

//Round double to two decimal places
extension Double {
    
    func roundDecimal() -> Double {

        return round(self * 100) / 100
    }
}