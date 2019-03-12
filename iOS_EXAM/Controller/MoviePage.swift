//
//  ViewController.swift
//  iOS_EXAM
//
//  Created by 700023 on 20/11/2018.
//  This is a class for show all Star Wars movies
//

import UIKit

class MoviePage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    static var allMovies: [Movie]!
    private var starwarsMovies: StarWarsMovies!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Star wars movies"
        self.navigationController?.tabBarItem.title = "Movies"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        starwarsMovies = StarWarsMovies()
        MoviePage.allMovies = []
        getAllMovies()
    }

    private func getAllMovies() {
        starwarsMovies.getAllMovies { (allMovies) in
            MoviePage.allMovies = allMovies
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MoviePage.allMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let recyclerCell = tableView.dequeueReusableCell(withIdentifier: "movieCell") {
            recyclerCell.textLabel?.text = MoviePage.allMovies[indexPath.row].movieTitle
            recyclerCell.accessoryType = .disclosureIndicator
            return recyclerCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let objectToDetail = MoviePage.allMovies[indexPath.row]
        self.performSegue(withIdentifier: "toDetailPage", sender: objectToDetail)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailPage" {
            if let detailPage = segue.destination as? DetailPage {
                if let theObjectToSend = sender as? Movie {
                    detailPage.incomingMovie = theObjectToSend
                }
            }
        }
    }

}

