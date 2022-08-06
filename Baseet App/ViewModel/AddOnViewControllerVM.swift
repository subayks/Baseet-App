//
//  AddOnViewControllerVM.swift
//  Baseet App
//
//  Created by Subendran on 07/08/22.
//

import Foundation

class AddOnViewControllerVM {
    var addOns: [AddOns]?
    
    init(addOns: [AddOns]) {
        self.addOns = addOns
    }
    
    func getAddOnTableViewCellVM(index: Int) ->AddOnTableViewCellVM {
        return AddOnTableViewCellVM(addOn: self.addOns?[index] ?? AddOns())
    }
}
