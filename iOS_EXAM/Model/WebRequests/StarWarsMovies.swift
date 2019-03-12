//
//  StarWarsMovies.swift
//  iOS_EXAM
//
//  Created by 700023 on 20/11/2018.
//  A class that gets all movies from https://swapi.co/api with a webrequest and converts the response to movie object and then returning back to the method caller with a closure

import Foundation
import Alamofire

struct StarWarsMovies {
    
    func getAllMovies(doneWithDownload: @escaping (_ allMovies: [Movie]) -> ()) {
        var allMovies: [Movie] = []
        Alamofire.request("https://swapi.co/api/films").responseJSON { (serverResponse) in
            if serverResponse.error == nil {
                if let serverJsonResult = serverResponse.result.value as? [String: Any] {
                    if let allMoviesJson = serverJsonResult["results"] as? [[String: Any]] {
                        for movie in allMoviesJson {
                            if let theMovie = Movie(response: movie) {
                                allMovies.append(theMovie)
                            }
                        }
                    }
                    doneWithDownload(allMovies)
                }
            } else {
                doneWithDownload([])
            }
        }
    }
    
}
