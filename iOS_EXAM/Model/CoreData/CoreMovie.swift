//
//  CoreMovie.swift
//  iOS_EXAM
//
//  Created by 700023 on 21/11/2018.
//
//

import Foundation
import CoreData

@objc(CoreMovie)
public class CoreMovie: NSManagedObject {
    
    convenience init?(movie: Movie, managedObjectContext: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "CoreMovie", in: managedObjectContext)!
        self.init(entity: entity, insertInto: managedObjectContext)
        
        self.movieCharacterUrls = movie.movieCharacterUrls
        self.movieTitle = movie.movieTitle
        self.movieEpisode = Int32(movie.movieEpisode)
        self.movieDirector = movie.movieDirector
        self.movieReleaseDate = movie.movieReleaseDate
        self.movieUrl = movie.movieUrl
        
    }
    
}
