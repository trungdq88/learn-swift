//
//  MovieDynamicViewController.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/14/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit

// This is a combination of MovieTableViewController and MovieCollectionViewController
// it has a switch button to switch between these two view mode (list or grid)
class MovieDynamicViewController: MovieListViewController {
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    // Current view controller, it could be UITableView or UICollectionView
    var activeViewController = UIScrollView();
    
    // Controller for tableView
    var handler = MovieListHandler()
    
    // API
    var theaterApi = TheaterApi()
    
    // This screen displays theater movie
    override func getApi() -> MovieApi {
        return theaterApi
    }
    
    // This view controller uses UITableView to display data
    override func getScrollView() -> UIScrollView {
        return activeViewController
    }
    
    // Fill data to UITableView
    override func fillData(movies: [NSDictionary]) {
        self.handler.movies = movies
        
        // (It makes me supprise that UITableView and UICollectionView has no accient relationship!)
        if (self.activeViewController is UITableView) {
            tableView.reloadData()
        } else if (self.activeViewController is UICollectionView) {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign handler
        tableView.dataSource = handler
        tableView.delegate = handler
        collectionView.dataSource = handler
        collectionView.delegate = handler
        
    }
    
    // Send movie JSON object to MovieDetail view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        let cell = sender as! MovieTableCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = self.handler.movies[indexPath!.row]
        let movieDetailViewController = segue.destinationViewController as!MovieDetailViewController
        movieDetailViewController.movie = movie
        */
    }
    

}
