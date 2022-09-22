//
//  SearchRestaurentVM.swift
//  Baseet App
//
//  Created by Subendran on 21/09/22.
//

import Foundation

class SearchRestaurentVM {
    var apiServices: HomeApiServicesProtocol?
    var reloadClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var searchModel: SearchModel?
    var navigateToDetailsClosure:(()->())?
    var shopDetailsModel: ShopDetailsModel?
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func getSearchItem(query: String) {
        if Reachability.isConnectedToNetwork() {
            
            self.showLoadingIndicatorClosure?()
            // let id = self.addToCartModel?.data?[0].userId
            self.apiServices?.getSearchList(finalURL: "\(Constants.Common.finalURL)/restaurants/search?name=\(query)", completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                
                DispatchQueue.main.async {
                    self.hideLoadingIndicatorClosure?()
                    if status == true {
                        self.searchModel = result as? SearchModel
                        self.reloadClosure?()
                    } else {
                        self.alertClosure?("Some technical problem")
                    }
                }
            })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func makeShopDetailsCall(id: Int) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            self.apiServices?.getShopDetails(finalURL: "\(Constants.Common.finalURL)/products/product_by_restaurant?restaurant_id=\(id)&category_id=0&limit=10&offset=1",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.shopDetailsModel = result as? ShopDetailsModel
                    self.navigateToDetailsClosure?()
                } else {
                   self.alertClosure?("Some technical problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func getRestarentDishViewControllerVM() ->RestarentDishViewControllerVM {
        return RestarentDishViewControllerVM(shopDetailsModel: self.shopDetailsModel!)
    }
    
    func getMyFevTableViewCellVM(index: Int) ->HomeCollectionViewDownCellVM {
        return HomeCollectionViewDownCellVM(restaurantsModel: self.searchModel?.restaurants?[index] ?? RestaurantsModel())
    }
    
}
