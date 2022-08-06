//
//  RecipeDetailsVCVM.swift
//  Baseet App
//
//  Created by Subendran on 06/08/22.
//

import Foundation

class RecipeDetailsVCVM {
    var proDuctDetailsModel: ProDuctDetailsModel?
    
    init(proDuctDetailsModel: ProDuctDetailsModel) {
        self.proDuctDetailsModel = proDuctDetailsModel
    }
    
    func getAddOnViewControllerVM() ->AddOnViewControllerVM {
        return AddOnViewControllerVM(addOns: self.proDuctDetailsModel?.addOns ?? [AddOns()])
    }
}
