//
//  HomeViewControllerVM.swift
//  Baseet App
//
//  Created by Subendran on 01/08/22.
//

import Foundation
class HomeViewControllerVM {
    var apiServices: HomeApiServicesProtocol?
    var navigationClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var shopListModel: ShopListModel?
    var reloadCollectionViewDown:(()->())?
    var categoryList: [CategoryListModel]?
    var reloadCollectionViewTop:(()->())?
    var shopDetailsModel: ShopDetailsModel?
    var navigateToDetailsClosure:(()->())?

    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func makeShopNearyByCall() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let lat = 17.380281
            let long =  78.4732695
           let httpHeaders =  [
           "Content-Type": "application/json",
             "latitude": "\(lat)",
             "longitude": "\(long)",
             "radius": "50"
           ]
            self.apiServices?.getShopNearBy(finalURL: "\(Constants.Common.finalURL)/restaurants/get-nearby", httpHeaders: httpHeaders, completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.shopListModel = result as? ShopListModel
                    self.reloadCollectionViewDown?()
                } else {
                   self.alertClosure?("Some technical problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func makeCategoryListCall() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            self.apiServices?.getCategoryList(finalURL: "\(Constants.Common.finalURL)/categories",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.categoryList = result as? [CategoryListModel]
                    self.reloadCollectionViewTop?()
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
            self.apiServices?.getShopDetails(finalURL: "\(Constants.Common.finalURL)/restaurants/details/\(id)",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
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
    
    func getHomeCollectionViewDownCellVM(index: Int) ->HomeCollectionViewDownCellVM {
        if self.shopListModel?.restaurants?.count != nil {
            return HomeCollectionViewDownCellVM(restaurantsModel: (self.shopListModel?.restaurants?[index])!)
        }
        return HomeCollectionViewDownCellVM(restaurantsModel: RestaurantsModel())
    }
    
    func getHomeCollectionViewCellVM(index: Int) ->HomeCollectionViewCellVM {
        if self.categoryList?.count != nil {
            return HomeCollectionViewCellVM(categoryListModel: (self.categoryList?[index])!)
        }
        return HomeCollectionViewCellVM(categoryListModel: CategoryListModel())
    }
    
    func getRestarentDishViewControllerVM() ->RestarentDishViewControllerVM {
        return RestarentDishViewControllerVM(shopDetailsModel: self.shopDetailsModel!)
    }
}
