//
//  RestaurentFoodPicksVCVM.swift
//  Baseet App
//
//  Created by Subendran on 09/08/22.
//

import Foundation

class RestaurentFoodPicksVCVM {
    var apiServices: HomeApiServicesProtocol?
    var getCartModel: [CartDataModel]?
    var reloadTableViewClosure:(()->())?
    var navigationClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var updateCartModel: UpdateCartModel?
    var itemId = [Int]()
    var itemCount = [Int]()
    var userID = String()
    var getCartData: GetCartModel?
    var notes: String?
    
    init(getCartModel: [CartDataModel], apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.getCartModel = getCartModel
        self.apiServices = apiServices
        self.userID = self.getCartModel?[0].cartuserid ?? ""
    }
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func getRestFoodPickTableViewCellVM(index: Int) ->RestFoodPickTableViewCellVM {
        return RestFoodPickTableViewCellVM(foodItems: self.getCartModel?[index] ?? CartDataModel())
    }
    
    func updateCartCall(itemCount: Int, index: Int, addOns: [AddOns]? = nil) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let queryParam = self.getCartParam(itemCount: itemCount, index: index)
            self.apiServices?.updateCartApi(finalURL: "\(Constants.Common.finalURL)/products/update_cart", withParameters: queryParam, completion:  { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.updateCartModel = result as? UpdateCartModel
                    let item = self.getCartModel?[index]
                    self.itemId.append(Int(item?.id ?? "") ?? 0)
                    self.itemCount.append(itemCount)
                    self.getCartCall()
              //      self.updateValues(itemCount: itemCount, index: index, addOns: addOns)
                } else {
                   self.alertClosure?(errorMessage ?? "Some Technical Problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func getCartCall() {
        if Reachability.isConnectedToNetwork() {

            self.showLoadingIndicatorClosure?()
            self.apiServices?.getCartApi(finalURL: "\(Constants.Common.finalURL)/products/get_cart?user_id=\(self.userID)", completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.getCartData = result as? GetCartModel
                    self.getCartModel = self.getCartData?.data
                    self.reloadTableViewClosure?()
                } else {
                   self.alertClosure?(errorMessage ?? "Some Technical Problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
//    func updateValues(itemCount: Int, index: Int, addOns: [AddOns]? = nil, cartId: Int? = nil) {
//        var item = self.foodOrderItems?.foodItems?[index]
//        self.itemId.append(Int(item?.id ?? "") ?? 0)
//        self.itemCount.append(itemCount)
//        item?.foodQty = "\(itemCount)"
////        if cartId != nil {
////        item?.cartId = cartId
////        }
////        if addOns != nil && addOns?.count != 0{
////        item?.addOns = addOns
////        }
//        self.foodOrderItems?.foodItems?.remove(at: index)
//        self.foodOrderItems?.foodItems?.insert(item ?? CartDataModel(), at: index)
//        self.reloadTableViewClosure?()
//    }
    
    func getCartParam(itemCount: Int, index: Int) -> String {
        let item = self.getCartModel?[index]
        var jsonToReturn: NSDictionary = NSDictionary()
        var addOnsArray = [NSDictionary]()

        if let addOns = item?.addon, addOns.count > 0 {
            for addonItem in (addOns) {
                addOnsArray.append(["addonname": "\(addonItem.addonname ?? "")", "addonprice": "\(addonItem.addonprice ?? "")", "addonquantity": "\(addonItem.addonquantity ?? "")", "id": "\(addonItem.id ?? "")"])
            }
        }
        
        if addOnsArray.count > 0 {
            jsonToReturn = ["food_id": "\(item?.id ?? "")", "food_qty": "\(itemCount)", "addon": addOnsArray, "cart_id": "\(item?.cartid ?? "")"]
        } else {
            jsonToReturn = ["food_id": "\(item?.id ?? "")", "food_qty": "\(itemCount)", "addon": [], "cart_id": "\(item?.cartid ?? "")"]
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
    
    func getLocationDeliveryVCVM(orderType: String) ->LocationDeliveryVCVM {
        return LocationDeliveryVCVM(totalPrice: "\(self.priceCalculation() + self.taxCalculation())",discountAmount: String(self.totalSaving()), taxAmount: String(self.taxCalculation()), notes: self.notes ?? "", orderType: orderType)
    }
    
//    func priceCalculation() ->Int {
//        var priceArray = [Int]()
//        if let selectedFoodItems = self.foodOrderItems?.foodItems {
//            for item in selectedFoodItems {
//                priceArray.append((item.price! as NSString).integerValue * (Int(item.foodQty ?? "") ?? 0))
//            if let adOnItem = item.addon, adOnItem.count > 0 {
//            for adOn in adOnItem {
//                if adOn.addonquantity != nil && (Int(adOn.addonquantity ?? "") ?? 0) > 0 {
//                    priceArray.append((Int(adOn.addonprice ?? "") ?? 0) * (Int(adOn.addonquantity ?? "") ?? 0))
//                }
//            }
//            }
//        }
//            return priceArray.sum()
//        }
//        return 0
//    }
    
    func priceCalculation() ->Int {
        var priceArray = [Int]()
        if let selectedFoodItems = self.getCartModel {
            for item in selectedFoodItems {
                priceArray.append(item.tprice ?? 0)
            }
            return priceArray.sum()
        }
        return 0
    }
    
    func totalSaving() ->Double {
        var discount = [Double]()
        if let selectedFoodItems = self.getCartModel {
            for item in selectedFoodItems {
                discount.append(Double(item.discount ?? "") ?? 0.00)
            }
            return discount.sum()
        }
        return 0
    }
    
    func taxCalculation() ->Int {
        var taxArray = [Int]()
        if let selectedFoodItems = self.getCartModel {
            for item in selectedFoodItems {
                taxArray.append(Int(item.tax ?? "") ?? 0)
            }
            return taxArray.sum()
        }
        return 0
    }
    
    func grandTotal() ->String {
        return "QR \(self.priceCalculation() + self.taxCalculation())"
    }
    
    func getAddNoteVCVM() ->AddNoteVCVM {
        return AddNoteVCVM(notes: self.notes ?? "", voiceRecord: "")
    }
    
}
