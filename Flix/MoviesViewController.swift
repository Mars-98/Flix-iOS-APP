//
//  MoviesViewController.swift
//  Flix
//
//  Created by Mariam Adams on 9/22/20.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var movies = [[String:Any]]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies = dataDictionary["results"] as! [[String:Any]]
                self.tableView.reloadData()
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
                
            }
        }
        task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let summary = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.summaryLabel.text = summary
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        
     //check if the movie contains an image
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = URL(string: baseUrl + posterPath)!
            cell.posterView.af.setImage(withURL: posterUrl)
        }
        else {
           // No poster image. Can either set to nil (no image) or a default movie poster image
           // that you include as an asset
           cell.posterView.image = nil
        }
        
        return cell
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        
        //sender is the cell itself
        //find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        //pass the selected movie to the details view controller
        
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        //this is done so after navigating back to the tableview, the cell isn't highlighted dark grey
        //(in other words, not selected)
        tableView.deselectRow(at: indexPath, animated: true)
     }
     
    
}
