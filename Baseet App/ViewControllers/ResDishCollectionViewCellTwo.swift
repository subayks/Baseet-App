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
    var itemCount = 1
    @IBOutlet weak var countView: UIView!
    var itemAdded:((Bool)->())?

    @IBAction func actionAdd(_ sender: Any) {
        self.buttonAdd.isHidden = true
        self.countView.isHidden = false
        self.itemAdded?(true)
    }
    
    @IBAction func actionIncrease(_ sender: Any) {
        itemCount = itemCount + 1
        self.itemCountLabel.text = "\(itemCount)"
    }
    
    @IBAction func actionReduce(_ sender: Any) {
        if itemCount == 1 {
        itemCount = 1
            self.itemAdded?(false)
            self.buttonAdd.isHidden = false
            self.countView.isHidden = true
        } else {
            itemCount = itemCount - 1
            self.itemCountLabel.text = "\(itemCount)"
        }
    }
    
}
