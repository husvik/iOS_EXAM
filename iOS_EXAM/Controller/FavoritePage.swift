//
//  FavoritePage.swift
//  iOS_EXAM
//
//  Created by 700023 on 21/11/2018.
//  A class to present users favorites
//

import UIKit
import CoreData

protocol UpdateCoreData {
    func update(episodes: String?, movies: String?, characterName: String?, error: Bool)
}

class FavoritePage: UIViewController, UITableViewDelegate, UITableViewDataSource, UpdateCoreData, NSFetchedResultsControllerDelegate, SetCustomViewValues {
    
    
    @IBOutlet weak var algorithNameLbl: UILabel!
    @IBOutlet weak var popularMovieNameLbl: UILabel!
    @IBOutlet weak var algorithmView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var coreMovie = [CoreMovie]()
    private var coreCharacters = [CoreCharacter]()
    private var checkActiveSegment = 0
    private var fetchCoreMovieCtr: NSFetchedResultsController<CoreMovie>!
    private var fetchCoreCharacterCtr: NSFetchedResultsController<CoreCharacter>!
    private var fetchCoreMovieRequest: NSFetchRequest<CoreMovie>!
    private var fetchCoreCharacterRequest: NSFetchRequest<CoreCharacter>!
    private var movieCalculator: MovieCalculator!
    
    
    override func viewDidLoad() {
        self.title = "Favorites"
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.algorithmView.isHidden = true
        self.movieCalculator = MovieCalculator.init(favoritePage: self)
        initFetchCoreData()
        
    }
    
    func initFetchCoreData() {
        fetchCoreMovieRequest = NSFetchRequest<CoreMovie>(entityName: "CoreMovie")
        fetchCoreMovieRequest.sortDescriptors = [NSSortDescriptor(key: "movieTitle", ascending: true)]
        
        fetchCoreCharacterRequest = NSFetchRequest<CoreCharacter>(entityName: "CoreCharacter")
        fetchCoreCharacterRequest.sortDescriptors = [NSSortDescriptor(key: "characterName", ascending: true)]
        
        fetchCoreMovieCtr = NSFetchedResultsController<CoreMovie>(fetchRequest: fetchCoreMovieRequest, managedObjectContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchCoreCharacterCtr = NSFetchedResultsController<CoreCharacter>(fetchRequest: fetchCoreCharacterRequest, managedObjectContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchCoreCharacterCtr.delegate = self
        fetchCoreMovieCtr.delegate = self
        do {
            try fetchCoreCharacterCtr.performFetch()
            try fetchCoreMovieCtr.performFetch()
        } catch let theError as NSError {
            print("Could not fetch from controller \(theError)")
        }
        
        if let allStoredMovies = fetchCoreMovieCtr.fetchedObjects, let allStoredCharacters = fetchCoreCharacterCtr.fetchedObjects {
            self.coreMovie = allStoredMovies
            self.coreCharacters = allStoredCharacters
            self.movieCalculator.findMostPopularMovie(coreCharacters: self.coreCharacters)
            self.tableView.reloadData()
        }
    }
    
    func setValues(algortihmName: String, mostPopularMovie: String) {
        if algortihmName != "" && mostPopularMovie != "" {
            self.algorithmView.isHidden = false
            self.algorithNameLbl.text = algortihmName
            self.popularMovieNameLbl.text = mostPopularMovie
        } else {
            self.algorithmView.isHidden = true
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == fetchCoreMovieCtr {
            if let newCoreMovies = controller.fetchedObjects as? [CoreMovie] {
                self.coreMovie = newCoreMovies
            }
        } else {
            if let newCoreCharacters = controller.fetchedObjects as? [CoreCharacter] {
                self.coreCharacters = newCoreCharacters
            }
        }
        self.movieCalculator.findMostPopularMovie(coreCharacters: self.coreCharacters)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CoreDataCell") as? CoreDataCell {
            if self.checkActiveSegment == 0 {
                cell.setValueToUI(coreMovie: self.coreMovie[indexPath.row], coreCharacter: nil, favoritePage: self)
            } else {
                cell.setValueToUI(coreMovie: nil, coreCharacter: self.coreCharacters[indexPath.row], favoritePage: self)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.checkActiveSegment == 0 {
            return self.coreMovie.count
        } else {
            return self.coreCharacters.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.checkActiveSegment == 0 {
            self.performSegue(withIdentifier: "sendToDetailPage", sender: self.coreMovie[indexPath.row])
        } else {
            var title = ""
            var message = ""
            var removeAlertAction: UIAlertAction!
            if coreCharacters[indexPath.row].characterAllMovieTitles != nil {
                title = "Info"
                message = coreCharacters[indexPath.row].characterAllMovieTitles!
                removeAlertAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (action) in
                    self.removeCharacterFromCoreData(incCharacterName: self.coreCharacters[indexPath.row].characterName!)
                })
            } else {
                title = "Error"
            }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            if removeAlertAction != nil {
                alertController.addAction(removeAlertAction)
            }
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func removeCharacterFromCoreData(incCharacterName: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let coreCharacters = try! context.fetch(NSFetchRequest<CoreCharacter>.init(entityName: "CoreCharacter"))
        
        for character in coreCharacters {
            if let theCharacterName = character.characterName {
                if theCharacterName == incCharacterName {
                    context.delete(character)
                    break
                }
            }
        }
    }
    
    func update(episodes: String?, movies: String?, characterName: String?, error: Bool) {
        if !error {
            if let myEpisodes = episodes, let myMovies = movies, let myCharacterName = characterName {
                self.updateCoreDataObject(incCharacterName: myCharacterName, episodes: myEpisodes, movies: myMovies)
                
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "Couldn't fetch data", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func updateCoreDataObject(incCharacterName: String, episodes: String, movies: String) {
        let delegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = delegate.persistentContainer.viewContext
        let allCharacters = try! context.fetch(NSFetchRequest<CoreCharacter>(entityName: "CoreCharacter"))
        for character in allCharacters {
            if let characterName = character.characterName {
                if characterName == incCharacterName {
                    character.characterEpisode = episodes
                    character.characterAllMovieTitles = movies
                    delegate.saveContext()
                    self.tableView.reloadData()
                    break
                }
            }
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.checkActiveSegment = 0
            self.tableView.reloadData()
        } else {
            self.checkActiveSegment = 1
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendToDetailPage" {
            let detailPage = segue.destination as? DetailPage
            let movieToSend = sender as! CoreMovie
            detailPage?.coreMovie = movieToSend
        }
    }
    
}
