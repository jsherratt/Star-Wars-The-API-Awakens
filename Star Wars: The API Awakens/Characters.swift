//
//  Characters.swift
//  Star Wars: The API Awakens
//
//  Created by Joe Sherratt on 14/08/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import Foundation

enum Gender: String {
    
    case Male = "Male"
    case Female = "Female"
    case Unknown = "Unkown"
}

struct Character {
    
    var name: String?
    var birthyear: String?
    var home: String?
    var height: Int?
    var eyeColor: String?
    var hairColor: String?
    
    var homeURL: String?
    var url: String?
    
    init(json: [String : AnyObject])  {
        
        guard let name = json["name"] as? String, let birthyear = json["birth_year"] as? String, let homeURL = json["homeworld"] as? String, let url = json["url"] as? String, let height = json["height"] as? String, let eyeColor = json["eye_color"] as? String, let hairColor = json["hair_color"] as? String else { return }
        
        self.name = name
        self.birthyear = birthyear
        self.height = Int(height)
        self.eyeColor = eyeColor
        self.hairColor = hairColor
        
        self.homeURL = homeURL
        self.url = url
    }
}