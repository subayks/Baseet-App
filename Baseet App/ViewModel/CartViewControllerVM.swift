//
//  CartViewControllerVM.swift
//  Baseet App
//
//  Created by Subendran on 17/08/22.
//

import Foundation

class CartViewControllerVM {
    
    
    func getCartFoodData() ->[FoodItems] {
        if let data = UserDefaults.standard.data(forKey: "CartFoodData") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                // Decode Note
                let cartInfo = try decoder.decode([FoodItems].self, from: data)
                return cartInfo
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        return [FoodItems]()
    }
    
    func getCartTableViewCellVM(index: Int) ->CartTableViewCellVM {
        let foorArray = self.getCartFoodData()
        return CartTableViewCellVM(foodItems: foorArray[index])
    }
    
    
}
