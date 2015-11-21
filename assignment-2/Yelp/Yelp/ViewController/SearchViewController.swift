//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import JTProgressHUD

class SearchViewController: UIViewController, UISearchBarDelegate, SettingViewDelegate {
    
    // The table
    @IBOutlet var tblBusiness: UITableView!
    
    // Search bar
    @IBOutlet var searchBar: UISearchBar!
    
    // Handler for table
    let handler = BusinessTableHandler()
    
    // Filter setting
    var filter : FilterSetting!
    
    // Search term
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set search view in navigation bar
        self.navigationItem.titleView = searchBar
        // Hide the search view in first table row to avoid the weird space (iOS, seriously?)
        // http://stackoverflow.com/questions/19914935/empty-uisearchbar-space-when-combining-search-bar-with-nav-bar-in-ios7/20442186#20442186
        // Whoever review my code, please tell me how to do this correctly
        searchBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        // Handler for search bar
        searchBar.delegate = self
        
        // Set handler for table view
        tblBusiness.delegate = handler
        tblBusiness.dataSource = handler
        
        // Show all businesses at the first time by search for empty string
        doSearch()
    }
    
    // Search for businesses via API
    func doSearch() {
        JTProgressHUD.show()
        Business.searchWithTerm(searchText, filter: filter) { (businesses: [Business]!, error: NSError!) -> Void in
            self.handler.businesses = businesses
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                self.tblBusiness.reloadData()
                JTProgressHUD.hide()
            })
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        doSearch()
        searchBar.endEditing(true)
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    // Receive filter setting from SettingViewController
    func onFilterSettingChange(filter: FilterSetting) {
        self.filter = filter
        doSearch()
    }
    
    // Assign delegate listener when open the SettingViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let settingViewController = segue.destinationViewController as! SettingViewController
        settingViewController.filter = filter
        settingViewController.settingViewDelegate = self
    }
}
