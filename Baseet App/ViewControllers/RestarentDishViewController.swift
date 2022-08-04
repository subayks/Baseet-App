//
//  RestarentDishViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 15/07/22.
//

import UIKit

class RestarentDishViewController: UIViewController {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    
    @IBOutlet weak var restaurantAddress: UILabel!
    var menu_vc1: RecipeDetailsVC!

    @IBOutlet weak var resDishCV: UICollectionView!
    
    @IBOutlet weak var resDishTB: UICollectionView!
    
    var restarentDishViewControllerVM: RestarentDishViewControllerVM?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        menu_vc1 = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsVC") as? RecipeDetailsVC
        setupValues()
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
//        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
//        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
//        self.view.addGestureRecognizer(swipeLeft)
//        self.view.addGestureRecognizer(swipeRight)

        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    func setupValues() {
        self.logoImage.loadImageUsingURL(self.restarentDishViewControllerVM?.shopDetailsModel?.applogo ?? "")
        self.restaurantName.text = self.restarentDishViewControllerVM?.shopDetailsModel?.name
        self.restaurantAddress.text = self.restarentDishViewControllerVM?.shopDetailsModel?.address

    }

}

extension RestarentDishViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
 {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.resDishCV
           {
               return 8
           }
       
            return 8
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        
        
        
        if collectionView == self.resDishCV
        {
            
            let cellA = resDishCV.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ResDishCollectionViewCell
            
            

                
                return cellA
        }
        
        else  
        {
            let cellC = resDishTB.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ResDishCollectionViewCellTwo
            
            
                return cellC
        }

           
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//           let padding: CGFloat =  50
//           let collectionViewSize = collectionView.frame.size.width - padding
//
//           return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
//       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth

        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RecipeDetailsVC") as! RecipeDetailsVC
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
}


