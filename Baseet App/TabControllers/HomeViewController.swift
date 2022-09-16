//
//  HomeViewController.swift
//  SideMenu-IOS-Swift
//
//  Created by apple on 12/01/22.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var menu_vc: MenuVC!
    
    @IBOutlet weak var locationInfo: UILabel!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var cartCount: UIButton!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var collectionViewTop: UICollectionView!
    @IBOutlet weak var collectionviewSec: UICollectionView!
    @IBOutlet weak var collectionviewThird: UICollectionView!
    @IBOutlet weak var collectionviewDown: UICollectionView!
    var locationManager: CLLocationManager?

    @IBOutlet weak var menuBtn: UIButton!
    var homeViewControllerVM = HomeViewControllerVM()
    
    override func viewDidLoad()
    
    {
        super.viewDidLoad()
        homeViewControllerVM.makeCategoryListCall()
        homeViewControllerVM.makeShopNearyByCall()
        locationPermissions()
        self.cartView.isHidden = true
        //        searchTF.addTarget(self, action: #selector(HomeViewController.textViewShouldBeginEditing(_:)), for: .editingChanged)
        
        //        searchTF.addTarget(self, action: #selector(HomeViewController.textFieldDidBeginEditing), for: UIControl.Event.touchDown)
        
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.gray, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 5.0)
        
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as? MenuVC
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
        
        cartView.layer.cornerRadius = 30
        cartButton.layer.cornerRadius = 30
        cartCount.layer.cornerRadius = cartCount.frame.height/2
        self.cartCount.clipsToBounds = true
        
        cartView.layer.borderWidth = 2
        cartView.layer.borderColor = UIColor.systemGray6.cgColor
        
        self.locationInfo.text = UserDefaults.standard.string(forKey: "Location_Info")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.homeViewControllerVM.getCartCall()
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.gray, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 5.0)
        
        self.homeViewControllerVM.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.homeViewControllerVM.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.homeViewControllerVM.reloadCollectionViewDown = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.collectionviewDown.reloadData()
            }
        }
        
        self.homeViewControllerVM.reloadCollectionViewTop = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.collectionViewTop.reloadData()
            }
        }
        
        self.homeViewControllerVM.navigateToDetailsClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "RestarentDishViewController") as! RestarentDishViewController
                // vc.modalTransitionStyle = .coverVertical
                vc.restarentDishViewControllerVM = self.homeViewControllerVM.getRestarentDishViewControllerVM()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        self.homeViewControllerVM.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.homeViewControllerVM.getCartCountClosure = { [weak self]  in
            DispatchQueue.main.async {
                guard let self = self else {return}
                if let cartCountValue = self.homeViewControllerVM.getCartModel?.data?.count, cartCountValue > 0 {
                    self.cartView.isHidden = false
                self.cartCount.setTitle("\(cartCountValue)", for: .normal)
                } else {
                    self.cartView.isHidden = true
                }
            }
        }
    }
    
    @objc func respondToGesture(gesture: UISwipeGestureRecognizer)
    {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.right:
            show_menu()
        case UISwipeGestureRecognizer.Direction.left:
            close_menu()
        default:
            break
        }
    }
    
    func show_menu()
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MenuVC") as! MenuVC
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func close_menu()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionCart(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RestaurentFoodPicksVC") as! RestaurentFoodPicksVC
        vc.restaurentFoodPicksVCVM = self.homeViewControllerVM.getRestaurentFoodPicksVCVM()
        vc.changedValues  = { (itemCount, index) in
            DispatchQueue.main.async {
                //   self.restarentDishViewControllerVM?.getCartCall(isFromCartScreen: true)
                //  self.restarentDishViewControllerVM?.updateCurrentCount(itemId: itemCount, itemCount: index)
            }
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func menubtnAct(_ sender: Any)
    {
        self.show_menu()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            guard let locValue:CLLocation = manager.location else {return}

            
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
            })
            self.locationInfo.text = UserDefaults.standard.string(forKey: "Location_Info")
        } else if status == .denied {
            //Show Error Screen
        }
     

    }
}


extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewTop
        {
            return self.homeViewControllerVM.categoryList?.count ?? 0
        }
        if collectionView == self.collectionviewThird
        {
            return 8
        }
        if collectionView == self.collectionviewDown
        {
            return self.homeViewControllerVM.shopListModel?.restaurants?.count ?? 0
        }
        
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if collectionView == self.collectionViewTop {
            let cellA = collectionViewTop.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
            cellA.homeCollectionViewCellVM = self.homeViewControllerVM.getHomeCollectionViewCellVM(index: indexPath.row)
            return cellA
        }
        
        else if collectionView == self.collectionviewThird{
            let cellC = collectionviewThird.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewThirdCell
            return cellC
        }
        
        else if collectionView == self.collectionviewSec{
            let cellB = collectionviewSec.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewSecCell
            cellB.lblview.layer.borderColor = UIColor.red.cgColor
            cellB.lblview.layer.cornerRadius = 10
            
            
            // ...Set up cell
            
            return cellB
        }
        
        else {
            let celldown = collectionviewDown.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewDownCell
            celldown.homeCollectionViewDownCellVM = self.homeViewControllerVM.getHomeCollectionViewDownCellVM(index: indexPath.row)
            return celldown
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionviewDown {
            self.homeViewControllerVM.makeShopDetailsCall(id: self.homeViewControllerVM.shopListModel?.restaurants?[indexPath.row].id ?? 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionviewDown {
        let yourWidth = collectionView.bounds.width

        return CGSize(width: yourWidth, height: 262)
        }
        return CGSize(width: collectionView.bounds.width, height: 158)
    }
    
    
}


extension HomeViewController:UITextViewDelegate
{
    
    //    @objc func textFieldDidChange(_ textField: UITextField) {
    //        print("Yes Working")
    //
    //    }
    
    //    @objc func textViewDidBeginEditing(_ textView: UITextView) {
    //        print("Yes Working")
    //    }
    
    //    @objc func textViewDidChangeSelection(_ textView: UITextView) {
    //        print("Yes Working")
    //    }
    
    //    @objc func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    //        print("true")
    //      return true
    //    }
    //  @objc  func textFieldDidBeginEditing(_ textField: UITextField) {
    ////            print("tapped")
    ////            searchTF.backgroundColor = UIColor.blue
    //      let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    //      let vc = storyboard.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
    //      vc.modalPresentationStyle = .fullScreen
    //      self.present(vc, animated: true, completion: nil)
    //
    //
    //    }
    
    
    
}
