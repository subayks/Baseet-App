//
//  SearchViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 08/07/22.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchCV: UICollectionView!
    
    @IBOutlet weak var popularResCV: UICollectionView!
    
    let searchNamesArray = ["Biryani","Mandi","Pizza","Burger","Sawarma","Rumali","pasta","Rumali","Rumali"]
    
    let searchimageArray = [
    UIImage(named: "1"),
    UIImage(named: "2"),
    UIImage(named: "3"),
    UIImage(named: "4"),
    UIImage(named: "5"),
    UIImage(named: "6"),
    UIImage(named: "7"),
    UIImage(named: "8"),
    UIImage(named: "9"),
    UIImage(named: "10"),
    UIImage(named: "11")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCV.reloadData()

        
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.gray, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 5.0)
    }

}

extension SearchViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.searchCV
           {
               return 7
           }

           return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        
        
        
        if collectionView == self.searchCV {
            let cellA = searchCV.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
            
            cellA.itemLbl.text = searchNamesArray[indexPath.row]

                // ...Set up cell
                return cellA
            }

            else {
                let cellB = popularResCV.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PopularResCollectionViewCell

                cellB.restpopularImage.image = searchimageArray[indexPath.row]

                return cellB
            }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            let xPadding = 10
//            let spacing = 10
//            let rightPadding = 10
//            let width = (CGFloat(UIScreen.main.bounds.size.width) - CGFloat(xPadding + spacing + rightPadding))/4
//            let height = CGFloat(215)
//
//            return CGSize(width: width, height: height)
//        }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//           return 10
//       }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let noOfCellsInRow = 4
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            let size = Int((popularResCV.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            return CGSize(width: size, height: 130)

    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//           let padding: CGFloat =  50
//           let collectionViewSize = collectionView.frame.size.width - padding
//
//           return CGSize(width: collectionViewSize/4, height: collectionViewSize/2)
//       }
}
