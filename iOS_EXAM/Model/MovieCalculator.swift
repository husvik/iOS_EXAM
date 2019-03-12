//
//  MovieCalculator.swift
//  iOS_EXAM
//
//  Created by 700023 on 23/11/2018.
//  This class makes a movie suggestion by characters in core data.
//

import UIKit

protocol SetCustomViewValues {
    func setValues(algortihmName: String, mostPopularMovie: String)
}

class MovieCalculator {
    
    var algorithmArray = ["Never tell me the odds!", "Do. Or do not. There is not try", "No, I am your father", "May the 4 be with you", "The Force will be with you. Always", "Now, young Skywalker, you will die"]
    
    var arrayCounter = 0
    
    private var SetCustomViewValuesDataSource: SetCustomViewValues
    
    init(favoritePage: UIViewController) {
        SetCustomViewValuesDataSource = favoritePage as! SetCustomViewValues
    }
    
    private func getAlgorithName() -> String {
        let algorithmName = algorithmArray[arrayCounter]
        if arrayCounter == algorithmArray.count - 1 {
            arrayCounter = 0
        } else {
            arrayCounter += 1
        }
        return algorithmName
        
    }
    
    //loops the core characters and checks wich "films" from the api that is most popular, and calls protocol to update the custom recommendation view
    func findMostPopularMovie(coreCharacters: [CoreCharacter])  {
        var countTupleArray = [(String, Int)]()
        
        for character in coreCharacters {
            if let characterMovies = character.characterMovie {
                
                for url in characterMovies {
                    var theIndex = 0
                    while (theIndex < characterMovies.count) {
                        if url == characterMovies[theIndex] {
                            var index = 0
                            var foundIndex = -1
                            for tuple in countTupleArray {
                                if tuple.0 == url {
                                    foundIndex = index
                                }
                                index += 1
                            }
                            if (foundIndex != -1) {
                                countTupleArray[foundIndex].1 += 1
                            } else {
                                countTupleArray.append((url, 1))
                            }
                            
                        }
                        theIndex += 1
                    }
                    
                }
            }
        }
        
        var result: (String, Int)?
        for tuple in countTupleArray {
            if result != nil {
                if tuple.1 < result!.1 {
                    result = tuple
                }
            } else {
                result = tuple
            }
            
        }
        
        var movieWasFound = false
        if let theResult = result {
            for movie in MoviePage.allMovies {
                if (movie.movieUrl == theResult.0) {
                    movieWasFound = true
                    self.SetCustomViewValuesDataSource.setValues(algortihmName: self.getAlgorithName(), mostPopularMovie: movie.movieTitle)
                    break
                }
            }
            if !movieWasFound {
                self.SetCustomViewValuesDataSource.setValues(algortihmName: "", mostPopularMovie: "")
            }
        } else {
            print("Could not find any characters")
            self.SetCustomViewValuesDataSource.setValues(algortihmName: "", mostPopularMovie: "")
        }
    }
    
}
