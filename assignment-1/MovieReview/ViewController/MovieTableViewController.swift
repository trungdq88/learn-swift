//
//  ViewController.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/9/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit
import AFNetworking
import JTProgressHUD
import Reachability


class MovieTableViewController: MovieListViewController {

    @IBOutlet var tableView: UITableView!
    
    // Controller for tableView
    var handler = MovieTableHandler()
    
    // This view controller uses UITableView to display data
    override func getScrollView() -> UIScrollView {
        return tableView
    }
    
    // Fill data to UITableView
    override func fillData(movies: [NSDictionary]) {
        self.handler.movies = movies
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Assign handler for tableView
        tableView.dataSource = handler
        tableView.delegate = handler
        
    }
        
    // Send movie JSON object to MovieDetail view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! MovieTableCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = self.handler.movies[indexPath!.row]
        let movieDetailViewController = segue.destinationViewController as!MovieDetailViewController
        movieDetailViewController.movie = movie
    }

}

