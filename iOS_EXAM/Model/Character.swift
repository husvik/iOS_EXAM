//
//  Character.swift
//  iOS_EXAM
//
//  Created by 700023 on 20/11/2018.
//  A Class that stores information about a Character
//

import Foundation

struct Character {
    
    var didSelect = false
    var characterName: String
    var characterMovie: [String]
    var characterUrl: String
    
    init?(response: [String: Any]) {
        guard let characterName = response["name"] as? String, let characterMovie = response["films"] as? [String], let characterUrl = response["url"] as? String else {
            return nil
        }
        
        self.characterName = characterName
        self.characterMovie = characterMovie
        self.characterUrl = characterUrl
    }
    
    
    
}
