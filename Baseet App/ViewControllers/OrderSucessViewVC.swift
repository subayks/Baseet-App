//
//  OrderSucessViewVC.swift
//  Baseet App
//
//  Created by VinodKatta on 25/07/22.
//

import UIKit

class OrderSucessViewVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "OrderOntheWayVC") as! OrderOntheWayVC
//        vc.modalTransitionStyle = .coverVertical
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)

        // Do any additional setup after loading the view.
    }
    
 
    
    @IBAction func backbtn(_ sender: Any) {
        //self.dismiss(animated: true,completion: nil)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "OrderOntheWayVC") as! OrderOntheWayVC
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "OrderOntheWayVC") as! OrderOntheWayVC
//        vc.modalTransitionStyle = .coverVertical
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
    }
    

}
