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
    }
    
    @IBAction func backBtn(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "FeedbackViewController") as! FeedbackViewController
        vc.feedbackViewModel = self.deliveredSucessViewVM?.getFeedbackViewModel()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}


