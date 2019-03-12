//
//  StarWarsCharacters.swift
//  iOS_EXAM
//
//  Created by 700023 on 20/11/2018.
//  A class that gets all characters from https://swapi.co/api with a webrequest and converts the response to character object and then returning back to the method caller with a closure
//

import Foundation
import Alamofire

struct StarWarsCharacters {
    
    func getAllCharacters(sendAllCharactersToCharacterPage: @escaping (_ characters: [Character]) -> ()) {
        let urlArray = ["https://swapi.co/api/people/?page=1", "https://swapi.co/api/people/?page=2", "https://swapi.co/api/people/?page=3"]
        var allCharacters = [Character]()
        var everythingIsFinished = 0
        
        for eachUrl in urlArray {
            Alamofire.request(eachUrl).responseJSON { (response) in
                if response.error == nil {
                    if let allDataJson = response.result.value as? [String: Any] {
                        if let allCharactersOnThisPage = allDataJson["results"] as? [[String: Any]] {
                            for characterJson in allCharactersOnThisPage {
                                if let character = Character(response: characterJson) {
                                    allCharacters.append(character)
                                }
                            }
                            
                            everythingIsFinished += 1
                            if everythingIsFinished == urlArray.count {
                                sendAllCharactersToCharacterPage(allCharacters)
                            }
                        }
                    }
                } else {
                    sendAllCharactersToCharacterPage([])
                }
            }
        }
    }
    
}
