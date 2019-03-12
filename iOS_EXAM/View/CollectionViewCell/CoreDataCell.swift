//
//  CoreDataCell.swift
//  iOS_EXAM
//
//  Created by 700023 on 22/11/2018.
//  This class is able to show core movies and core character, if the information about the character is not dowloaded, then you have the choice to fetch the data
//

import UIKit
import Alamofire

class CoreDataCell: UITableViewCell {
    
    @IBOutlet weak var favoriteTitleCoreData: UILabel!
    @IBOutlet weak var favoriteEpisodeCoreDate: UILabel!
    @IBOutlet weak var btnFetchMoreInformationAboutCharacter: UIButton!
    private var fetchMovieInformationRequest: Request?
    private var coreCharacter: CoreCharacter?
    private var updateCoreDataCharacter: UpdateCoreData!
    
    func setValueToUI(coreMovie: CoreMovie?, coreCharacter: CoreCharacter?, favoritePage: UIViewController) {
        self.updateCoreDataCharacter = favoritePage as? UpdateCoreData
        if let myCoreMovie = coreMovie {
            self.favoriteEpisodeCoreDate.isHidden = true
            self.btnFetchMoreInformationAboutCharacter.isHidden = true
            self.favoriteTitleCoreData.text = myCoreMovie.movieTitle
            self.accessoryType = .disclosureIndicator
        } else {
            self.accessoryType = .none
            self.favoriteTitleCoreData.text = coreCharacter!.characterName
            if let characterEpisodes = coreCharacter!.characterEpisode {
                self.btnFetchMoreInformationAboutCharacter.isHidden = true
                self.favoriteEpisodeCoreDate.isHidden = false
                self.favoriteEpisodeCoreDate.text = characterEpisodes
            } else {
                self.favoriteEpisodeCoreDate.isHidden = true
                self.coreCharacter = coreCharacter!
                self.btnFetchMoreInformationAboutCharacter.isHidden = false
            }
        }
    }
    
    @IBAction func fetchMovieInformation(_ sender: UIButton!) {
        if let allCharactersMovies = self.coreCharacter!.characterMovie {
            var index = 0
            for movieUrl in allCharactersMovies {
                self.fetchMovieInformationRequest = Alamofire.request(movieUrl).responseJSON(completionHandler: { (response) in
                    if response.error == nil {
                        if let movieResult = response.result.value as? [String: Any] {
                            if let movieEpisode = movieResult["episode_id"] as? Int, let movieTitle = movieResult["title"] as? String {
                                if self.coreCharacter!.characterEpisode != nil {
                                    self.coreCharacter!.characterEpisode!.append("\(movieEpisode), ")
                                } else {
                                    self.coreCharacter!.characterEpisode = "\(movieEpisode), "
                                }
                                
                                if self.coreCharacter!.characterAllMovieTitles != nil {
                                    self.coreCharacter!.characterAllMovieTitles?.append("\(movieTitle), ")
                                } else {
                                    self.coreCharacter!.characterAllMovieTitles = "\(movieTitle), "
                                }
                                index += 1
                                if self.coreCharacter!.characterMovie!.count == index {
                                    self.updateCoreDataCharacter.update(episodes: self.coreCharacter!.characterEpisode, movies: self.coreCharacter!.characterAllMovieTitles, characterName: self.coreCharacter!.characterName, error: false)
                                }
                            }
                        }
                    } else {
                        print("Error occured: " + response.error.debugDescription)
                        self.updateCoreDataCharacter.update(episodes: nil, movies: nil, characterName: nil, error: true)
                        //Error
                    }
                })
            }
        }
    }
    
}
