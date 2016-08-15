//
//  Planet.swift
//  Star Wars: The API Awakens
//
//  Created by Joe Sherratt on 14/08/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import Foundation

struct Planet {
    
    var name: String?
    
    init(json: [String : AnyObject]) throws {
        
    guard let name = json["name"] as? String else { throw StarWarsError.IncompleteData }
    
        self.name = name
    }
}