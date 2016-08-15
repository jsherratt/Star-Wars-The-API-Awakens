//
//  Vehicle.swift
//  Star Wars: The API Awakens
//
//  Created by Joe Sherratt on 15/08/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import Foundation

enum VehicleType {
    
    case Vehicles
    case Starships
    case None
}

struct Vehicle {
    
    var name: String?
    var make: String?
    var cost: Int?
    var length: Double?
    var vehicleClass: String?
    var crew: Int?
    
    init(json: [String : AnyObject]) throws {
        
        guard let name = json["name"] as? String, let make = json["manufacturer"] as? String, let cost = json["cost_in_credits"] as? String, let length = json["length"] as? String, let vehicleClass = json["vehicle_class"] as? String, let crew = json["crew"] as? String else { throw StarWarsError.IncompleteData }
        
        self.name = name
        self.make = make
        self.cost = Int(cost)
        self.length = Double(length)
        self.vehicleClass = vehicleClass
        self.crew = Int(crew)
    }
    
    init(vehicleNameJson: [String : AnyObject]) throws {
        
        guard let name = vehicleNameJson["name"] as? String else { throw StarWarsError.IncompleteData }
        
        self.name = name
    }
}