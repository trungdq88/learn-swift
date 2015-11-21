//
//  Category.swift
//  Yelp
//
//  Created by Dinh Quang Trung on 11/21/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import Foundation

class Category : Equatable {
    var name: String!
    var alias: String!
    
    init() {
        self.name = nil
        self.alias = nil
    }
    
    init (name: String!, alias: String!) {
        self.name = name
        self.alias = alias
    }
    
}

// Override == operator to use filter/map methods in [Category]
func ==(lhs: Category, rhs: Category) -> Bool {
    return lhs.name == rhs.name && lhs.alias == rhs.alias
}
