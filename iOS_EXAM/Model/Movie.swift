//
//  Movie.swift
//  iOS_EXAM
//
//  Created by 700023 on 20/11/2018.
//  A class that stores information about a Movie
//

import Foundation

struct Movie {
    
    var movieTitle: String
    var movieEpisode: Int
    var movieDirector: String
    var movieReleaseDate: String
    var movieCharacterUrls: [String]
    var movieUrl: String
    
    init?(response: [String: Any]) {
        guard let movieTitle = response["title"] as? String, let movieEpisode = response["episode_id"] as? Int, let movieDirector = response["director"] as? String, let movieReleaseDate = response["release_date"] as? String, let characterUrls = response["characters"] as? [String], let movieUrl = response["url"] as? String else {
            return nil
        }
        
        self.movieTitle = movieTitle
        self.movieEpisode = movieEpisode
        self.movieDirector = movieDirector
        self.movieReleaseDate = movieReleaseDate
        self.movieCharacterUrls = characterUrls
        self.movieUrl = movieUrl
    }
    
}
