//
//  HomeApiServices.swift
//  Baseet App
//
//  Created by Subendran on 01/08/22.
//

import Foundation
protocol HomeApiServicesProtocol {
    func getShopNearBy(finalURL: String, httpHeaders: [String: String], completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getCategoryList(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getShopDetails(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getProductDetails(finalURL: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func addToCartApi(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func updateCartApi(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func deleteCartApi(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func getCartApi(finalURL: String, httpHeaders: [String: String], completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
    func placeOrderApi(finalURL: String, withParameters: String, completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void)
}

class HomeApiServices: HomeApiServicesProtocol {
    func placeOrderApi(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let headers = [
            "Authorization": "\(Constants.Common.authKEy)",
            
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(UpdateCartModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    
    func getCartApi(finalURL: String, httpHeaders:  [String: String],  completion: @escaping(_ status: Bool?, _ code: String?, _ response: AnyObject?, _ error: String?)-> Void) {
       
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: httpHeaders, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(UpdateCartModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func deleteCartApi(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let headers = [
            "Authorization": "\(Constants.Common.authKEy)",
            
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "POST", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(UpdateCartModel.self, from: result!)
                    completion(true,errorCode,values as AnyObject?,error)
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func updateCartApi(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let headers = [
            "Authorization": "\(Constants.Common.authKEy)",
            
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters: withParameters, withHttpMethod: "POST", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(UpdateCartModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func addToCartApi(finalURL: String, withParameters: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        let headers = [
            "Authorization": "\(Constants.Common.authKEy)",
            
            ]
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   withParameters, withHttpMethod: "POST", withContentType: "Application/json", withHeaders: headers, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(AddToCartModel.self, from: result!)
                    if values.errors != nil {
                        completion(false,errorCode,nil,values.errors?[0].message)
                    } else {
                    completion(true,errorCode,values as AnyObject?,error)
                    }
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func getProductDetails(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: [String: String](), completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(FoodItems.self, from: result!)
                    completion(true,errorCode,values as AnyObject?,error)
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func getShopDetails(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: [String: String](), completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(ShopDetailsModel.self, from: result!)
                    completion(true,errorCode,values as AnyObject?,error)
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    func getCategoryList(finalURL: String, completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestArrayResponseCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: [String: String](), completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode([CategoryListModel].self, from: result!)
                    completion(true,errorCode,values as AnyObject?,error)
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
    
    func getShopNearBy(finalURL: String, httpHeaders: [String : String], completion: @escaping (Bool?, String?, AnyObject?, String?) -> Void) {
        
        NetworkAdapter.clientNetworkRequestCodable(withBaseURL: finalURL, withParameters:   "", withHttpMethod: "GET", withContentType: "Application/json", withHeaders: httpHeaders, completionHandler: { (result: Data?, showPopUp: Bool?, error: String?, errorCode: String?)  -> Void in
            
            if let error = error {
                completion(false,errorCode,nil,error)
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    if result == nil {
                        completion(false,errorCode,nil,"Unhandled Error")
                        return
                    }
                    let values = try decoder.decode(ShopListModel.self, from: result!)
                    completion(true,errorCode,values as AnyObject?,error)
                    
                } catch let error as NSError {
                    //do something with error
                    completion(false,errorCode,nil,error.localizedDescription)
                }
                
            }
        }
        )
    }
    
}
