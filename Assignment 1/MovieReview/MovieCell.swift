//
//  MovieCell.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/9/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit

// This class handle cells in table
class MovieCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var imgThumb: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Show information to the cell
    func setMovie(movie: NSDictionary) {
        let url = movie.valueForKeyPath("posters.thumbnail") as! String
        let imageURL = NSURL(string: url)
        let request = NSURLRequest(URL: imageURL!)
        
        self.lblTitle.text = movie["title"] as? String
        self.lblDescription.text = movie["synopsis"] as? String
        self.imgThumb.setImageWithURLRequest(request,
            placeholderImage: self.imgThumb.image,
            success: { (request, response, image) -> Void in
                self.imgThumb.image = image
            
                // If response == nil means that the image came out of that internal cache without making an HTTP request
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
