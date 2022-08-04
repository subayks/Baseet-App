//
//  RecipeDetailsVC.swift
//  Baseet App
//
//  Created by VinodKatta on 23/07/22.
//

import UIKit

class RecipeDetailsVC: UIViewController {

    @IBOutlet weak var addOnLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(RecipeDetailsVC.tapFunction))
        addOnLbl.isUserInteractionEnabled = true
        addOnLbl.addGestureRecognizer(tap)
    }
    
    
    @objc
        func tapFunction(sender:UITapGestureRecognizer) {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "AddOnViewController") as! AddOnViewController
            vc.modalTransitionStyle  = .crossDissolve
           // vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    
    

    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func addToBasketBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RestaurentFoodPicksVC") as! RestaurentFoodPicksVC
       
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
}
