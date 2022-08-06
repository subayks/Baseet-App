//
//  AddOnTableViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 18/07/22.
//

import UIKit

class AddOnTableViewCell: UITableViewCell {

    @IBOutlet weak var addOnView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adOnImage: UIImageView!
    @IBOutlet weak var QuantityCount: UILabel!
    var itemCount = 1

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
        self.titleLabel.text = self.addOnTableViewCellVM?.addOn?.name
        self.QuantityCount.text = "\(itemCount)"
    }

    @IBAction func actionReduce(_ sender: Any) {
        if itemCount > 1 {
        itemCount = itemCount - 1
        self.QuantityCount.text = "\(itemCount)"
        }
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        itemCount = itemCount + 1
        self.QuantityCount.text = "\(itemCount)"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
