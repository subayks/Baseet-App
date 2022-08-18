//
//  LocationDeliveryVC.swift
//  Baseet App
//
//  Created by VinodKatta on 25/07/22.
//

import UIKit
import CoreLocation

class LocationDeliveryVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var cashimage: UIImageView!
    var menu_vcOrder: OrderSucessViewVC!
    var locationDeliveryVCVM: LocationDeliveryVCVM?
    var locationManager: CLLocationManager?

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.labelPrice.text = self.locationDeliveryVCVM?.totalPrice
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cashimage.isUserInteractionEnabled = true
        cashimage.addGestureRecognizer(tapGestureRecognizer)
        

        locationPermissions()
        
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
        
        self.locationDeliveryVCVM?.navigationClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.menu_vcOrder = self.storyboard?.instantiateViewController(withIdentifier: "OrderSucessViewVC") as? OrderSucessViewVC
                
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "OrderSucessViewVC") as! OrderSucessViewVC
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            self.locationDeliveryVCVM?.latitude = locValue.latitude
            self.locationDeliveryVCVM?.logitude = locValue.longitude
        }
        
    }
        
    
    @IBAction func payNow(_ sender: Any)
    {
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "OrderSucessViewVC") as! OrderSucessViewVC
//
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
        self.locationDeliveryVCVM?.placeOrderApi()
        
        
        
    }
    
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "PayWithVC") as! PayWithVC
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    

}
