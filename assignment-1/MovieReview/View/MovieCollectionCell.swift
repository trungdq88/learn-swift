//
//  MovieCollectionCell.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/14/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblRelease: UILabel!
    @IBOutlet var imgThumb: UIImageView!
    
    // Display information to cell
    func setMovie(movie: NSDictionary) {
        
        let url = movie.valueForKeyPath("posters.thumbnail") as! String
        let imageURL = NSURL(string: url)
        let request = NSURLRequest(URL: imageURL!)
        
        self.lblTitle.text = (movie["title"] as! String) + " (" + String(movie["year"]!) + ")"
        self.lblRelease.text = movie.valueForKeyPath("release_dates.theater") as? String
        self.imgThumb.setImageWithURLRequest(request,
            placeholderImage: self.imgThumb.image,
            success: { (request, response, image) -> Void in
                self.imgThumb.image = image
                
                // If response == nil means that the image came out of that internal cache without making an HTTP request
                // Do animation if image come from request (not cached)
                if (response != nil) {
                    self.imgThumb.alpha = 0;
                    UIView.animateWithDuration(1) { () -> Void in
                        self.imgThumb.alpha = 1
                    }
                }
            }) { (request, response, error) -> Void in
                // Cannot load thumbnail image
                print("Cannot load thumbnail image: ", error)
        }
    }
}
