//
//  CategoryCellView.swift
//  Yelp
//
//  Created by Dinh Quang Trung on 11/21/15.
//  Copyright © 2015 HAC. All rights reserved.
//

import UIKit

class CategoryCellView: UITableViewCell {
    var categoryActivateDelegate: CategoryActivateDelegate!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var swhActivated: UISwitch!
    
    var category : Category!
    
    func show(category: Category, selected: Bool) {
        self.category = category
        lblName.text = category.name
        swhActivated.on = selected
    }
    
    // Delegate the switch value to outside
    @IBAction func onActivateChanged(sender: UISwitch) {
        if categoryActivateDelegate != nil {
            categoryActivateDelegate.onCategoryActivateChanged(category, value: sender.on)
        }
    }

}

protocol CategoryActivateDelegate {
    func onCategoryActivateChanged(category: Category!, value: Bool)
}