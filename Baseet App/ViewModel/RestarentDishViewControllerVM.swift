//
//  RestarentDishViewControllerVM.swift
//  Baseet App
//
//  Created by Subendran on 03/08/22.
//

import Foundation

struct FoodItem {
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
    var proDuctDetailsModel: FoodItems?
    var navigateToDetailsClosure:(()->())?
    var selectedIndex: Int?
    var addToCartModel: AddToCartModel?
    var updateCartModel: UpdateCartModel?
    var getCartModel: GetCartModel?
    var navigateToCartViewClosure:(()->())?
    var limit = 5
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
        self.foodItems = self.shopDetailsModel?.products
        UserDefaults.standard.set(self.shopDetailsModel?.restaurant?.id, forKey: "RestaurentId")
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
    
    func updateValues(itemCount: Int, index: Int, addOns: [AddOns]? = nil, cartId: Int? = nil) {
        var item = self.foodItems?[index]
        item?.itemQuantity = itemCount
        if cartId != nil {
        item?.cartId = cartId
        }
        if addOns != nil && addOns?.count != 0{
        item?.addOns = addOns
        }
        self.foodItems?.remove(at: index)
        self.foodItems?.insert(item ?? FoodItems(), at: index)
        self.reloadRecipieCollectionView?()
    }
    
    func getRecipeDetailsVCVM(index: Int) ->RecipeDetailsVCVM {
        return RecipeDetailsVCVM(proDuctDetailsModel: self.foodItems?[index] ?? FoodItems(), index: index)
    }
    
    func makeProductDetailsCall(item: Int) {
        self.selectedIndex = item
        let index = self.foodItems?[item].id
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            self.apiServices?.getProductDetails(finalURL: "\(Constants.Common.finalURL)/products/details/\(index ?? 1)",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
                DispatchQueue.main.async {
                    self.hideLoadingIndicatorClosure?()
                    if status == true {
                        self.proDuctDetailsModel = result as? FoodItems
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
    
    func makeShopDetailsCall(limit: Int, id: Int) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            self.apiServices?.getShopDetails(finalURL: "\(Constants.Common.finalURL)/products/product_by_restaurant?restaurant_id=\(id)&category_id=0&limit=\(limit)&offset=1",  completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    var shopDetailsModelValue: ShopDetailsModel?
                    shopDetailsModelValue = result as? ShopDetailsModel
                    self.shopDetailsModel?.products?.append(contentsOf: shopDetailsModelValue?.products ?? [FoodItems()])
                    self.reloadRecipieCollectionView?()
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
    
    func getSelectedFood() ->[FoodItems] {
        let selectedItems = self.foodItems?.filter{$0.itemQuantity ?? 0 > 0} ?? [FoodItems()]
        return selectedItems
    }
    
    func getSelectedFood() ->[CartDataModel] {
        let selectedItems = self.getCartModel?.data ?? [CartDataModel()]
        return selectedItems
    }
    
    func getRestaurentFoodPicksVCVM() ->RestaurentFoodPicksVCVM {
        return RestaurentFoodPicksVCVM(foodOrderItems: FoodOrderItems(shopName: self.shopDetailsModel?.restaurant?.name, icon: self.shopDetailsModel?.restaurant?.applogo, foodItems: getSelectedFood()))
    }
    
    func makeLoadMore() {
        if self.shopDetailsModel?.totalSize ?? 0 > limit {
            self.makeShopDetailsCall(limit: limit+10, id: self.shopDetailsModel?.restaurant?.id ?? 0)
        }
    }
    
    func decideFlow(itemCount: Int, index: Int, addOns: [AddOns]? = nil) {
        if self.foodItems?[index].cartId != nil {
            self.updateCartCall(itemCount: itemCount, index: index, addOns: addOns)
        } else {
            if itemCount > 0 {
            self.createCartCall(itemCount: itemCount, index: index, addOns: addOns)
            }
        }
    }
    
    func createCartCall(itemCount: Int, index: Int, addOns: [AddOns]? = nil) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let queryParam = self.getCartParam(itemCount: itemCount, index: index, addOns: addOns)
            self.apiServices?.addToCartApi(finalURL: "\(Constants.Common.finalURL)/products/cart", withParameters: queryParam, completion:  { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.addToCartModel = result as? AddToCartModel
                    self.updateValues(itemCount: itemCount, index: index, addOns: addOns,cartId: self.addToCartModel?.data?[0].id ?? 0)
                } else {
                    self.alertClosure?(errorMessage ?? "Some Technical problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func updateCartCall(itemCount: Int, index: Int, addOns: [AddOns]? = nil) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let queryParam = self.getCartParam(itemCount: itemCount, index: index, addOns: addOns)
            self.apiServices?.updateCartApi(finalURL: "\(Constants.Common.finalURL)/products/update_cart", withParameters: queryParam, completion:  { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.updateCartModel = result as? UpdateCartModel
                    self.updateValues(itemCount: itemCount, index: index, addOns: addOns)
                } else {
                   self.alertClosure?("Some technical problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func getCartParam(itemCount: Int, index: Int, addOns: [AddOns]? = nil) -> String {
        let item = self.foodItems?[index]
        var jsonToReturn: NSDictionary = NSDictionary()
        var addOnsArray = [NSDictionary]()
        
        if let addOns = addOns, addOns.count > 0 {
            for item in (addOns) {
                addOnsArray.append(["addonname": "\(item.name ?? "")", "addonprice": "\(item.price ?? 0)", "addonquantity": "\(item.itemQuantity ?? 0)", "id": "\(item.id ?? 0)"])
            }
        }
        
        if item?.cartId != nil {
            if addOnsArray.count > 0 {
                jsonToReturn = ["food_id": "\(item?.id ?? 0)", "food_qty": "\(itemCount)", "addon": addOnsArray, "cart_id": "\(item?.cartId ?? 0)"]
            } else {
                jsonToReturn = ["food_id": "\(item?.id ?? 0)", "food_qty": "\(itemCount)", "addon": [], "cart_id": "\(item?.cartId ?? 0)"]
            }
            
        } else {
            //Create Cart
            if addOnsArray.count > 0 {
                jsonToReturn =  ["food_id": "\(item?.id ?? 0)", "food_qty": "\(itemCount)", "addon": addOnsArray, "user_id": "\(2)"]
            } else {
                jsonToReturn =  ["food_id": "\(item?.id ?? 0)", "food_qty": "\(itemCount)", "addon": [], "user_id": "\(2)"]
            }
        }
        return self.convertDictionaryToJsonString(dict: jsonToReturn)!
    }

    func convertDictionaryToJsonString(dict: NSDictionary) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject:dict, options:[])
            let jsonDataString = String(data: jsonData, encoding: String.Encoding.utf8)!
            return jsonDataString
        } catch {
            print("JSON serialization failed:  \(error)")
        }
        return nil
    }
    
    func getCartCall() {
        if Reachability.isConnectedToNetwork() {

            self.showLoadingIndicatorClosure?()
            let id = self.addToCartModel?.data?[0].userId
            self.apiServices?.getCartApi(finalURL: "\(Constants.Common.finalURL)/products/get_cart?user_id=\(id ?? "")", completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.getCartModel = result as? GetCartModel
                    self.navigateToCartViewClosure?()
                } else {
                   self.alertClosure?("Some technical problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func updateCurrentCount(itemId: [Int], itemCount: [Int]) {
        for i in 0..<itemId.count {
        if  let index = self.foodItems?.firstIndex(where: {$0.id == itemId[i]}) {
        var item = self.foodItems?[index]
        item?.itemQuantity = itemCount[i]
        self.foodItems?.remove(at: index)
        self.foodItems?.insert(item ?? FoodItems(), at: index)
        self.reloadRecipieCollectionView?()
    }
    }
    }
}

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}

