//
//  RestaurentFoodPicksVCVM.swift
//  Baseet App
//
//  Created by Subendran on 09/08/22.
//

import Foundation

struct FoodOrderItems {
    var shopName: String?
    var icon: String?
    var foodItems: [CartDataModel]?
    
}

class RestaurentFoodPicksVCVM {
    var apiServices: HomeApiServicesProtocol?
    var foodOrderItems: FoodOrderItems?
    var reloadTableViewClosure:(()->())?
    var navigationClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var updateCartModel: UpdateCartModel?
    var itemId = [Int]()
    var itemCount = [Int]()
    
    init(foodOrderItems: FoodOrderItems, apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.foodOrderItems = foodOrderItems
        self.apiServices = apiServices
    }
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func getRestFoodPickTableViewCellVM(index: Int) ->RestFoodPickTableViewCellVM {
        return RestFoodPickTableViewCellVM(foodItems: self.foodOrderItems?.foodItems?[index] ?? CartDataModel())
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
    
    func updateValues(itemCount: Int, index: Int, addOns: [AddOns]? = nil, cartId: Int? = nil) {
        var item = self.foodOrderItems?.foodItems?[index]
        self.itemId.append(Int(item?.id ?? "") ?? 0)
        self.itemCount.append(itemCount)
        item?.foodQty = "\(itemCount)"
//        if cartId != nil {
//        item?.cartId = cartId
//        }
//        if addOns != nil && addOns?.count != 0{
//        item?.addOns = addOns
//        }
        self.foodOrderItems?.foodItems?.remove(at: index)
        self.foodOrderItems?.foodItems?.insert(item ?? CartDataModel(), at: index)
        self.reloadTableViewClosure?()
    }
    
    func getCartParam(itemCount: Int, index: Int, addOns: [AddOns]? = nil) -> String {
        let item = self.foodOrderItems?.foodItems?[index]
        var jsonToReturn: NSDictionary = NSDictionary()
        var addOnsArray = [NSDictionary]()

        if let addOns = addOns, addOns.count > 0 {
            for item in (addOns) {
                addOnsArray.append(["addonname": item.name ?? "", "addonprice": item.price ?? "", "addonquantity": item.itemQuantity ?? ""])
            }
        }
            jsonToReturn = ["food_id": "\(item?.id ?? "")", "food_qty": "\(itemCount)", "addon": "\(addOnsArray)", "cart_id": "\(item?.cartid ?? "")"]

            
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
    
    func getLocationDeliveryVCVM() ->LocationDeliveryVCVM {
        return LocationDeliveryVCVM(totalPrice: grandTotal())
    }
    
    func priceCalculation() ->Int {
        var priceArray = [Int]()
        if let selectedFoodItems = self.foodOrderItems?.foodItems {
            for item in selectedFoodItems {
            priceArray.append((item.tprice ?? 0) * (Int(item.foodQty ?? "") ?? 0))
//            if let adOnItem = item.addOns, adOnItem.count > 0 {
//            for adOn in adOnItem {
//                if adOn.itemQuantity != nil && adOn.itemQuantity ?? 0 > 0 {
//                    priceArray.append((adOn.price ?? 0) * (adOn.itemQuantity ?? 0))
//                }
//            }
//            }
        }
            return priceArray.sum()
        }
        return 0
    }
    
    func taxCalculation() ->Int {
        let value = calculatePercentage(value: Double(priceCalculation()),percentageVal: 10)
         print(value)
        return Int(value)
    }
    
    //Calucate percentage based on given values
    public func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value * percentageVal
        return val / 100.0
    }
    
    func grandTotal() ->String {
        return "QR \(self.priceCalculation() + self.taxCalculation())"
    }
    
    
    
}
