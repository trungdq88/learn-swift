//
//  MovieCollectionHandler.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/14/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit

class MovieCollectionHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

    var movies = [NSDictionary]()
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("movieCollectionCell", forIndexPath: indexPath) as! MovieCollectionCell
        if (indexPath.row > movies.count - 1) {
            return cell;
        }
        let movie = movies[indexPath.row]
        cell.setMovie(movie)
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
}
