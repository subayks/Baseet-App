//
//  CartViewControllerVM.swift
//  Baseet App
//
//  Created by Subendran on 17/08/22.
//

import Foundation

class CartViewControllerVM {
    
    var apiServices: HomeApiServicesProtocol?
    var navigationClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var reloadRecipieCollectionView:(()->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var getCartModel: GetCartModel? {
        didSet {
            self.reloadRecipieCollectionView?()
        }
    }
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func getCartCall() {
        if Reachability.isConnectedToNetwork() {

            self.showLoadingIndicatorClosure?()
            self.apiServices?.getCartApi(finalURL: "\(Constants.Common.finalURL)/products/get_cart?user_id=\(2)", completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.getCartModel = result as? GetCartModel
                } else {
                   self.alertClosure?("Some technical problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func getCartTableViewCellVM(index: Int) ->CartTableViewCellVM {
        let foodArray = self.getCartModel?.data
        return CartTableViewCellVM(foodItems: foodArray?[index] ?? CartDataModel())
    }
}
