//
//  LocationDeliveryVC.swift
//  Baseet App
//
//  Created by VinodKatta on 25/07/22.
//

import UIKit
import CoreLocation
import SadadPaymentSDK

enum PaymentType {
    case cash
    case card
    case none
}

class LocationDeliveryVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var paymentIMage: UIButton!
    var menu_vcOrder: OrderSucessViewVC!
    var locationDeliveryVCVM: LocationDeliveryVCVM?
    var locationManager: CLLocationManager?
    var strAccessToken:String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.labelPrice.text = "QR \(self.locationDeliveryVCVM?.totalPrice ?? "")"
        locationPermissions()
        self.locationLabel.text = UserDefaults.standard.string(forKey: "Location_Info")
        self.paymentIMage.layer.cornerRadius = 10
        self.nameLabel.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
    }
    
    //setup location properties
    func locationPermissions() {
        //Get Location Permission
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.startUpdatingHeading()
        
        if CLLocationManager.locationServicesEnabled()  {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingHeading()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.locationDeliveryVCVM?.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.locationDeliveryVCVM?.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.locationDeliveryVCVM?.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.locationDeliveryVCVM?.navigationClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.menu_vcOrder = self.storyboard?.instantiateViewController(withIdentifier: "OrderSucessViewVC") as? OrderSucessViewVC
                
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "OrderSucessViewVC") as! OrderSucessViewVC
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                vc.orderSucessViewVCVM = self.locationDeliveryVCVM?.getOrderSucessViewVCVM()
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        self.locationDeliveryVCVM?.navigateToPaymentVC = { [weak self] (token) in
            DispatchQueue.main.async {
                guard let self = self else {return}

                let arrProduct:NSMutableArray = NSMutableArray()
                 let productDIC = NSMutableDictionary()
            //     productDIC.setValue("GUCCI Perfume", forKey: "itemname")
              //   productDIC.setValue(1, forKey: "quantity")
                productDIC.setValue(Double(self.locationDeliveryVCVM?.totalPrice ?? "") ?? 0.00, forKey: "amount")
                 arrProduct.add(productDIC)
                 arrProduct.add(productDIC)
                
               // self.locationDeliveryVCVM?.placeOrderApi()
                
                let podBundle = Bundle(for: SelectPaymentMethodVC.self)

                let storyboard = UIStoryboard(name: "mainStoryboard", bundle: podBundle)

                let vc = storyboard.instantiateViewController(withIdentifier: "SelectPaymentMethodVC") as! SelectPaymentMethodVC

                vc.delegate = self
                vc.isSandbox = false
                vc.strMobile = "7080618000"
                vc.strEmail = "test@gmail.com"
                vc.strAccessToken = token
                vc.amount = Double(self.locationDeliveryVCVM?.totalPrice ?? "") ?? 0.00
                vc.arrProductDetails = arrProduct
                vc.modalPresentationStyle = .overCurrentContext
                let navigationController = UINavigationController(rootViewController: vc)
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            self.locationDeliveryVCVM?.latitude = locValue.latitude
            self.locationDeliveryVCVM?.logitude = locValue.longitude
            
            guard let locValue:CLLocation = manager.location else {return}
            
//            let lat = locValue.coordinate.latitude
//            let long = locValue.coordinate.longitude
            
            let lat = 17.380281
            let long = 78.4732695
            
            UserDefaults.standard.set(lat, forKey: "lat")
            UserDefaults.standard.set(long, forKey: "long")
            self.locationDeliveryVCVM?.changeZoneId()
            
            CLGeocoder().reverseGeocodeLocation(locValue, completionHandler: {(placemarks, error) -> Void in
                    print(locValue)
                    guard error == nil else {
                        print("Reverse geocoder failed with error")
                        return
                    }
                guard placemarks!.count > 0 else {
                        print("Problem with the data received from geocoder")
                        return
                    }
                let pm = placemarks?[0]
                print(pm!.locality as Any)
                print(pm!.administrativeArea!)
                print(pm!.country!)
                print(pm!.subLocality!)
                print(pm!.postalCode!)
            
                
                let locationDashBord = "\(pm!.locality!), \(pm!.subLocality!),\(pm!.administrativeArea!) \(pm!.country!),\(pm!.postalCode!)"
               print(locationDashBord)
                UserDefaults.standard.set(locationDashBord, forKey: "Location_Info")
                UserDefaults.standard.set((pm!.locality!), forKey: "City_Name")
                self.locationLabel.text = UserDefaults.standard.string(forKey: "Location_Info")
            })
        } else if status == .denied {
            //show error screen
        }

    }
    
    @IBAction func payNow(_ sender: Any) {
        if  self.locationDeliveryVCVM?.paymentType == .cash {
            self.locationDeliveryVCVM?.placeOrderApi()
        } else if  self.locationDeliveryVCVM?.paymentType == .card {
            self.locationDeliveryVCVM?.accessToken()
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please select payment type", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func actionPaymentType(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "PayWithVC") as! PayWithVC
        vc.paymentType = { [weak self] (paymentType) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.locationDeliveryVCVM?.paymentType = paymentType
                if paymentType == .card {
                    self.paymentIMage.setTitle("Card", for: .normal)
                    self.paymentIMage.setImage(UIImage(named: "debitCard"), for: .normal)
                } else if paymentType == .cash {
                    self.paymentIMage.setTitle("Cash", for: .normal)
                    self.paymentIMage.setImage(UIImage(named: "locationDelivery"), for: .normal)
                }
            }
        }
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
//    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "PayWithVC") as! PayWithVC
//        vc.paymentType = { [weak self] (paymentType) in
//            DispatchQueue.main.async {
//                guard let self = self else {return}
//                self.locationDeliveryVCVM?.paymentType = paymentType
//                if paymentType == .card {
//                    self.cashimage.image = UIImage(named: "debitCard")
//                } else if paymentType == .cash {
//                self.cashimage.image = UIImage(named: "locationDelivery")
//                }
//            }
//        }
//        vc.modalTransitionStyle = .coverVertical
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
//    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    

}

extension LocationDeliveryVC: SelectCardReponseDelegate {
    func ResponseData(DataDIC: NSMutableDictionary) {
        DispatchQueue.main.async {
            let statusCode = DataDIC.value(forKey: "statusCode") as! Int
            if statusCode == 200 {
            self.locationDeliveryVCVM?.placeOrderApi()
            } else {
                let alert = UIAlertController(title: "Alert", message: DataDIC.value(forKey: "message") as? String, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
