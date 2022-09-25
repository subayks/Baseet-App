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

        let orderId = self.orderSucessViewVCVM?.orderId ?? "12345"
        let stringOne = "ORDER \(orderId) PLACED SUCESSSFULLY"
        let stringTwo = "\(orderId)"

        let range = (stringOne as NSString).range(of: stringTwo)

        let attributedText = NSMutableAttributedString.init(string: stringOne)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        self.orderPlacedLabel.attributedText = attributedText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.orderSucessViewVCVM?.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.orderSucessViewVCVM?.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.orderSucessViewVCVM?.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.orderSucessViewVCVM?.navigationClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
               // self.dismiss(animated: true, completion: {
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "OrderOntheWayVC") as! OrderOntheWayVC
                    vc.modalTransitionStyle = .coverVertical
                    vc.modalPresentationStyle = .fullScreen
                    vc.orderOntheWayVM = self.orderSucessViewVCVM?.getOrderOntheWayVM()
                    self.present(vc, animated: true, completion: nil)
              //  })
            }
        }
    }
    
    @IBAction func backbtn(_ sender: Any) {
        self.orderSucessViewVCVM?.getOrderTrack()
    }
}
