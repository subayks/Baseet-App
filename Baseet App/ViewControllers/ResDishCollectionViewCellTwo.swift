//
//  ResDishCollectionViewCellTwo.swift
//  Baseet App
//
//  Created by VinodKatta on 15/07/22.
//

import UIKit

class ResDishCollectionViewCellTwo: UICollectionViewCell {
    
    @IBOutlet weak var buttonVegOrNV: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var qrCodeLabel: UILabel!
    var itemAdded:((Int, Int,Bool)->())?
    var resDishCollectionViewCellTwoVM: ResDishCollectionViewCellTwoVM? {
        didSet {
            self.setupValues()
        }
    }
    var itemCount = 0
    
    func setupValues() {
        self.itemImage.layer.cornerRadius = 10
        self.itemImage.loadImageUsingURL(self.resDishCollectionViewCellTwoVM?.foodItems?.appimage)
        self.itemName.text = self.resDishCollectionViewCellTwoVM?.foodItems?.name
       
        if self.resDishCollectionViewCellTwoVM?.foodItems?.itemQuantity == 0 ||  self.resDishCollectionViewCellTwoVM?.foodItems?.itemQuantity == nil {
            self.buttonAdd.isHidden = false
            self.countView.isHidden = true
        } else {
            self.itemCountLabel.text = "\(self.resDishCollectionViewCellTwoVM?.getItemQuantity() ?? 0)"
            self.buttonAdd.isHidden = true
            self.countView.isHidden = false
        }
        
        if self.resDishCollectionViewCellTwoVM?.foodItems?.qty == nil ||
            ((self.resDishCollectionViewCellTwoVM?.foodItems?.qty ?? "") as NSString).integerValue  == 0 {
            self.buttonAdd.isHidden = false
            self.countView.isHidden = true
            self.buttonAdd.isEnabled = false
        } else {
            self.buttonAdd.isEnabled = true
        }
        self.itemCount = self.resDishCollectionViewCellTwoVM?.getItemQuantity() ?? 0
        self.ratingLabel.text = "⭑ \(self.resDishCollectionViewCellTwoVM?.foodItems?.avgRating ?? 0)"
        self.qrCodeLabel.text = "QR \(self.resDishCollectionViewCellTwoVM?.foodItems?.price ?? 0)"
        if self.resDishCollectionViewCellTwoVM?.foodItems?.veg == 1 {
            self.buttonVegOrNV.setImage(UIImage(named: "Veg"), for: .normal)
        } else {
            self.buttonVegOrNV.setImage(UIImage(named: "Non-Veg"), for: .normal)
        }
    }
    
    @IBAction func actionAdd(_ sender: Any) {
      //  self.buttonAdd.isHidden = true
      //  self.countView.isHidden = false
        if itemCount == 0 {
            self.itemCount = 1
        }
        self.itemAdded?(itemCount, buttonAdd.tag, true)
    }
    
    @IBAction func actionIncrease(_ sender: Any) {
        self.itemCount = self.itemCount  + 1
    //    self.itemCountLabel.text = "\(self.itemCount)"
        self.itemAdded?(self.itemCount, buttonAdd.tag, true)
    }
    
    @IBAction func actionReduce(_ sender: Any) {
        if self.itemCount == 1 {
            itemCount = self.itemCount - 1
            self.buttonAdd.isHidden = false
            self.countView.isHidden = true
        } else {
            self.itemCount = self.itemCount - 1
        //    self.itemCountLabel.text = "\(self.itemCount)"
        }
        self.itemAdded?(self.itemCount, buttonAdd.tag, false)
    }
    
}
