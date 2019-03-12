//
//  CharacterPage.swift
//  iOS_EXAM
//
//  Created by 700023 on 20/11/2018.
//  A class to show all the characters in Star Wars
//

import UIKit
import CoreData

class CharacterPage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var characterCollectionView: UICollectionView!
    private var starWarsCharacters: [Character]!
    private var getStarWarsCharacters: StarWarsCharacters!
    
    override func viewDidLoad() {
        self.title = "Characters"
        self.tabBarItem = UITabBarItem(title: "Characters", image: nil, selectedImage: nil)
        characterCollectionView.delegate = self
        characterCollectionView.dataSource = self
        getStarWarsCharacters = StarWarsCharacters()
        starWarsCharacters = []
        self.getAllCharacters()
    }
    
    private func getAllCharacters() {
        getStarWarsCharacters.getAllCharacters { (characters) in
            self.starWarsCharacters = characters
            self.parseDataFromCoreDataToApi()
            self.characterCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return starWarsCharacters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCellId", for: indexPath) as? CharacterCell {
            cell.setValueToOutlet(character: starWarsCharacters[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if starWarsCharacters[indexPath.row].didSelect {
            removeFromFavorite(characterTapped: starWarsCharacters[indexPath.row])
            starWarsCharacters[indexPath.row].didSelect = false
        } else {
            addToFavorite(characterTapped: starWarsCharacters[indexPath.row])
            starWarsCharacters[indexPath.row].didSelect = true
        }
       
        if let cell = collectionView.cellForItem(at: indexPath) as? CharacterCell {
            cell.setValueToOutlet(character: starWarsCharacters[indexPath.row])
        }
    }
    
    private func parseDataFromCoreDataToApi() {
        var index = 0
        for character in self.starWarsCharacters {
            checkCoreMovie(character: character) { (found) in
                self.starWarsCharacters[index].didSelect = found
            }
            index += 1
        }
    }
    
    private func checkCoreMovie(character: Character, characterFound: @escaping (_ found: Bool) -> ()) {
        let characterRequest = NSFetchRequest<CoreCharacter>(entityName: "CoreCharacter")
        let characterDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let thisContext = characterDelegate.persistentContainer.viewContext
        let characterResult = try! thisContext.fetch(characterRequest)
        if !characterResult.isEmpty {
            for coreCharacter in characterResult {
                if let characterName = coreCharacter.characterName {
                    if characterName == character.characterName {
                        characterFound(true)
                        return
                    } else {
                        characterFound(false)
                    }
                }
            }
        } else {
            characterFound(false)
        }
        
    }
    
    private func addToFavorite(characterTapped: Character) {
        let characterDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let characterContext = characterDelegate.persistentContainer.viewContext
        CoreCharacter.init(character: characterTapped, managedObjectContext: characterContext)
        characterDelegate.saveContext()
    }
    
    private func removeFromFavorite(characterTapped: Character) {
        let characterDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let characterContext = characterDelegate.persistentContainer.viewContext
        let characterRemoveRequest = NSFetchRequest<CoreCharacter>(entityName: "CoreCharacter")
        let characterDataResult = try! characterContext.fetch(characterRemoveRequest)
        for character in characterDataResult {
            if let characterName = character.characterName {
                if characterName == characterTapped.characterName {
                    characterContext.delete(character)
                    characterDelegate.saveContext()
                    break
                }
            }
        }
    }
    
}
