//
//  RestaurentFoodPicksVC.swift
//  Baseet App
//
//  Created by VinodKatta on 18/07/22.
//

import UIKit

class RestaurentFoodPicksVC: UIViewController {

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
        self.setupValues()
        locatonDelivery_VC = self.storyboard?.instantiateViewController(withIdentifier: "LocationDeliveryVC") as? LocationDeliveryVC
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(RestaurentFoodPicksVC.tapFunction))
        addSpecialNotLbl.isUserInteractionEnabled = true
        addSpecialNotLbl.addGestureRecognizer(tap)
        restFoodPick.register(UINib(nibName: "BasketFooterViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "BasketFooterViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @objc func actionAddMore() {
        self.changedValues?(self.restaurentFoodPicksVCVM?.itemId ?? [Int](), self.restaurentFoodPicksVCVM?.itemCount ?? [Int]())
        self.dismiss(animated: true,completion: nil)
    }
    
    @objc func bucketButtonClicked() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "LocationDeliveryVC") as! LocationDeliveryVC
        vc.modalTransitionStyle  = .crossDissolve
        vc.locationDeliveryVCVM = self.restaurentFoodPicksVCVM?.getLocationDeliveryVCVM()
        //vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension RestaurentFoodPicksVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurentFoodPicksVCVM?.foodOrderItems?.foodItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BasketFooterViewCell") as! BasketFooterViewCell
        headerView.goToBasket.addTarget(self, action:#selector(self.bucketButtonClicked), for: .touchUpInside)
        
        headerView.addMoreItem.addTarget(self, action:#selector(self.actionAddMore), for: .touchUpInside)
        headerView.itemTotalValue.text = "QR \(self.restaurentFoodPicksVCVM?.priceCalculation() ?? 0)"
        headerView.taxValue.text = "QR \(self.restaurentFoodPicksVCVM?.taxCalculation() ?? 0)"
        headerView.grandTotalValue.text = self.restaurentFoodPicksVCVM?.grandTotal()

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 383
    }
}
