//
//  CartTableViewCell.swift
//  Baseet App
//
//  Created by VinodKatta on 11/07/22.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartLbl: UILabel!
    @IBOutlet weak var percentLbl: UILabel!
    @IBOutlet weak var moneyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    

}
