//
//  MovieDetailViewController.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/11/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit
import AFNetworking
class MovieDetail: UIViewController {

    @IBOutlet var imgThumb: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlThumb = movie.valueForKeyPath("posters.thumbnail") as! String
        let urlFull = movie.valueForKeyPath("posters.detailed") as! String
        let thumbURL = NSURL(string: urlThumb)
        let fullURL = NSURL(string: urlFull)
        let request = NSURLRequest(URL: fullURL!)
        
        lblTitle.text = movie["title"] as? String
        lblDescription.text = movie["synopsis"] as? String
        imgThumb.setImageWithURL(thumbURL!) // Obviously cached from list view
        imgThumb.setImageWithURLRequest(request, placeholderImage: imgThumb.image, success: { (NSURLRequest, NSHTTPURLResponse, image) -> Void in
            self.imgThumb.image = image
            }) { (NSURLRequest, NSHTTPURLResponse, NSError) -> Void in
                
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
