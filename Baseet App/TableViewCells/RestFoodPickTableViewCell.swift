//
//  RestFoodPickTableViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 18/07/22.
//

import UIKit

class RestFoodPickTableViewCell: UITableViewCell {
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var qrCodeLabel: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    var itemAdded:((Int, Int)->())?
    var itemCountValue = 0

    var RestFoodPickTableViewCellVM: RestFoodPickTableViewCellVM? {
        didSet {
            self.setupValues()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupValues() {
        self.itemName.text = self.RestFoodPickTableViewCellVM?.foodItems?.name
        self.itemCount.text = "\(self.RestFoodPickTableViewCellVM?.foodItems?.itemQuantity ?? 0)"
        self.itemCountValue = self.RestFoodPickTableViewCellVM?.foodItems?.itemQuantity ?? 0
        self.qrCodeLabel.text = "Empty"
        self.itemImage.loadImageUsingURL(self.RestFoodPickTableViewCellVM?.foodItems?.appimage)
    }

    @IBAction func reduceQuantity(_ sender: Any) {
        if self.itemCountValue > 1 {
            self.itemCountValue = self.itemCountValue - 1
            self.itemCount.text = "\(self.itemCountValue)"
        }
    }
    
    @IBAction func addQuantity(_ sender: Any) {
        self.itemCountValue = self.itemCountValue  + 1
        self.itemCount.text = "\(self.itemCountValue)"
        self.itemAdded?(self.itemCountValue, buttonAdd.tag)
    }
    
    
}
