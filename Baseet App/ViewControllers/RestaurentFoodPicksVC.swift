//
//  RestaurentFoodPicksVC.swift
//  Baseet App
//
//  Created by VinodKatta on 18/07/22.
//

import UIKit

class RestaurentFoodPicksVC: UIViewController {

    @IBOutlet weak var restFoodPick: UITableView!
    @IBOutlet weak var addSpecialNotLbl: UILabel!
    
    var locatonDelivery_VC: LocationDeliveryVC!
    var restaurentFoodPicksVCVM: RestaurentFoodPicksVCVM?
    
    override func viewDidLoad()
    {
        
        locatonDelivery_VC = self.storyboard?.instantiateViewController(withIdentifier: "LocationDeliveryVC") as? LocationDeliveryVC
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(RestaurentFoodPicksVC.tapFunction))
        addSpecialNotLbl.isUserInteractionEnabled = true
        addSpecialNotLbl.addGestureRecognizer(tap)

        
    }
    
    @objc
        func tapFunction(sender:UITapGestureRecognizer) {
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestFoodPickTableViewCell
        return cell
    }
    
    
    
    
    
}
