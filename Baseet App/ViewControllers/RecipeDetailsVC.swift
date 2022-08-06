//
//  RecipeDetailsVC.swift
//  Baseet App
//
//  Created by VinodKatta on 23/07/22.
//

import UIKit

class RecipeDetailsVC: UIViewController {

    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var addOnLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var commentsTextView: UITextView!
    var recipeDetailsVCVM: RecipeDetailsVCVM?
    var itemCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(RecipeDetailsVC.tapFunction))
        addOnLbl.isUserInteractionEnabled = true
        addOnLbl.addGestureRecognizer(tap)
        self.setupValues()
    }
    
    @objc
        func tapFunction(sender:UITapGestureRecognizer) {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "AddOnViewController") as! AddOnViewController
            vc.addOnViewControllerVM = self.recipeDetailsVCVM?.getAddOnViewControllerVM()
            vc.modalTransitionStyle  = .crossDissolve
           // vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    
    
    @IBAction func buttonAddItem(_ sender: Any) {
        itemCount = itemCount + 1
        self.labelCount.text = "\(itemCount)"
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func actionReduceItem(_ sender: Any) {
        if itemCount > 1 {
        itemCount = itemCount - 1
        self.labelCount.text = "\(itemCount)"
        }
    }
    
    @IBAction func addToBasketBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RestaurentFoodPicksVC") as! RestaurentFoodPicksVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func setupValues() {
        self.productImage.loadImageUsingURL(self.recipeDetailsVCVM?.proDuctDetailsModel?.appimage ?? "")
        self.productName.text = self.recipeDetailsVCVM?.proDuctDetailsModel?.name ?? ""
        self.discriptionLabel.text = self.recipeDetailsVCVM?.proDuctDetailsModel?.description ?? ""
        self.labelCount.text = "\(itemCount)"
    }
}
