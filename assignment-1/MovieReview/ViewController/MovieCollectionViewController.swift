//
//  MovieGrid.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/14/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit

class MovieCollectionViewController: MovieListViewController {

    
    @IBOutlet var collectionView: UICollectionView!
    
    // Controller for tableView
    // var movieTable = MovieTable()
    var handler = MovieCollectionHandler()
    
    // This view controller uses UITableView to display data
    override func getScrollView() -> UIScrollView {
        return collectionView
    }
    
    // Fill data to UITableView
    override func fillData(movies: [NSDictionary]) {
        self.handler.movies = movies
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign handler for tableView
        collectionView.dataSource = handler
        collectionView.delegate = handler
        
    }
    
    // Send movie JSON object to MovieDetail view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! MovieCollectionCell
        let indexPath = collectionView.indexPathForCell(cell)
        let movie = self.handler.movies[indexPath!.row]
        let movieDetailViewController = segue.destinationViewController as!MovieDetailViewController
        movieDetailViewController.movie = movie
    }

}
