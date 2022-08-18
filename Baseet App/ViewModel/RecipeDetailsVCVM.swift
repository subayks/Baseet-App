//
//  RecipeDetailsVCVM.swift
//  Baseet App
//
//  Created by Subendran on 06/08/22.
//

import Foundation
import UIKit

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
    
    func setupAdons() ->[AddOns]{
        let adOns = self.proDuctDetailsModel?.addOns?.filter{$0.itemQuantity ?? 0 > 0}
        return adOns ?? [AddOns()]
    }
}
