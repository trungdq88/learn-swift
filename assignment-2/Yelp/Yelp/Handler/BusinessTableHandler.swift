//
//  BusinessTableHandler.swift
//  Yelp
//
//  Created by Dinh Quang Trung on 11/21/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessTableHandler: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    // Hold all data for the table
    var businesses = [Business]()
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("businessCell") as! BusinessCellView
        let business = businesses[indexPath.row]
        cell.show(business)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    // Remove highlight when select row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
