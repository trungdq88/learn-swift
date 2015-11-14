//
//  MovieApi.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/14/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit

// This class responsible for loading data related to movies
class MovieApi: NSObject {
    
    // Mirror for tomato rotten API from coderschool
    let API_ENDPOINT = "https://coderschool-movies.herokuapp.com/movies?api_key=xja087zcvxljadsflh214";
    
    // Static variable for memory cache
    static var movies = [NSDictionary]()
    
    // Fetch movies
    func fetchMovies(callback : (movies: [NSDictionary]) -> Void) {
        
        let url = NSURL(string: API_ENDPOINT)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            guard error == nil else {
                print("ERROR fetching movies", error)
                return
            }
            
            // Parse json data
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                MovieApi.movies = json["movies"] as! [NSDictionary]
                callback(movies: MovieApi.movies)
            })
        }
        task.resume()
    }

    // Get movies with cache = disableCache
    // Is this (memory cache) useless?
    func getMovies(callback : (movies: [NSDictionary]) -> Void, disableCache: Bool) {
        if (disableCache || MovieApi.movies.count == 0) {
            fetchMovies(callback)
        } else {
            callback(movies: MovieApi.movies)
        }
    }
    
    // Get movies with cache = true
    func getMovies(callback : (movies: [NSDictionary]) -> Void) {
        getMovies(callback, disableCache: false)
    }
}
