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
            return "a"
            
        case .Starships:
            return "a"
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
        
        print(request)
        
        fetch(request, parse: { json -> [Character]? in
            
            if let characters = json["results"] as? [[String : AnyObject]] {
                                
                return characters.flatMap { characterDict in
                    
                    return Character(json: characterDict)
                }
                
            }else {
                return nil
            }
            
            }, completion: completion)
    }
    
    func fetchCharacter(character character: Character, completion: APIResult<Character> -> Void) {
        
        if let url = character.url {
            
            let url = NSURL(string: url)!
            let request = NSURLRequest(URL: url)
            
            //print(request)
            
            fetch(request, parse: { json -> Character? in
                
                //print(json["results"]!)
                
                if let character: [String : AnyObject] = json {
                    
                    return Character(json: character)

                }else {
                    return nil
                }
                
                }, completion: completion)
        }
    }
    
    func fetchHomeForCharacter(character: Character, completion: APIResult<Planet> -> Void) {
        
        if let url = character.homeURL {
            
            let url = NSURL(string: url)!
            let request = NSURLRequest(URL: url)
                        
            fetch(request, parse: { json -> Planet? in
                
                if let planet: [String : AnyObject] = json {
                    
                    return Planet(json: planet)
                    
                }else {
                    return nil
                }
                
                }, completion: completion)
        }
    }
    
    func minMax(characters: [Character]) -> (smallest: Character, largest: Character) {
        
        let sortedCharacters = characters.sort { $0.height < $1.height }
        
        return (sortedCharacters.first!, sortedCharacters.last!)
    }
    
    //-----------------------
    //MARK: Vechicles
    //-----------------------
    
    
    //-----------------------
    //MARK: Starships
    //-----------------------
    
    
    
    
    
    
    
    
    
    
    
    
    
}