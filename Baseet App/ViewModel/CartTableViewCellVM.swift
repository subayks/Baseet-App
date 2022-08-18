//
//  CartTableViewCellVM.swift
//  Baseet App
//
//  Created by Subendran on 17/08/22.
//

import Foundation

class CartTableViewCellVM {
    var foodItems: FoodItems?
    
    init(foodItems: FoodItems) {
        self.foodItems = foodItems
    }
}
