//
//  NetworkManager.swift
//  Star Wars: The API Awakens
//
//  Created by Joe Sherratt on 14/08/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import Foundation

//-----------------------
//MARK: Enums
//-----------------------
enum StarWars: Endpoint {
    
    case Characters
    case Vehicles
    case Starships
    
    var baseURL: NSURL {
        return NSURL(string: "http://swapi.co/api/")!
    }
    
    var path: String {
        
        switch self {
        case .Characters:
            return "people/"
            
        case .Vehicles:
            return "vehicles/"
            
        case .Starships:
            return "starships/"
        }
    }
    
    var request: NSURLRequest {
        
        let url = NSURL(string: path, relativeToURL: baseURL)!
        return NSURLRequest(URL: url)
    }
}

//-----------------------
//MARK: Classes
//-----------------------
final class StarWarsClient: APIClient {
    
    let configuration: NSURLSessionConfiguration
    lazy var session: NSURLSession = {
        return NSURLSession(configuration: self.configuration)
    }()
    
    init(configuration: NSURLSessionConfiguration) {
        self.configuration = configuration
    }
    
    convenience init() {
        self.init(configuration: .defaultSessionConfiguration())
    }
    
    //-----------------------
    //MARK: Character
    //-----------------------
    func fetchCharacters(completion: APIResult<[Character]> -> Void) {
        
        let request = StarWars.Characters.request
        
        fetch(request, parse: { json -> [Character]? in
                        
            if let characters = json["results"] as? [[String : AnyObject]] {
                                
                return characters.flatMap { characterDict in
                    
                    return try? Character(json: characterDict)
                }
                
            }else {
                return nil
            }
            
            }, completion: completion)
    }
    
    func fetchHomeForCharacter(character: Character, completion: APIResult<Planet> -> Void) {
        
        if let url = character.homeURL {
            
            let url = NSURL(string: url)!
            let request = NSURLRequest(URL: url)
                        
            fetch(request, parse: { json -> Planet? in
                
                if let planet: [String : AnyObject] = json {
                    
                    return try? Planet(json: planet)
                    
                }else {
                    return nil
                }
                
                }, completion: completion)
        }
    }
    
    func fetchVehiclesForCharacter(character: Character, completion: APIResult<Vehicle> -> Void) {
        
        if let urlArray = character.vehiclesURL {
            
            for url in urlArray {
                
                let url = NSURL(string: url)!
                let request = NSURLRequest(URL: url)
                
                fetch(request, parse: { json -> Vehicle? in
                    
                    if let vehicle: [String : AnyObject] = json {
                        
                        return try? Vehicle(vehicleNameJson: vehicle)
                        
                    }else {
                        return nil
                    }
                    
                    }, completion: completion)
            }
        }
    }
    
    func fetchStarshipsForCharacter(character: Character, completion: APIResult<Starship> -> Void) {
        
        if let urlArray = character.starshipsURL {
            
            for url in urlArray {
                
                let url = NSURL(string: url)!
                let request = NSURLRequest(URL: url)
                
                fetch(request, parse: { json -> Starship? in
                    
                    if let starship: [String : AnyObject] = json {
                        
                        return try? Starship(starshipNameJson: starship)
                        
                    }else {
                        return nil
                    }
                    
                    }, completion: completion)
            }
        }
    }
    
    func minMax(characters: [Character]) -> (smallest: Character, largest: Character) {
        
        let sortedCharacters = characters.sort { $0.height < $1.height }
        
        return (sortedCharacters.first!, sortedCharacters.last!)
    }
    
    //-----------------------
    //MARK: Vechicles
    //-----------------------
    func fetchVehicles(completion: APIResult<[Vehicle]> -> Void) {
        
        let request = StarWars.Vehicles.request
        
        fetch(request, parse: { json -> [Vehicle]? in
                        
            if let vehicles = json["results"] as? [[String : AnyObject]] {
                
                return vehicles.flatMap { vehicleDict in
                                        
                    return try? Vehicle(json: vehicleDict)
                }
                
            }else {
                return nil
            }
            
            }, completion: completion)
    }
    
    func minMax(vehicles: [Vehicle]) -> (smallest: Vehicle, largest: Vehicle) {
        
        let sortedVehicles = vehicles.sort { $0.length < $1.length }
        
        return (sortedVehicles.first!, sortedVehicles.last!)
    }
    
    //-----------------------
    //MARK: Starships
    //-----------------------
    func fetchStarships(completion: APIResult<[Starship]> -> Void) {
        
        let request = StarWars.Starships.request
        
        fetch(request, parse: { json -> [Starship]? in
                        
            if let statships = json["results"] as? [[String : AnyObject]] {
                
                return statships.flatMap { starshipDict in
                    
                    return try? Starship(json: starshipDict)
                }
                
            }else {
                return nil
            }
            
            }, completion: completion)
    }
    
    func minMax(starships: [Starship]) -> (smallest: Starship, largest: Starship) {
        
        let sortedStarships = starships.sort { $0.length < $1.length }
        
        return (sortedStarships.first!, sortedStarships.last!)
    }
}