//
//  FoodItemTableViewCell.swift
//  Baseet App
//
//  Created by Subendran on 22/09/22.
//

import UIKit

class FoodItemTableViewCell: UITableViewCell {

    @IBOutlet weak var foodItemCollectionView: UICollectionView!
    var itemId:((Int)->())?

    var foodItemTableViewCellVM: FoodItemTableViewCellVM? {
        didSet {
            self.foodItemCollectionView.reloadData()
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

}

extension FoodItemTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.foodItemTableViewCellVM?.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cellC = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ResDishCollectionViewCellTwo
            cellC.buttonAdd.layer.cornerRadius = 10
            cellC.resDishCollectionViewCellTwoVM = self.foodItemTableViewCellVM?.getResDishCollectionViewCellTwoVM(index: indexPath.row)
            cellC.buttonAdd.tag = indexPath.row
//            cellC.itemAdded  = { (itemCount, index) in
//                DispatchQueue.main.async {
//                   // self.restarentDishViewControllerVM?.updateValues(itemCount: itemCount, index: index)
//                  self.restarentDishViewControllerVM?.decideFlow(itemCount: itemCount, index: index)
//                }
//            }
            return cellC
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/2.0

        return CGSize(width: yourWidth, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = self.foodItemTableViewCellVM?.products?[indexPath.row].restaurantId ?? 0
        self.itemId?(id)
    }
}
