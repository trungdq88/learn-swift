//
//  SettingViewController.swift
//  Yelp
//
//  Created by Dinh Quang Trung on 11/21/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, CategoryTableDelegate, UISearchBarDelegate {
    
    let TOP_SECTION_HEIGHT = 200
    
    // Delegate for outside usage
    var settingViewDelegate: SettingViewDelegate!
    
    @IBOutlet var viwTopSection: UIView!
    @IBOutlet var swhDeal: UISwitch!
    @IBOutlet var sgmDistance: UISegmentedControl!
    @IBOutlet var sgmSort: UISegmentedControl!
    @IBOutlet var tblCategories: UITableView!
    @IBOutlet var lblSelectedCount: UILabel!
    @IBOutlet var srhCategory: UISearchBar!
    
    @IBOutlet var cntTopSection: NSLayoutConstraint!
    // Setting
    var filter : FilterSetting!
    
    // Handler for category tables
    var handler = CategoryTableHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load category table
        tblCategories.delegate = handler
        tblCategories.dataSource = handler
        tblCategories.reloadData()
        
        // Delegate to track selected count
        handler.categoryTableDelegate = self
        
        // Handler for category search
        srhCategory.delegate = self
        
        // Load previous filter setting
        loadFilter()
    }
    
    // When user click "Search" button in setting page, go back to search page.
    @IBAction func tapSearch(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
        
        setFilter()
        
        // Call delegate to outside
        if settingViewDelegate != nil {
            settingViewDelegate.onFilterSettingChange(filter)
        }
        
    }
    
    // Show number of selected categories
    func refreshSelectedCount(count: Int) {
        lblSelectedCount.text = "Selected \(count) categor\(count == 1 ? "y" : "ies")"
    }
    
    // Load filter from previous setting
    func loadFilter() {
        if filter == nil {
            return
        }
        
        // Set Deal value
        swhDeal.on = filter.deals!
        
        // Set distance value
        if filter.distance == .Auto {
            sgmDistance.selectedSegmentIndex = 0
        } else if filter.distance == .OneMile {
            sgmDistance.selectedSegmentIndex = 1
        } else if filter.distance == .TwoMiles {
            sgmDistance.selectedSegmentIndex = 2
        } else if filter.distance == .FiveMiles {
            sgmDistance.selectedSegmentIndex = 3
        }
        
        
        // Set sort value
        sgmSort.selectedSegmentIndex = (filter.sort?.rawValue)!
        
        // Set selected category alias
        handler.setSelectedCategoryAliases(filter.categories)
        
        // Show selected count
        let count = handler.getSelectedCategoryAliases().count;
        refreshSelectedCount(count)
    }
    
    // Set filter from user input
    func setFilter() {
        // Initate filter setting if not initiated yet
        if filter == nil {
            filter = FilterSetting()
        }
        
        // Set Deal value
        filter.deals = swhDeal.on

        // Set distance value
        if sgmDistance.selectedSegmentIndex == 0 {
            filter.distance = .Auto
        } else if sgmDistance.selectedSegmentIndex == 1 {
            filter.distance = .OneMile
        } else if sgmDistance.selectedSegmentIndex == 2 {
            filter.distance = .TwoMiles
        } else if sgmDistance.selectedSegmentIndex == 3 {
            filter.distance = .FiveMiles
        }
        
        // Set sort value
        if (sgmSort.selectedSegmentIndex == 0) {
            filter.sort = .BestMatched
        } else if (sgmSort.selectedSegmentIndex == 1) {
            filter.sort = .Distance
        } else if (sgmSort.selectedSegmentIndex == 2) {
            filter.sort = .HighestRated
        }
        
        // Set selected category alias
        filter.categories = handler.getSelectedCategoryAliases()
        
    }
    
    // Track number of selected categories
    func onSelectedCountChanged(count: Int) {
        refreshSelectedCount(count)
    }
    
    // Search text change
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // Filter by category name
        handler.filter = searchText
        tblCategories.reloadData()
        
        // Why the [X] button does not trigger searchBarCancelButtonClicked?
        // Workaround: http://stackoverflow.com/a/33458250/1420186
        // The user clicked the [X] button or otherwise cleared the text.
        if (searchText.characters.count == 0) {
            searchBar.performSelector("resignFirstResponder", withObject: nil, afterDelay: 0.1)
        }
    }
    
    // Search button click
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        srhCategory.endEditing(true)
    }
    
    // Search cancel button click
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        srhCategory.endEditing(true)
    }
    
    // Resize table view when start searching (full screen)
    // Aww... I'm suck at animating
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        cntTopSection.constant = 0
        viwTopSection.frame = CGRectMake(0 , 0, viwTopSection.frame.width, 0)
    }
    
    // Resize table view when stop searching
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        cntTopSection.constant = CGFloat(TOP_SECTION_HEIGHT)
        viwTopSection.frame = CGRectMake(0 , 0, viwTopSection.frame.width, CGFloat(TOP_SECTION_HEIGHT))
    }
}

// Protocal for filter setting change event
protocol SettingViewDelegate {
    func onFilterSettingChange(filter: FilterSetting)
}