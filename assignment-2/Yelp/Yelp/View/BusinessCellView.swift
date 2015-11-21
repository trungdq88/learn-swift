//
//  RestaurantCellView.swift
//  Yelp
//
//  Created by Dinh Quang Trung on 11/21/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessCellView: UITableViewCell {
    
    @IBOutlet var imgThumb: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblReviews: UILabel!
    @IBOutlet var imgRating: UIImageView!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblCategories: UILabel!
    @IBOutlet var lblDistance: UILabel!
    
    // Show information to cell
    func show(business: Business) {
        // imgThumb
        // imgRating
        if (business.imageURL != nil) {
            loadAndFade(imgThumb, imageURL: business.imageURL!)
        }
        if (business.ratingImageURL != nil) {
            loadAndFade(imgRating, imageURL: business.ratingImageURL!)
        }
        lblName.text = business.name!
        lblReviews.text = String(business.reviewCount!) +
            " review" + (business.reviewCount == 1 ? "" : "s")
        lblAddress.text = business.address!
        lblCategories.text = business.categories!
        lblDistance.text = business.distance!
    }
    
    // This method send request to get image and fade it in
    func loadAndFade(imageView: UIImageView, imageURL: NSURL) {
        // Create request
        let request = NSURLRequest(URL: imageURL)
        
        // Send request using AFNetworking
        imageView.setImageWithURLRequest(request,
            placeholderImage: imageView.image,
            success: { (request, response, image) -> Void in
                imageView.image = image
                
                // If response == nil means that the image came out of that internal cache without making an HTTP request
                // Do animation if image come from request (not cached)
                if (response != nil) {
                    imageView.alpha = 0;
                    UIView.animateWithDuration(1) { () -> Void in
                        imageView.alpha = 1
                    }
                }
            }) { (request, response, error) -> Void in
                // Cannot load thumbnail image
                print("Cannot load thumbnail image: ", error)
        }
        
    }
}
