//
//  PayWithVC.swift
//  Baseet App
//
//  Created by VinodKatta on 25/07/22.
//

import UIKit

class PayWithVC: UIViewController {
    
    var paymentType:((PaymentType)->())?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backbtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func actionDebitCard(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
        self.paymentType?(.card)
    }
    
    @IBAction func actionCash(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
        self.paymentType?(.cash)
    }
    
    @IBAction func addBtnn(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddCardViewController") as! AddCardViewController
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
