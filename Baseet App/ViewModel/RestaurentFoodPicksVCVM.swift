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
    var apiServices: HomeApiServicesProtocol?
    var foodOrderItems: FoodOrderItems?
    var reloadTableViewClosure:(()->())?
    var navigationClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    
    init(foodOrderItems: FoodOrderItems, apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.foodOrderItems = foodOrderItems
        self.apiServices = apiServices
    }
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func updateValues(itemCount: Int, index: Int) {
        var item = self.foodOrderItems?.foodItems?[index]
        item?.itemQuantity = itemCount
        self.foodOrderItems?.foodItems?.remove(at: index)
        self.foodOrderItems?.foodItems?.insert(item ?? FoodItems(), at: index)
        self.reloadTableViewClosure?()
    }
    
    func getRestFoodPickTableViewCellVM(index: Int) ->RestFoodPickTableViewCellVM {
        return RestFoodPickTableViewCellVM(foodItems: self.foodOrderItems?.foodItems?[index] ?? FoodItems())
    }
}
