//
//  CoreCharacter.swift
//  iOS_EXAM
//
//  Created by 700023 on 21/11/2018.
//
//

import Foundation
import CoreData

@objc(CoreCharacter)
public class CoreCharacter: NSManagedObject {
    
    convenience init?(character: Character, managedObjectContext: NSManagedObjectContext, characterIds: String? = nil, characterAllMovieTitles: String? = nil) {
        
        let entity = NSEntityDescription.entity(forEntityName: "CoreCharacter", in: managedObjectContext)
        self.init(entity: entity!, insertInto: managedObjectContext)
        
        self.characterMovie = character.characterMovie
        self.characterName = character.characterName
        self.characterUrl = character.characterUrl
        self.characterEpisode = characterIds
        self.characterAllMovieTitles = characterAllMovieTitles
    }
    
}
