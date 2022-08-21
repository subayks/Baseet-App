//
//  RestarentDishViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 15/07/22.
//

import UIKit

class RestarentDishViewController: UIViewController {
    
    @IBOutlet weak var cartCountBadge: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reatingStackView: UIStackView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    
    @IBOutlet weak var buttonGoToCart: UIButton!
    @IBOutlet weak var restaurantAddress: UILabel!
    var menu_vc1: RecipeDetailsVC!
    
    @IBOutlet weak var resDishCV: UICollectionView!
    
    @IBOutlet weak var resDishTB: UICollectionView!
    
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    var restarentDishViewControllerVM: RestarentDishViewControllerVM?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        menu_vc1 = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsVC") as? RecipeDetailsVC
        setupValues()

        self.restarentDishViewControllerVM?.setUpItemsList()
        //        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        //        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        //        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        //        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        //        self.view.addGestureRecognizer(swipeLeft)
        //        self.view.addGestureRecognizer(swipeRight)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.buttonGoToCart.layer.cornerRadius = buttonGoToCart.frame.height/2
        self.buttonGoToCart.clipsToBounds = true
        buttonGoToCart.layer.borderWidth = 2
        buttonGoToCart.layer.borderColor = UIColor.gray.cgColor
        
        self.cartCountBadge.layer.cornerRadius = cartCountBadge.frame.height/2
        self.cartCountBadge.clipsToBounds = true
        
        self.restarentDishViewControllerVM?.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.restarentDishViewControllerVM?.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.restarentDishViewControllerVM?.navigateToDetailsClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "RecipeDetailsVC") as! RecipeDetailsVC
             //   vc.recipeDetailsVCVM = self.restarentDishViewControllerVM?.getRecipeDetailsVCVM(index: <#Int#>)
                vc.itemAdded  = { (itemCount, index, addOns) in
                    DispatchQueue.main.async {
                //        self.restarentDishViewControllerVM?.updateValues(itemCount: itemCount, index: index, addOns: addOns)
                        self.restarentDishViewControllerVM?.decideFlow(itemCount: itemCount, index: index, addOns: addOns)
                    }
                }
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        self.restarentDishViewControllerVM?.reloadRecipieCollectionView = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.resDishTB.reloadData()
                self.checkForCartButton()
            }
        }
        
        self.restarentDishViewControllerVM?.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.restarentDishViewControllerVM?.navigateToCartViewClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "RestaurentFoodPicksVC") as! RestaurentFoodPicksVC
                vc.restaurentFoodPicksVCVM = self.restarentDishViewControllerVM?.getRestaurentFoodPicksVCVM()
                vc.changedValues  = { (itemCount, index) in
                    DispatchQueue.main.async {
                        self.restarentDishViewControllerVM?.updateCurrentCount(itemId: itemCount, itemCount: index)
                    }
                }
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func checkForCartButton() {
        let showButton = self.restarentDishViewControllerVM?.isItemAvailable()
        self.buttonGoToCart.isHidden = !showButton!
        self.cartCountBadge.isHidden = !showButton!
        if showButton == false {
            self.collectionViewBottomConstraint.constant = 66
        } else {
            let cartCount = "\(self.restarentDishViewControllerVM?.getCartModel?.data?.count ?? 0)"
            self.cartCountBadge.setTitle(cartCount, for: .normal)
            self.collectionViewBottomConstraint.constant = 130
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func actionGoToBasket(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RestaurentFoodPicksVC") as! RestaurentFoodPicksVC
        vc.restaurentFoodPicksVCVM = self.restarentDishViewControllerVM?.getRestaurentFoodPicksVCVM()
        vc.changedValues  = { (itemCount, index) in
            DispatchQueue.main.async {
                self.restarentDishViewControllerVM?.updateCurrentCount(itemId: itemCount, itemCount: index)
            }
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func setupValues() {
        let startTime = self.restarentDishViewControllerVM?.shopDetailsModel?.restaurant?.availableTimeStarts ?? ""
        let closingTime = self.restarentDishViewControllerVM?.shopDetailsModel?.restaurant?.availableTimeEnds ?? ""
        
        let dateAsString = closingTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "h:mm a"
        let formattedClosingDate = dateFormatter.string(from: date!)
        
        self.timingLabel.text = "Timing \(startTime) AM to \(formattedClosingDate)"
        self.logoImage.loadImageUsingURL(self.restarentDishViewControllerVM?.shopDetailsModel?.restaurant?.applogo ?? "")
        self.restaurantName.text = self.restarentDishViewControllerVM?.shopDetailsModel?.restaurant?.name
        self.restaurantAddress.text = self.restarentDishViewControllerVM?.shopDetailsModel?.restaurant?.address
        self.buttonGoToCart.isHidden  = true
        self.cartCountBadge.isHidden = true
        let ratingCount = self.restarentDishViewControllerVM?.shopDetailsModel?.restaurant?.avgRating ?? 0
        if ratingCount > 0  {
            self.ratingLabel.text = "Rating"
            for i in 0..<ratingCount {
            let imageStar = UIImageView()
            imageStar.image = UIImage(systemName: "star.fill")
            imageStar.tintColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
            self.reatingStackView.addArrangedSubview(imageStar)
        }
        } else {
            self.ratingLabel.text = ""
        }
    }
}

extension RestarentDishViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.resDishCV {
            return 8
        }
        return self.restarentDishViewControllerVM?.foodItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.resDishCV {
            let cellA = resDishCV.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ResDishCollectionViewCell
            return cellA
        } else {
            let cellC = resDishTB.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ResDishCollectionViewCellTwo
            cellC.buttonAdd.layer.cornerRadius = 10
            cellC.resDishCollectionViewCellTwoVM = self.restarentDishViewControllerVM?.getResDishCollectionViewCellTwoVM(index: indexPath.row)
            cellC.buttonAdd.tag = indexPath.row
            cellC.itemAdded  = { (itemCount, index) in
                DispatchQueue.main.async {
                   // self.restarentDishViewControllerVM?.updateValues(itemCount: itemCount, index: index)
                  self.restarentDishViewControllerVM?.decideFlow(itemCount: itemCount, index: index)
                }
            }
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
       // self.restarentDishViewControllerVM?.makeProductDetailsCall(item: indexPath.row)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RecipeDetailsVC") as! RecipeDetailsVC
        vc.recipeDetailsVCVM = self.restarentDishViewControllerVM?.getRecipeDetailsVCVM(index: indexPath.row)
        vc.itemAdded  = { (itemCount, index, addOns) in
            DispatchQueue.main.async {
            //    self.restarentDishViewControllerVM?.updateValues(itemCount: itemCount, index: index, addOns: addOns)
                self.restarentDishViewControllerVM?.decideFlow(itemCount: itemCount, index: index, addOns: addOns)
            }
        }
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((resDishTB.contentOffset.y + resDishTB.frame.size.height) >= resDishTB.contentSize.height)
        {
            DispatchQueue.main.async {
                 self.restarentDishViewControllerVM?.makeLoadMore()
            }
        }
    }
}


