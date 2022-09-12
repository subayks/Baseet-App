//
//  RestFoodPickTableViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 18/07/22.
//

import UIKit

class RestFoodPickTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countOverView: UIView!
    
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
        self.itemImage.layer.cornerRadius = 15
        self.countOverView.layer.cornerRadius = 5
        self.countOverView.layer.borderWidth = 1
        self.countOverView.layer.borderColor = UIColor(red: 172/255, green: 37/255, blue: 23/255, alpha: 1).cgColor
        self.itemName.text = self.RestFoodPickTableViewCellVM?.foodItems?.name
        self.itemCount.text = self.RestFoodPickTableViewCellVM?.foodItems?.foodQty
        self.itemCountValue = Int(self.RestFoodPickTableViewCellVM?.foodItems?.foodQty ?? "") ?? 0
        let itemPrice = self.RestFoodPickTableViewCellVM?.foodItems?.tprice ?? 0 - (Int(self.RestFoodPickTableViewCellVM?.foodItems?.discount ?? "") ?? 0)
        self.qrCodeLabel.text = "QR \(itemPrice)"
        self.itemImage.loadImageUsingURL(self.RestFoodPickTableViewCellVM?.foodItems?.appimage)
    }

    @IBAction func reduceQuantity(_ sender: Any) {
        if self.itemCountValue >= 0 {
            self.itemCountValue = self.itemCountValue - 1
        //    self.itemCount.text = "\(self.itemCountValue)"
            self.itemAdded?(self.itemCountValue, buttonAdd.tag)
        }
    }
    
    @IBAction func addQuantity(_ sender: Any) {
        self.itemCountValue = self.itemCountValue  + 1
      //  self.itemCount.text = "\(self.itemCountValue)"
        self.itemAdded?(self.itemCountValue, buttonAdd.tag)
    }
    
    
}
