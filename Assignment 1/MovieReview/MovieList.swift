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


class MovieList: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblNetworkStatus: UILabel!
    
    // For network change events
    var reach: Reachability?
    
    // For "Pull to request"
    var refreshControl: UIRefreshControl!
    
    // Movie API
    var movieApi = MovieApi()
    
    // Controller for tableView
    var movieTable = MovieTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Assign controller for tableView
        tableView.dataSource = movieTable
        tableView.delegate = movieTable
        
        // Fetch movies to table
        JTProgressHUD.show()
        loadMovies({() -> Void in
            JTProgressHUD.hide()
        })
        
        // Refresh control
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        // Subcribe for network event for load movies
        // In case app startd with no network connection
        subcribeNetworkEvent({() -> Void in
            self.loadMovies({() -> Void in
                JTProgressHUD.hide()
                self.refreshControl.endRefreshing()
            })
        })
        
        // Network change when user is using app
        subcribeNetworkEvent({ () -> Void in
            // Hide label
            UIView.animateWithDuration(1, delay: 0,
                options: UIViewAnimationOptions.CurveEaseIn,
                animations: { () -> Void in
                    self.lblNetworkStatus.alpha = 0
                }, completion: { (result) -> Void in
                    self.lblNetworkStatus.hidden = true
                })
            }) { () -> Void in
                // Show label
                self.lblNetworkStatus.hidden = false
                UIView.animateWithDuration(1, delay: 0,
                    options: UIViewAnimationOptions.CurveEaseIn,
                    animations: { () -> Void in
                        self.lblNetworkStatus.alpha = 0.85
                    }, completion: { (result) -> Void in
                })
        }
        
        // Uncomment this line to disable cache
        // NSURLCache.sharedURLCache().removeAllCachedResponses()
        
    }
    
    // Overload for loadMovie(callback)
    func loadMovies() {
        loadMovies { () -> Void in
            // Do nothing
        }
    }
    
    // Load movies and refresh data table
    func loadMovies(callback: () -> Void) {
        self.movieApi.fetchMovies { (movies) -> Void in
            self.movieTable.movies = movies
            self.tableView.reloadData()
            callback()
        }
    }
    
    // Just an overload for subcribeNetworkEvent(onReachable, onUnreachable)
    func subcribeNetworkEvent(onReachable: () -> Void) {
        subcribeNetworkEvent(onReachable, onUnreachable: {() -> Void in
            // Do nothing
        })
    }
    
    // Do something when network status changes
    // Notice: callbacks onReachable, onUnreachable will be called in main thread
    func subcribeNetworkEvent(onReachable: () -> Void, onUnreachable: () -> Void) {
        // Allocate a reachability object
        self.reach = Reachability.reachabilityForInternetConnection()
        
        // Set the blocks
        
        self.reach!.reachableBlock = {
            (let reach: Reachability!) -> Void in
            // Callback will be called in main thread
            dispatch_async(dispatch_get_main_queue()) {
                onReachable()
            }
        }
        
        self.reach!.unreachableBlock = {
            (let reach: Reachability!) -> Void in
            // Callback will be called in main thread
            dispatch_async(dispatch_get_main_queue()) {
                onUnreachable()
            }
        }
        
        self.reach!.startNotifier()
    }
    
    // Handle pull to request
    func onRefresh() {
        self.loadMovies({() -> Void in
            self.refreshControl.endRefreshing()
        })
    }
        
    // Send movie JSON object to MovieDetail view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! MovieCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = self.movieTable.movies[indexPath!.row]
        let movieDetailViewController = segue.destinationViewController as!MovieDetail
        movieDetailViewController.movie = movie
    }

}

