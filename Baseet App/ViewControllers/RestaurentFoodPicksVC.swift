//
//  RestaurentFoodPicksVC.swift
//  Baseet App
//
//  Created by VinodKatta on 18/07/22.
//

import UIKit

class RestaurentFoodPicksVC: UIViewController {

    @IBOutlet weak var offerCodeImage: UIImageView!
    @IBOutlet weak var addMoreItem: UIButton!
    @IBOutlet weak var addSpecialNote: UIImageView!
    @IBOutlet weak var totalSavingsAmountLabel: UILabel!
    @IBOutlet weak var restaurentName: UILabel!
    @IBOutlet weak var restaurentImage: UIImageView!
    @IBOutlet weak var restFoodPick: UITableView!
    @IBOutlet weak var addSpecialNotLbl: UILabel!
    
    var locatonDelivery_VC: LocationDeliveryVC!
    var restaurentFoodPicksVCVM: RestaurentFoodPicksVCVM?
    
    override func viewDidLoad() {
        self.setupValues()
        locatonDelivery_VC = self.storyboard?.instantiateViewController(withIdentifier: "LocationDeliveryVC") as? LocationDeliveryVC
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(RestaurentFoodPicksVC.tapFunction))
        addSpecialNotLbl.isUserInteractionEnabled = true
        addSpecialNotLbl.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.restaurentFoodPicksVCVM?.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
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
        
    }
    
    func setupValues() {
        self.restaurentName.text = self.restaurentFoodPicksVCVM?.foodOrderItems?.shopName
        self.restaurentImage.loadImageUsingURL(self.restaurentFoodPicksVCVM?.foodOrderItems?.icon)
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
    
    @IBAction func checkOutBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "LocationDeliveryVC") as! LocationDeliveryVC
        vc.modalTransitionStyle  = .crossDissolve
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
                self.restaurentFoodPicksVCVM?.updateValues(itemCount: itemCount, index: index)
            }
        }
        return cell
    }
}
