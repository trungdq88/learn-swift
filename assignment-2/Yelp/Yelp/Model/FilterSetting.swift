//
//  FilterSetting.swift
//  Yelp
//
//  Created by Dinh Quang Trung on 11/21/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import Foundation

// This model describe the search setting
class FilterSetting {
    // Sort mode: 0=Best matched (default), 1=Distance, 2=Highest Rated.
    var sort: YelpSortMode?
    // Category to filter search results with. See the list of supported 
    // categories https://www.yelp.com/developers/documentation/v2/all_category_list
    var categories: [String]?
    // Whether to exclusively search for businesses with deals
    var deals: Bool?
    // Search radius in meters. If the value is too large, a AREA_TOO_LARGE
    // error may be returned. The max value is 40000 meters (25 miles).
    var distance: YelpDistanceMode?
}
