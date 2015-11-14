//
//  DvdsApi.swift
//  MovieReview
//
//  Created by Dinh Quang Trung on 11/14/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit

// API for DVDs movies
class DvdsApi: MovieApi {
    
    // Return end point for dvds API
    override func getApiEndpoint() -> String {
        return Config.DVDS_API
    }
}
