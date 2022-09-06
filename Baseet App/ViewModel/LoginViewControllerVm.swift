//
//  LoginViewControllerVm.swift
//  Baseet App
//
//  Created by Subendran on 02/09/22.
//

import Foundation

class LoginViewControllerVm {
    var apiServices: HomeApiServicesProtocol?
    var navigationClosure:(()->())?
    var alertClosure:((String)->())?
    var errorClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    var loginModel: LoginModel?
    
    init(apiServices: HomeApiServicesProtocol = HomeApiServices()) {
        self.apiServices = apiServices
    }
    
    func makeLoginCall(phoneNumber: String) {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let param = self.getLoginParam(phoneNumber: phoneNumber)
            self.apiServices?.loginApi(finalURL: "\(Constants.Common.finalURL)/auth/login", withParameters: param, completion: { (status: Bool? , errorCode: String?,result: AnyObject?, errorMessage: String?) -> Void in
            DispatchQueue.main.async {
                self.hideLoadingIndicatorClosure?()
                if status == true {
                    self.loginModel = result as? LoginModel
                    let token = "Bearer " + (self.loginModel?.token ?? "")
                    UserDefaults.standard.set(token, forKey: "AuthToken")
                    UserDefaults.standard.set(self.loginModel?.user_id, forKey: "User_Id")
                    self.navigationClosure?()
                } else {
                   self.alertClosure?("Some technical problem")
                }
            }
        })
        } else {
            self.alertClosure?("No Internet Availabe")
        }
    }
    
    func getLoginParam(phoneNumber: String) ->String {
    let jsonToReturn: NSDictionary = ["phone": "\(phoneNumber)", "password": "\(123456)"]
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
}
