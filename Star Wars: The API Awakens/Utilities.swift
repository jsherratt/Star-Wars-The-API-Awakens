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
extension String {
    
    var first: String {
        return String(characters.prefix(1))
    }
    var uppercaseFirst: String {
        return first.uppercaseString + String(characters.dropFirst())
    }
}

extension Int {
    
    var englishUnits: Double {
        
        let number = Double(self) / 30.48
        
        return number
    }
}

extension Double {
    
    func roundDecimal() -> Double {

        return round(self * 100) / 100
    }
}