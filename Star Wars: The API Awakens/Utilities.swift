//
//  Utilities.swift
//  Star Wars: The API Awakens
//
//  Created by Joe Sherratt on 14/08/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import UIKit

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

extension UIViewController {
    
    func displayAlert(title title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alertAction) -> Void in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

//Extension of UITextField to add a max length property to a text field that can be set in interface builder

private var maxLengths = [UITextField: Int]()

extension UITextField {
    
    //set the maxLength property with @IBInspectable to make it available to Interface Builder.This then provides an editor for its value in the Attributes Inspector
    @IBInspectable var maxLength: Int {
        
        get {
            
            //Filter out cases where no maximum length has been defined for the text field, in which case, simply return the theoretical maximum string size
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set {
            
            maxLengths[self] = newValue
            
            //Use addTarget in maxLength‘s setter to ensure that if a text field is assigned a maximum length, the limitLength method is called whenever the text field’s contents change
            addTarget(self, action: #selector(limitLength), forControlEvents: UIControlEvents.EditingChanged)
        }
    }
    
    func limitLength(textField: UITextField) {
        
        //Any case that gets past this is one where the text about to go into the text field is longer than the maximum length
        guard let prospectiveText = textField.text
            where prospectiveText.characters.count > maxLength else { return }
        
        let selection = selectedTextRange
        
        text = prospectiveText.substringWithRange(Range<String.Index>(prospectiveText.startIndex ..< prospectiveText.startIndex.advancedBy(maxLength)))
        selectedTextRange = selection
    }
}

