//
//  NetworkManager.swift
//  Star Wars: The API Awakens
//
//  Created by Joe Sherratt on 14/08/2016.
//  Copyright © 2016 jsherratt. All rights reserved.
//

import Foundation

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
    
    
    func fetchCharacters(completion: APIResult<[Character]> -> Void) {
        
        let request = StarWars.Characters.request
        
        print(request)
        
        fetch(request, parse: { json -> [Character]? in
            
            //print(json["results"]!)
                    
            if let characters = json["results"] as? [[String : AnyObject]] {
                
                //print(characters)
                
                return characters.flatMap { characterDict in
                    
                    return Character(json: characterDict)
                }
                
            }else {
                return nil
            }
            
            }, completion: completion)
    }
    
    func fetchCharacter(character: Character, completion: APIResult<Character> -> Void) {
        
        if let url = character.url {
            
            let url = NSURL(string: url)!
            let request = NSURLRequest(URL: url)
            
            print(request)
            
            fetch(request, parse: { json -> Character? in
                
                //print(json["results"]!)
                
                if let character = json as? [String : AnyObject] {
                    
                    return Character(json: character)

                }else {
                    return nil
                }
                
                }, completion: completion)
        }
    }
    
    
}