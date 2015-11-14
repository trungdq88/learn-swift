//
//  MovieDetailViewController.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/11/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit
import AFNetworking
class MovieDetailViewController: UIViewController {

    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblYear: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblRelease: UILabel!
    @IBOutlet var lblAscore: UILabel!
    @IBOutlet var lblCScore: UILabel!
    @IBOutlet var txtDescription: UITextView!
    
    // Data passed from MovieList
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation title
        self.navigationItem.title = movie["title"] as? String;
        
        // Show info
        let urlThumb = movie.valueForKeyPath("posters.thumbnail") as! String
        let urlFull = movie.valueForKeyPath("posters.detailed") as! String
        let thumbURL = NSURL(string: urlThumb)
        let fullURL = NSURL(string: urlFull)
        let request = NSURLRequest(URL: fullURL!)
        
        lblTitle.text = (movie["title"] as! String) + " (" + String(movie["year"]!) + ")"
        txtDescription.text = movie["synopsis"] as? String
        lblRating.text = movie["mpaa_rating"] as? String
        lblRelease.text = movie.valueForKeyPath("release_dates.theater") as? String
        lblAscore.text = String(movie.valueForKeyPath("ratings.audience_score")!)
        lblCScore.text = String(movie.valueForKeyPath("ratings.critics_score")!)
        
        // Show thumbnail first
        imgBackground.setImageWithURL(thumbURL!) // Obviously cached from list view
        
        // Then load full image later
        imgBackground.setImageWithURLRequest(request,
            placeholderImage: imgBackground.image,
            success: { (imgBackground, NSHTTPURLResponse, image) -> Void in
                self.imgBackground.image = image
            }) { (NSURLRequest, NSHTTPURLResponse, NSError) -> Void in
            // Do nothing, keep the thumbnail as background
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
