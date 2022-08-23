//
//  HomeCollectionViewDownCell.swift
//  Baseet App
//
//  Created by VinodKatta on 23/07/22.
//

import UIKit

class HomeCollectionViewDownCell: UICollectionViewCell {
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var hotelLogo: UIImageView!
    @IBOutlet weak var salonName: UILabel!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var offerDesc: UILabel!
    
    var homeCollectionViewDownCellVM: HomeCollectionViewDownCellVM? {
        didSet {
            self.setupValues()
        }
    }
    
    func setupValues() {
        self.bannerImage.layer.cornerRadius = 10
        self.hotelLogo.layer.cornerRadius = 10

        self.bannerImage.loadImageUsingURL(self.homeCollectionViewDownCellVM?.restaurantsModel?.appcoverlogo ?? "")
        self.hotelLogo.loadImageUsingURL(self.homeCollectionViewDownCellVM?.restaurantsModel?.applogo ?? "")
        
        self.salonName.text = self.homeCollectionViewDownCellVM?.restaurantsModel?.name
        //self.distanceButton.setTitle((self.homeCollectionViewDownCellVM?.restaurantsModel?.distance ?? ""), for: .normal)
        self.distanceButton.titleLabel?.numberOfLines = 1
        self.ratingButton.setTitle(String(self.homeCollectionViewDownCellVM?.restaurantsModel?.avgRating ?? 0), for: .normal)

//        if (self.homeCollectionViewDownCellVM?.restaurantsModel?.avgRating ?? 0) > 0 {
//            self.ratingButton.isHidden = false
//            self.ratingButton.setTitle(String(self.homeCollectionViewDownCellVM?.restaurantsModel?.avgRating ?? 0), for: .normal)
//        } else {
//            self.ratingButton.isHidden = true
//        }
    }
}
