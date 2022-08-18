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
}

extension CartViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartViewControllerVM.getCartFoodData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartTableViewCell
        cell.CartTableViewCellVM = self.cartViewControllerVM.getCartTableViewCellVM(index: indexPath.row)
        return cell
    }
}
