//
//  RestarentDishViewControllerVM.swift
//  Baseet App
//
//  Created by Subendran on 03/08/22.
//

import Foundation

struct FoodItems {
    var itemNo: Int?
    var itemName: String?
    var itemImage: String?
    var itemQuantity: Int?
    var qrCode: String?
    var addOn: [AddOns]?
    var rating: String?
}

class RestarentDishViewControllerVM {
    var apiServices: HomeApiServicesProtocol?
    var shopDetailsModel: ShopDetailsModel?
    var navigationClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var reloadRecipieCollectionView:(()->())?
    var proDuctDetailsModel: ProDuctDetailsModel?
    var navigateToDetailsClosure:(()->())?
    var foodItems: [FoodItems]? {
        didSet {
            self.reloadRecipieCollectionView?()
        }
    }
    
    init(shopDetailsModel: ShopDetailsModel, apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.shopDetailsModel = shopDetailsModel
        self.apiServices = apiServices
    }
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func setUpItemsList() {
        foodItems = [FoodItems(itemNo: 1,itemName: "Pizza Roll", itemImage: "http://baseet.thedemostore.in/storage/app/public/product/2022-07-01-62bea4d30e769.png", itemQuantity: 0, qrCode: "QR1", rating: "5"), FoodItems(itemNo: 2,itemName: "Mutton Burger", itemImage: "http://baseet.thedemostore.in/storage/app/public/product/2022-07-14-62d011ecb0c5d.png", itemQuantity: 0, qrCode: "QR2", rating: "4"), FoodItems(itemNo: 3,itemName: "Pizza", itemImage:"http://baseet.thedemostore.in/storage/app/public/product/2022-07-29-62e4cb66b70fa.png", itemQuantity: 0, qrCode: "QR3", rating: "3"), FoodItems(itemNo: 4,itemName: "Double Roll", itemImage: "http://baseet.thedemostore.in/storage/app/public/product/2022-07-29-62e4cc1af2bd8.png", itemQuantity: 0, qrCode: "QR4", rating: "2"), FoodItems(itemNo: 5,itemName: "Prawns Biryani", itemImage: "http://baseet.thedemostore.in/storage/app/public/product/2022-08-02-62e94eeba156d.png", itemQuantity: 0, qrCode: "QR5", rating: "1")]
    }
    
    func isItemAvailable() ->Bool {
        if let items = self.foodItems {
            let itemAvailable = items.filter{$0.itemQuantity ?? 0 > 0}
            if itemAvailable.count == 0 {
                return false
            } else {
                return true
            }
        }
        return false
    }
    
    func updateValues(itemCount: Int, index: Int) {
        var item = self.foodItems?[index]
        item?.itemQuantity = itemCount
        self.foodItems?.remove(at: index)
        self.foodItems?.insert(item ?? FoodItems(), at: index)
        self.reloadRecipieCollectionView?()
    }
    
    func getRecipeDetailsVCVM() ->RecipeDetailsVCVM {
        return RecipeDetailsVCVM(proDuctDetailsModel: self.proDuctDetailsModel!)
    }
    
    func makeProductDetailsCall(item: Int) {
        let index = self.foodItems?[item].itemNo
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            self.apiServices?.getProductDetails(finalURL: "\(Constants.Common.finalURL)/products/details/\(index ?? 1)",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                DispatchQueue.main.async {
                    self.hideLoadingIndicatorClosure?()
                    if status == true {
                        self.proDuctDetailsModel = result as? ProDuctDetailsModel
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
    
    func getResDishCollectionViewCellTwoVM(index: Int) ->ResDishCollectionViewCellTwoVM {
        return ResDishCollectionViewCellTwoVM(foodItems: (self.foodItems?[index])!)
    }
    
    func createItems() ->FoodOrderItems {
        return FoodOrderItems()
    }
    
    func getRestaurentFoodPicksVCVM() ->RestaurentFoodPicksVCVM {
        return RestaurentFoodPicksVCVM(foodOrderItems: self.createItems())
    }
}
