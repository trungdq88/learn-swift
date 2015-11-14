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


class MovieList: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblNetworkStatus: UILabel!
    
    let API_ENDPOINT = "https://coderschool-movies.herokuapp.com/movies?api_key=xja087zcvxljadsflh214";
    
    var reach: Reachability?
    var refreshControl: UIRefreshControl!
    var movies = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load table
        tableView.dataSource = self
        tableView.delegate = self
        
        // Fetch movies to tables
        JTProgressHUD.show()
        fetchMovies({() -> Void in
            JTProgressHUD.hide()
        })
        
        // Refresh control
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        // Uncomment this line to disable cache
        // NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        // Subcribe for network event for load movies
        // In case app startd with no network connection
        subcribeNetworkEvent({() -> Void in
            self.fetchMovies({() -> Void in
                JTProgressHUD.hide()
                self.refreshControl.endRefreshing()
            })
        })
        
        // Network change when user is using app
        subcribeNetworkEvent({ () -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                // Hide label
                UIView.animateWithDuration(1, delay: 0,
                    options: UIViewAnimationOptions.CurveEaseIn,
                    animations: { () -> Void in
                        self.lblNetworkStatus.alpha = 0
                    }, completion: { (result) -> Void in
                        self.lblNetworkStatus.hidden = true
                })
            }
            }) { () -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    // Show label
                    self.lblNetworkStatus.hidden = false
                    UIView.animateWithDuration(1, delay: 0,
                        options: UIViewAnimationOptions.CurveEaseIn,
                        animations: { () -> Void in
                            self.lblNetworkStatus.alpha = 1
                        }, completion: { (result) -> Void in
                    })
                }
        }
    }
    
    // Just an overload for subcribeNetworkEvent(onReachable: () -> Void, onUnreachable: () -> Void) {
    func subcribeNetworkEvent(onReachable: () -> Void) {
        subcribeNetworkEvent(onReachable, onUnreachable: {() -> Void in
            // Do nothing
        })
    }
    
    // Do something when network status changes
    func subcribeNetworkEvent(onReachable: () -> Void, onUnreachable: () -> Void) {
        // Allocate a reachability object
        self.reach = Reachability.reachabilityForInternetConnection()
        
        // Set the blocks
        self.reach!.reachableBlock = {
            (let reach: Reachability!) -> Void in
            
            // keep in mind this is called on a background thread
            // and if you are updating the UI it needs to happen
            // on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                onReachable()
            }
        }
        
        self.reach!.unreachableBlock = {
            (let reach: Reachability!) -> Void in
            onUnreachable()
        }
        
        self.reach!.startNotifier()
    }
    
    func onRefresh() {
        fetchMovies({() -> Void in
            self.refreshControl.endRefreshing()
        })
    }
    
    func fetchMovies(callback : () -> Void) {
        movies = []
        
        let url = NSURL(string: API_ENDPOINT)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            guard error == nil else {
                print("ERROR fetching movies", error)
                return
            }
            
            // Parse json data
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            
            self.movies = json["movies"] as! [NSDictionary]
            

            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                self.tableView.reloadData()
                callback()
            })
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell") as! MovieCell
        if (indexPath.row > movies.count - 1) {
          return cell;
        }
        let movie = movies[indexPath.row]
        let url = movie.valueForKeyPath("posters.thumbnail") as! String
        let imageURL = NSURL(string: url)
        let request = NSURLRequest(URL: imageURL!)
        
        cell.lblTitle.text = movie["title"] as? String
        cell.lblDescription.text = movie["synopsis"] as? String
        cell.imgThumb.setImageWithURLRequest(request, placeholderImage: cell.imgThumb.image, success: { (request, response, image) -> Void in
            cell.imgThumb.image = image
            
            // If response == nil means that the image came out of that internal cache without making an HTTP request
            if (response != nil) {
                cell.imgThumb.alpha = 0;
                UIView.animateWithDuration(1) { () -> Void in
                    cell.imgThumb.alpha = 1
                }
            }
            
            }) { (request, response, error) -> Void in
                
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return movies.count;
    }
    
    // Send movie JSON object to MovieDetailController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! MovieCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies[indexPath!.row]
        let movieDetailViewController = segue.destinationViewController as!MovieDetail
        movieDetailViewController.movie = movie
    }

}

