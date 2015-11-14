//
//  TheaterApi.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/14/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit

// API for THEATER movies
class TheaterApi: MovieApi {
    
    // Return end point for theater API
    override func getApiEndpoint() -> String {
        return Config.THEATER_API
    }
}
