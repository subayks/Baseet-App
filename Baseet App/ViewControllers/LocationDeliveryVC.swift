//
//  LocationDeliveryVC.swift
//  Baseet App
//
//  Created by VinodKatta on 25/07/22.
//

import UIKit

class LocationDeliveryVC: UIViewController {

    @IBOutlet weak var cashimage: UIImageView!
    var menu_vcOrder: OrderSucessViewVC!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cashimage.isUserInteractionEnabled = true
        cashimage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @IBAction func payNow(_ sender: Any)
    {
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "OrderSucessViewVC") as! OrderSucessViewVC
//
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
        menu_vcOrder = self.storyboard?.instantiateViewController(withIdentifier: "OrderSucessViewVC") as? OrderSucessViewVC
       
               let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
               let vc = storyboard.instantiateViewController(identifier: "OrderSucessViewVC") as! OrderSucessViewVC
               vc.modalTransitionStyle = .coverVertical
               vc.modalPresentationStyle = .fullScreen
               self.present(vc, animated: true, completion: nil)
        
        
        
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
