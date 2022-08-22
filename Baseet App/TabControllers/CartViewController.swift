//
//  CartViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 08/07/22.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var cartTB: UITableView!
    var cartViewControllerVM = CartViewControllerVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.gray, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 5.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.cartViewControllerVM.getCartCall()
        
        self.cartViewControllerVM.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.cartViewControllerVM.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.cartViewControllerVM.reloadRecipieCollectionView = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.cartTB.reloadData()
            }
        }
        
        self.cartViewControllerVM.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension CartViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartViewControllerVM.getCartModel?.data?.count == 0 ? 1:  (cartViewControllerVM.getCartModel?.data?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cartViewControllerVM.getCartModel?.data?.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCartCell", for: indexPath) as! EmptyCartCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartTableViewCell
            cell.CartTableViewCellVM = self.cartViewControllerVM.getCartTableViewCellVM(index: indexPath.row)
            return cell
        }
    }
}
