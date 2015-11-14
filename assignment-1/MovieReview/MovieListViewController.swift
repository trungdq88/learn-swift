//
//  AbstractMovieListViewController.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/14/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit
import AFNetworking
import JTProgressHUD
import Reachability

/// This is an abstract class responsible for display list of movie
/// Move list can be displayed in many "mode" (ex: TableView, CollectionView, CustomView...)
/// You can extend this class to use some reusable code (like pull to refresh, network status events...)
class MovieListViewController: UIViewController {
    var lblNetworkStatus: UILabel!
    
    // For network change events
    var reach: Reachability?
    
    // For "Pull to request"
    var refreshControl: UIRefreshControl!
    
    // Movie API
    var movieApi = MovieApi()
    
    // The View Controller must have a UIScrollView (could be UITableView or
    // UICollectionView), this UIScrollView will be used for "Pull to refresh" feature
    func getScrollView() -> UIScrollView {
        preconditionFailure("This method must be overridden")
    }
    
    // This method will fill data to the view (could be UITableView or UICollection View)
    func fillData(movies: [NSDictionary]) {
        preconditionFailure("This method must be overridden")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch movies to table
        JTProgressHUD.show()
        loadMovies({() -> Void in
            JTProgressHUD.hide()
        })
        
        // Refresh control
        self.addNetworkStatusLabel()
        self.view.addSubview(lblNetworkStatus)
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        getScrollView().addSubview(refreshControl)
        
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
    
    func addNetworkStatusLabel() {
        // TODO: layout position in this project is so wrong...
        lblNetworkStatus = UILabel(frame: CGRectMake(0, 0, 320, 50))
        lblNetworkStatus.center = CGPointMake(160, 90)
        lblNetworkStatus.textAlignment = NSTextAlignment.Center
        lblNetworkStatus.backgroundColor = UIColor.blackColor()
        lblNetworkStatus.textColor = UIColor.whiteColor()
        lblNetworkStatus.font = UIFont(name: lblNetworkStatus.font.fontName, size: 14)
        lblNetworkStatus.numberOfLines = 0
        lblNetworkStatus.alpha = 0
        lblNetworkStatus.hidden = true
        lblNetworkStatus.text = "Hmm... You are currently offline. Please check your connection"
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
            self.fillData(movies)
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
    
}
