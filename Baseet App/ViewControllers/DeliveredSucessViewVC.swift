//
//  DeliveredSucessViewVC.swift
//  Baseet App
//
//  Created by VinodKatta on 26/07/22.
//

import UIKit

class DeliveredSucessViewVC: UIViewController {
    
    @IBOutlet weak var foodItemsList: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    var deliveredSucessViewVM: DeliveredSucessViewVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.orderPrice.text = "Paid \(self.deliveredSucessViewVM?.orderTrackModel?.orderAmount ?? 0) QR"
        self.foodItemsList.text = self.deliveredSucessViewVM?.getFoodItemsList()
        let delay : Double = 5.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "tabVC")
            vc.modalPresentationStyle = .fullScreen
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "tabVC")
        vc.modalPresentationStyle = .fullScreen
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
        
        //        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(identifier: "FeedbackViewController") as! FeedbackViewController
        //
        //        vc.modalPresentationStyle = .fullScreen
        //        self.present(vc, animated: true, completion: nil)
    }
    
}


