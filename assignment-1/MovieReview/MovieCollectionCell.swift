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
    
    func setMovie(movie: NSDictionary) {
        
        self.lblTitle.text = movie["title"] as? String
    }
}
