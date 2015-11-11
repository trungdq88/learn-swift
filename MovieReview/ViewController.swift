//
//  ViewController.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/9/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    let dataURL = "https://coderschool-movies.herokuapp.com/movies?api_key=xja087zcvxljadsflh214";
    
    var movies = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        fetchMovies()
        
    }
    
    func fetchMovies() {
        movies = []
        
        let url = NSURL(string: dataURL)
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
            })
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell") as! MovieCell
        cell.titleLabel.text = movie["title"] as? String
        
        let poster = movie["posters"] as! NSDictionary
        let url = poster["thumbnail"] as! String
        let imageURL = NSURL(string: url)
        cell.thumbnailImg.setImageWithURL(imageURL!)
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return movies.count;
    }
    

}

