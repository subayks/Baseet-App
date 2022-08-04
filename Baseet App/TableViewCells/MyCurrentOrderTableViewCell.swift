//
//  MyCurrentOrderTableViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 15/07/22.
//

import UIKit

class MyCurrentOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderDetailsBtn: UIButton!
    @IBOutlet weak var modifyOrderBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
