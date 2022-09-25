//
//  RestaurentFoodPicksVC.swift
//  Baseet App
//
//  Created by VinodKatta on 18/07/22.
//

import UIKit

class RestaurentFoodPicksVC: UIViewController {
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var locationName: UIButton!
    @IBOutlet weak var savingsOverView: UIView!
    @IBOutlet weak var addSpecialNote: UIImageView!
    @IBOutlet weak var totalSavingsAmountLabel: UILabel!
    @IBOutlet weak var restaurentName: UILabel!
    @IBOutlet weak var restaurentImage: UIImageView!
    @IBOutlet weak var restFoodPick: UITableView!
    @IBOutlet weak var addSpecialNotLbl: UILabel!
    var changedValues:(([Int], [Int])->())?
    var locatonDelivery_VC: LocationDeliveryVC!
    var restaurentFoodPicksVCVM: RestaurentFoodPicksVCVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupValues()
        locatonDelivery_VC = self.storyboard?.instantiateViewController(withIdentifier: "LocationDeliveryVC") as? LocationDeliveryVC
        let tap = UITapGestureRecognizer(target: self, action: #selector(RestaurentFoodPicksVC.tapFunction))
        addSpecialNotLbl.isUserInteractionEnabled = true
        addSpecialNotLbl.addGestureRecognizer(tap)
        restFoodPick.register(UINib(nibName: "BasketFooterViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "BasketFooterViewCell")
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.restaurentFoodPicksVCVM?.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.totalSavingsAmountLabel.text = "QR \(Double(self.restaurentFoodPicksVCVM?.totalSaving() ?? 0))"
                self.restFoodPick.reloadData()
            }
        }
        
        self.restaurentFoodPicksVCVM?.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.restaurentFoodPicksVCVM?.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.restaurentFoodPicksVCVM?.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.restFoodPick.reloadData()
            }
        }
        
    }
    
    func setupNavigationBar() {
        self.locationName.setTitle(UserDefaults.standard.string(forKey: "City_Name"), for: .normal)
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            self.profileIcon.isHidden = true
            self.userName.isHidden = true
        } else {
            self.profileIcon.isHidden = false
            self.userName.isHidden = false
            self.userName.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
        }
    }
    
    func setupValues() {
        self.restaurentName.text = self.restaurentFoodPicksVCVM?.foodOrderItems?.shopName
        self.restaurentImage.loadImageUsingURL(self.restaurentFoodPicksVCVM?.foodOrderItems?.icon)
        self.savingsOverView.layer.borderWidth = 2
        self.savingsOverView.layer.borderColor = UIColor(red: 239/255, green: 250/255, blue: 255/255, alpha: 1).cgColor
        self.totalSavingsAmountLabel.text = "QR \(Double(self.restaurentFoodPicksVCVM?.totalSaving() ?? 0))"
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddNoteVC") as! AddNoteVC
        // vc.modalTransitionStyle  = .crossDissolve
        vc.addNotesVM = self.restaurentFoodPicksVCVM?.getAddNoteVCVM() ?? AddNoteVCVM()
        vc.notes = {  (notes, recording) in
            DispatchQueue.main.async {
                self.restaurentFoodPicksVCVM?.notes = notes
            }
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.changedValues?(self.restaurentFoodPicksVCVM?.itemId ?? [Int](), self.restaurentFoodPicksVCVM?.itemCount ?? [Int]())
        self.dismiss(animated: true,completion: nil)
    }
    
    @objc func actionAddMore() {
        self.changedValues?(self.restaurentFoodPicksVCVM?.itemId ?? [Int](), self.restaurentFoodPicksVCVM?.itemCount ?? [Int]())
        self.dismiss(animated: true,completion: nil)
    }
            
    @objc func actionTakeAway() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            vc.modalPresentationStyle = .fullScreen
            vc.navigationClosure =  { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "LocationDeliveryVC") as! LocationDeliveryVC
                    vc.modalTransitionStyle  = .crossDissolve
                    vc.locationDeliveryVCVM = self.restaurentFoodPicksVCVM?.getLocationDeliveryVCVM(orderType: "take_away")
                    //vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
            self.present(vc, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "LocationDeliveryVC") as! LocationDeliveryVC
            vc.modalTransitionStyle  = .crossDissolve
            vc.locationDeliveryVCVM = self.restaurentFoodPicksVCVM?.getLocationDeliveryVCVM(orderType: "take_away")
            //vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func actionOrderNow() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            vc.modalPresentationStyle = .fullScreen
            vc.navigationClosure =  { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "LocationDeliveryVC") as! LocationDeliveryVC
                    vc.modalTransitionStyle  = .crossDissolve
                    vc.locationDeliveryVCVM = self.restaurentFoodPicksVCVM?.getLocationDeliveryVCVM(orderType: "delivery")
                    //vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
            self.present(vc, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "LocationDeliveryVC") as! LocationDeliveryVC
            vc.modalTransitionStyle  = .crossDissolve
            vc.locationDeliveryVCVM = self.restaurentFoodPicksVCVM?.getLocationDeliveryVCVM(orderType: "delivery")
            //vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension RestaurentFoodPicksVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurentFoodPicksVCVM?.foodOrderItems?.foodItems?.count == 0 ? 1: self.restaurentFoodPicksVCVM?.foodOrderItems?.foodItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.restaurentFoodPicksVCVM?.foodOrderItems?.foodItems?.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddMoreItemCell", for: indexPath) as! AddMoreItemCell
            self.totalSavingsAmountLabel.text = "0.0"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestFoodPickTableViewCell
            cell.RestFoodPickTableViewCellVM = self.restaurentFoodPicksVCVM?.getRestFoodPickTableViewCellVM(index: indexPath.row)
            cell.buttonAdd.tag = indexPath.row
            cell.itemAdded  = { (itemCount, index) in
                DispatchQueue.main.async {
                    self.restaurentFoodPicksVCVM?.updateCartCall(itemCount: itemCount, index: index)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (self.restaurentFoodPicksVCVM?.foodOrderItems?.foodItems?.count ?? 0) > 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BasketFooterViewCell") as! BasketFooterViewCell
            headerView.takeAway.layer.cornerRadius = 10
            headerView.orderNow.layer.cornerRadius = 10
            headerView.takeAway.addTarget(self, action:#selector(self.actionTakeAway), for: .touchUpInside)
            headerView.orderNow.addTarget(self, action:#selector(self.actionOrderNow), for: .touchUpInside)
            headerView.addMoreItem.addTarget(self, action:#selector(self.actionAddMore), for: .touchUpInside)
            headerView.itemTotalValue.text = "QR \(self.restaurentFoodPicksVCVM?.priceCalculation() ?? 0)"
            headerView.taxValue.text = "QR \(self.restaurentFoodPicksVCVM?.taxCalculation() ?? 0)"
            headerView.grandTotalValue.text = self.restaurentFoodPicksVCVM?.grandTotal()
            self.totalSavingsAmountLabel.text = "QR \(Double(self.restaurentFoodPicksVCVM?.totalSaving() ?? 0))"
            
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 383
    }
}
