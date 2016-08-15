//
//  Characters.swift
//  Star Wars: The API Awakens
//
//  Created by Joe Sherratt on 14/08/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import Foundation

//-----------------------
//MARK: Structs
//-----------------------
struct Character {
    
    var name: String?
    var birthyear: String?
    var home: String?
    var height: Int?
    var eyeColor: String?
    var hairColor: String?
    
    var url: String?
    var homeURL: String?
    var vehiclesURL: [String]?
    var starshipsURL: [String]?
    
    init(json: [String : AnyObject]) throws {
        
        guard let name = json["name"] as? String, let birthyear = json["birth_year"] as? String, let height = json["height"] as? String, let eyeColor = json["eye_color"] as? String, let hairColor = json["hair_color"] as? String, let url = json["url"] as? String, let homeURL = json["homeworld"] as? String, let vehiclesURL = json["vehicles"] as? [String], let starshipsURL = json["starships"] as? [String] else { throw StarWarsError.IncompleteData }
        
        self.name = name
        self.birthyear = birthyear
        self.height = Int(height)
        self.eyeColor = eyeColor
        self.hairColor = hairColor
        
        self.url = url
        self.homeURL = homeURL
        self.vehiclesURL = vehiclesURL
        self.starshipsURL = starshipsURL
    }
}