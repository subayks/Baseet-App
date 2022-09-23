//
//  LocationAccessVC.swift
//  Baseet App
//
//  Created by VinodKatta on 22/07/22.
//

import UIKit
import CoreLocation
import MapKit

class LocationAccessVC: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var mainAreaLbl: UILabel!
    @IBOutlet weak var localArea: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let locationAccessVM = LocationAccessVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()

            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()

            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }

            mapView.delegate = self
            mapView.mapType = .standard
            mapView.isZoomEnabled = true
            mapView.isScrollEnabled = true

            if let coor = mapView.userLocation.location?.coordinate{
                mapView.setCenter(coor, animated: true)
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
        locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate

        mapView.mapType = MKMapType.standard

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "You are Here"
        mapView.addAnnotation(annotation)
        
        let userLocation :CLLocation = locations[0] as CLLocation

        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        let lat = 17.380281
        let long = 78.4732695
        UserDefaults.standard.set(lat, forKey: "lat")
        UserDefaults.standard.set(long, forKey: "long")
        //Launch App first Time
        if UserDefaults.standard.string(forKey: "User_Id") == nil {
        UserDefaults.standard.set((Int(String(userLocation.coordinate.latitude).replacingOccurrences(of: ".", with: ""))), forKey: "User_Id")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        }

        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: {(placemarks, error) -> Void in
                print(userLocation)
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
            self.mainAreaLbl.text = (pm!.locality!)
            self.localArea.text = "\(String(describing: pm!.administrativeArea!)),\(pm!.country!)\(pm!.subLocality!) \(pm!.postalCode!)"
            UserDefaults.standard.set(locationDashBord, forKey: "Location_Info")
            UserDefaults.standard.set((pm!.locality!), forKey: "City_Name")
            })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.locationAccessVM.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.locationAccessVM.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.locationAccessVM.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.locationAccessVM.navigateToDetailsClosure = { [weak self] in
            DispatchQueue.main.async {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "tabVC")
                vc.modalPresentationStyle = .fullScreen
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
   
    
    @IBAction func locationConfirmBtn(_ sender: Any) {
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "LoginViewController")
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
        self.locationAccessVM.changeZoneId()
       
    }
}
