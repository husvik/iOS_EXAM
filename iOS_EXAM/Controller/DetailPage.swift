//
//  DetailPage.swift
//  iOS_EXAM
//
//  Created by 700023 on 20/11/2018.
//  This is a class for show all details about a movie
//

import UIKit
import CoreData

class DetailPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var detailTableViewHeight: NSLayoutConstraint!
    
    var incomingMovie: Movie!
    var coreMovie: CoreMovie!
    
    private var detailArray: [String]!
    private var movieExistsInCoreData = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.delegate = self
        detailTableView.dataSource = self
        if incomingMovie != nil {
            self.title = incomingMovie.movieTitle
        } else {
            incomingMovie = self.configCoreToIncoming(coreMovie: coreMovie)
            self.title = incomingMovie.movieTitle
        }
        
        self.checkCoreMovie()
        if movieExistsInCoreData {
            btnFavorite.setTitle("Remove as favorite", for: .normal)
        } else {
            btnFavorite.setTitle("Add to favorites", for: .normal)
        }
        self.configureArray(title: incomingMovie.movieTitle, episode: "\(incomingMovie.movieEpisode)", director: incomingMovie.movieDirector, releaseDate: incomingMovie.movieReleaseDate)
    }
    
    func configCoreToIncoming(coreMovie: CoreMovie) -> Movie {
        let coreDictInfo = ["title": coreMovie.movieTitle!, "episode_id": Int(coreMovie.movieEpisode), "director": coreMovie.movieDirector!, "release_date": coreMovie.movieReleaseDate!, "characters": coreMovie.movieCharacterUrls!, "url": coreMovie.movieUrl!] as [String: Any]
        let convertMovie = Movie(response: coreDictInfo)
        return convertMovie!
    }
    
    private func configureArray(title: String, episode: String, director: String, releaseDate: String) {
        detailArray = []
        detailArray.append("Title: \(title)")
        detailArray.append("Episode: \(episode)")
        detailArray.append("Director: \(director)")
        detailArray.append("Release date: \(releaseDate)")
        self.detailTableViewHeight.constant = CGFloat(detailArray.count * 44)
    }
    
    private func checkCoreMovie() {
        let movieRequest = NSFetchRequest<CoreMovie>(entityName: "CoreMovie")
        let movieDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let thisContext = movieDelegate.persistentContainer.viewContext
        let movieResult = try! thisContext.fetch(movieRequest)
        for coreMovie in movieResult {
            if let movieTitle = coreMovie.movieTitle {
                if movieTitle == self.incomingMovie.movieTitle {
                    movieExistsInCoreData = true
                    return
                }
            }
        }
        movieExistsInCoreData = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "detailPageCell") {
            cell.textLabel?.text = detailArray[indexPath.row]
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func addToFavorite() {
        let movieDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let movieContext = movieDelegate.persistentContainer.viewContext
        CoreMovie.init(movie: self.incomingMovie, managedObjectContext: movieContext)
        movieDelegate.saveContext()
    }
    
    private func removeFromFavorite() {
        let movieDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let movieContext = movieDelegate.persistentContainer.viewContext
        let movieRemoveRequest = NSFetchRequest<CoreMovie>(entityName: "CoreMovie")
        let movieDataResult = try! movieContext.fetch(movieRemoveRequest)
        for movie in movieDataResult {
            if let movieTitle = movie.movieTitle {
                if movieTitle == self.incomingMovie.movieTitle {
                    movieContext.delete(movie)
                    movieDelegate.saveContext()
                    break
                }
            }
        }
    }
    
    @IBAction func configureFavoriteBtn(_ sender: UIButton!) {
        if sender.currentTitle == "Remove as favorite" {
            self.removeFromFavorite()
            sender.setTitle("Add to favorites", for: .normal)
        } else {
            self.addToFavorite()
            sender.setTitle("Remove as favorite", for: .normal)
        }
    }
    
}
