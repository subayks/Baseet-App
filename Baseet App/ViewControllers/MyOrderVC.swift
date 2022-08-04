//
//  MyOrderVC.swift
//  Baseet App
//
//  Created by VinodKatta on 15/07/22.
//

import UIKit

class MyOrderVC: UIViewController {

   
    
    @IBOutlet weak var pastOrderView: UIView!
    
    @IBOutlet weak var myCurrentOrderTB: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pastOrderView.isHidden = true

        
    }
    
    @IBAction func myOderSeqment(_ sender: Any) {
        
        if (sender as AnyObject).selectedSegmentIndex == 0
        {
            
            self.pastOrderView.isHidden = true
            
        }
        else if (sender as AnyObject).selectedSegmentIndex == 1
        {
            self.pastOrderView.isHidden = false
        }
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
   
    

}
extension MyOrderVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCurrentOrderTableViewCell
        cell.modifyOrderBtn.tag = indexPath.row
        cell.orderDetailsBtn.tag = indexPath.row
        cell.modifyOrderBtn.addTarget(self, action: #selector(modifyAction), for: .touchUpInside)
        cell.orderDetailsBtn.addTarget(self, action: #selector(orderDetailsAction), for: .touchUpInside)
        return cell
    }
    
    @objc func modifyAction()
    {
        print("no")
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "OrderModifyVC") as! OrderModifyVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func orderDetailsAction()
    {
        print("no")
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "OrderDetailsVC") as! OrderDetailsVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    
    
}
