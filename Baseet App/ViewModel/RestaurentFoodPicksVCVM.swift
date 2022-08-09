//
//  RestaurentFoodPicksVCVM.swift
//  Baseet App
//
//  Created by Subendran on 09/08/22.
//

import Foundation

struct FoodOrderItems {
    var shopName: String?
    var icon: String?
    var foodItems: [FoodItems]?
    
}

class RestaurentFoodPicksVCVM {
    var foodOrderItems: FoodOrderItems?
    
    init(foodOrderItems: FoodOrderItems) {
        self.foodOrderItems = foodOrderItems
    }    
}
