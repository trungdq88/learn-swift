//
//  MovieApi.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/14/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit

// This abstract class responsible for loading data related to movies
class MovieApi: NSObject {
   
    
    // Static variable for memory cache
    // Schema:
    //   Map(                                   => Map for memory cache
    //    key(String) -> value(Array(Map))         - key: API endpoint string
    //   )                                         - value: array of movie dictionary
    //
    // Is this (memory cache) useless?
    static var cache = NSMutableDictionary()
    
    // Child class must override this method to specify API end point
    func getApiEndpoint() -> String {
        preconditionFailure("This method must be overridden")
    }
    
    // Fetch movies
    func fetchMovies(callback : (movies: [NSDictionary]) -> Void) {
        
        let url = NSURL(string: getApiEndpoint())
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            guard error == nil else {
                print("ERROR fetching movies", error)
                return
            }
            
            // Parse json data
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                // Get movies array
                let movies = json["movies"] as! [NSDictionary];
                
                // Save to memory cache
                MovieApi.cache.setValue(movies, forKey: self.getApiEndpoint())
                callback(movies: movies)
            })
        }
        task.resume()
    }

    // Get movies with cache = disableCache
    func getMovies(callback : (movies: [NSDictionary]) -> Void, disableCache: Bool) {
        // Check if available in cache
        let cachedMovies = getCachedMovies()
        
        // Return cache or send new request
        if (disableCache || cachedMovies.count == 0) {
            fetchMovies(callback)
        } else {
            callback(movies: cachedMovies)
        }
    }
    
    // Get movies with cache = true
    func getMovies(callback : (movies: [NSDictionary]) -> Void) {
        getMovies(callback, disableCache: false)
    }
    
    // Get cached movies from current API Endpoint
    func getCachedMovies() -> [NSDictionary] {
        let cachedMoviesObject = MovieApi.cache[self.getApiEndpoint()];
        var cachedMovies = [NSDictionary]()
        if (cachedMoviesObject != nil) {
            cachedMovies = cachedMoviesObject as! [NSDictionary]
        }
        return cachedMovies
    }
}
