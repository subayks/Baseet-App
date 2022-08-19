//
//  LocationDeliveryVCVM.swift
//  Baseet App
//
//  Created by Subendran on 19/08/22.
//

import Foundation

class LocationDeliveryVCVM {
    var apiServices: HomeApiServicesProtocol?
    var totalPrice: String?
    var navigationClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var latitude: Double?
    var logitude: Double?
    var placeOrderModel: UpdateCartModel?
    
    init(totalPrice: String, apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.totalPrice = totalPrice
        self.apiServices = apiServices
    }
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func placeOrderApi() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let queryParam = self.getCartParam()
            self.apiServices?.placeOrderApi(finalURL: "\(Constants.Common.finalURL)/customer/order/place", withParameters: queryParam, completion:  { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.placeOrderModel = result as? UpdateCartModel
                    self.navigationClosure?()
                } else {

                self.alertClosure?(errorMessage ?? "Some technical problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func getCartParam() -> String {
        var jsonToReturn: NSDictionary = NSDictionary()
        let resID =  Int((UserDefaults.standard.string(forKey: "RestaurentId") ?? "") as String)
        jsonToReturn =  ["order_amount": "\(self.totalPrice ?? "")", "payment_method": "cash_on_delivery", "order_type": "take_away", "order_time": self.currentTime(), "address": "Financial Street HYD", "latitude": "\(latitude ?? 0.0)", "longitude": "\(logitude ?? 0.0)", "contact_person_name": "Subay", "contact_person_number": "9489588595",  "restaurant_id": "\(resID ?? 0)", "user_id": "\(2)"]
        return self.convertDictionaryToJsonString(dict: jsonToReturn)!
    }
    
    func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(hour):\(minutes)"
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
    
    func getOrderSucessViewVCVM() ->OrderSucessViewVCVM {
        return OrderSucessViewVCVM(orderId: "\(self.placeOrderModel?.order_id ?? 12345)")
    }
}
