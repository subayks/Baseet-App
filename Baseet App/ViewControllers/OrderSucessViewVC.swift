//
//  OrderSucessViewVC.swift
//  Baseet App
//
//  Created by VinodKatta on 25/07/22.
//

import UIKit

class OrderSucessViewVC: UIViewController {
    var orderSucessViewVCVM: OrderSucessViewVCVM?
    
    @IBOutlet weak var orderPlacedLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "OrderOntheWayVC") as! OrderOntheWayVC
//        vc.modalTransitionStyle = .coverVertical
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)

        // Do any additional setup after loading the view.
        let orderId = self.orderSucessViewVCVM?.orderId ?? "12345"
        let stringOne = "ORDER \(orderId) PLACED SUCESSSFULLY"
        let stringTwo = "\(orderId)"

        let range = (stringOne as NSString).range(of: stringTwo)

        let attributedText = NSMutableAttributedString.init(string: stringOne)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        self.orderPlacedLabel.attributedText = attributedText
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
