//
//  RecipeDetailsVCVM.swift
//  Baseet App
//
//  Created by Subendran on 06/08/22.
//

import Foundation

class RecipeDetailsVCVM {
    var proDuctDetailsModel: FoodItems?
    var index: Int?
    
    init(proDuctDetailsModel: FoodItems, index: Int) {
        self.proDuctDetailsModel = proDuctDetailsModel
        self.index = index
    }
    
    func getAddOnViewControllerVM() ->AddOnViewControllerVM {
        return AddOnViewControllerVM(addOns: self.proDuctDetailsModel?.addOns ?? [AddOns()])
    }
    
    func updateAdons(addOns: [AddOns]) {
        self.proDuctDetailsModel?.addOns = addOns
    }
    
    
}
