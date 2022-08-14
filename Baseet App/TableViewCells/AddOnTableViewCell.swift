//
//  AddOnTableViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 18/07/22.
//

import UIKit

class AddOnTableViewCell: UITableViewCell {

    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var addOnView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adOnImage: UIImageView!
    @IBOutlet weak var QuantityCount: UILabel!
    var itemCount = 1
    var itemAdded:((Int, Int)->())?

    var addOnTableViewCellVM: AddOnTableViewCellVM? {
        didSet {
        self.setupValues()
        }
    }
    
    var itemCountClosure:((String)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupValues() {
        self.addOnView.layer.borderWidth = 1
        self.addOnView.layer.borderColor = UIColor.white.cgColor
        self.addOnView.layer.cornerRadius = 15
        self.adOnImage.loadImageUsingURL("")
        self.titleLabel.text = self.addOnTableViewCellVM?.addOn?.name
        self.QuantityCount.text = "\(self.addOnTableViewCellVM?.addOn?.itemQuantity ?? 0)"
        self.itemCount = self.addOnTableViewCellVM?.addOn?.itemQuantity ?? 0
        self.labelPrice.text = "QR \(self.addOnTableViewCellVM?.addOn?.price ?? 0)"
    }

    @IBAction func actionReduce(_ sender: Any) {
        if self.itemCount == 1 {
            itemCount = self.itemCount - 1
            self.QuantityCount.text = "\(self.itemCount)"
        } else {
            if itemCount > 0 {
            self.itemCount = self.itemCount - 1
            self.QuantityCount.text = "\(self.itemCount)"
            }
        }
        self.itemAdded?(self.itemCount, buttonAdd.tag)
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        itemCount = itemCount + 1
        self.QuantityCount.text = "\(itemCount)"
        self.itemAdded?(self.itemCount, buttonAdd.tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
