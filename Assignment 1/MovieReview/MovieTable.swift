//
//  MovieTable.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/14/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit

// This class controls the Movie List table
class MovieTable: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var movies = [NSDictionary]()
    
    // Return cell for each row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell") as! MovieCell
        if (indexPath.row > movies.count - 1) {
            return cell;
        }
        let movie = movies[indexPath.row]
        cell.setMovie(movie)
        return cell;
    }
    
    // Item count
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return movies.count;
    }

    // Remove cell selected hightlight
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
