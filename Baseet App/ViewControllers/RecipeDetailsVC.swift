//
//  RecipeDetailsVC.swift
//  Baseet App
//
//  Created by VinodKatta on 23/07/22.
//

import UIKit

class RecipeDetailsVC: UIViewController {

    @IBOutlet weak var quantityOverView: UIView!
    @IBOutlet weak var pricingLabel: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var addOnLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var detailsScrollView: UIScrollView!

    var recipeDetailsVCVM: RecipeDetailsVCVM?
    var itemCount = 1
    var itemAdded:((Int, Int, [AddOns])->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(RecipeDetailsVC.tapFunction))
        addOnLbl.isUserInteractionEnabled = true
        addOnLbl.addGestureRecognizer(tap)
        self.setupValues()
        let disMissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(disMissKeyboardTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if self.recipeDetailsVCVM?.proDuctDetailsModel?.addOns == nil || self.recipeDetailsVCVM?.proDuctDetailsModel?.addOns?.count == 0 {
            self.addOnLbl.isHidden = true
        } else {
            self.addOnLbl.isHidden = false
        }
    }
    
    @objc
        func tapFunction(sender:UITapGestureRecognizer) {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "AddOnViewController") as! AddOnViewController
            vc.addOnViewControllerVM = self.recipeDetailsVCVM?.getAddOnViewControllerVM()
            vc.addOns  = { (addOns) in
                DispatchQueue.main.async {
                    self.recipeDetailsVCVM?.updateAdons(addOns: addOns)
                }
            }
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
        self.itemAdded?(itemCount, self.recipeDetailsVCVM?.index ?? 0, self.recipeDetailsVCVM?.setupAdons() ?? [AddOns()])
        self.dismiss(animated: true,completion: nil)
    }
    
    func setupValues() {
        self.quantityOverView.layer.borderWidth = 1
        self.commentsTextView.text = "Add your Comment Here"
        self.quantityOverView.layer.borderColor = UIColor(red: 172/255, green: 37/255, blue: 23/255, alpha: 1).cgColor
    
        self.productImage.loadImageUsingURL(self.recipeDetailsVCVM?.proDuctDetailsModel?.appimage ?? "")
        self.productName.text = self.recipeDetailsVCVM?.proDuctDetailsModel?.name ?? ""
        self.discriptionLabel.text = self.recipeDetailsVCVM?.proDuctDetailsModel?.description ?? ""
        self.labelCount.text = "\(self.recipeDetailsVCVM?.proDuctDetailsModel?.itemQuantity ?? 0)"
        self.itemCount = self.recipeDetailsVCVM?.proDuctDetailsModel?.itemQuantity ?? 0
        self.pricingLabel.text = "QR \(self.recipeDetailsVCVM?.proDuctDetailsModel?.price ?? 0)"
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y  = 0
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

extension RecipeDetailsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
