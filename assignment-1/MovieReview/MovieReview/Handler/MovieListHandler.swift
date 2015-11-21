//
//  MovieListHandler.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/14/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit

class MovieListHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource,
                                UITableViewDelegate, UITableViewDataSource {
    // Store all data for the list view
    var movies = [NSDictionary]()
    
    /////////////////////////////////
    /// Handler for UICollectionView
    /////////////////////////////////
    
    // Returning cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("movieCollectionCell", forIndexPath: indexPath) as! MovieCollectionCell
        if (indexPath.row > movies.count - 1) {
            return cell;
        }
        let movie = movies[indexPath.row]
        cell.setMovie(movie)
        return cell;
    }
    
    // Returning count
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    /////////////////////////////////
    /// Handler for UITableView
    /////////////////////////////////
    
    // Return cell for each row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieTableCell") as! MovieTableCell
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
