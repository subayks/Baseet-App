//
//  AddOnViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 18/07/22.
//

import UIKit

class AddOnViewController: UIViewController {

    
    @IBOutlet weak var addonTB: UITableView!
    var addOnViewControllerVM: AddOnViewControllerVM?
    var itemAdded:((Int, Int)->())?
    var addOns:(([AddOns])->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
   
    @IBAction func backBtn(_ sender: Any) {
        self.addOns?(self.addOnViewControllerVM?.addOns ?? [AddOns()])
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        self.addOns?(self.addOnViewControllerVM?.addOns ?? [AddOns()])
        self.dismiss(animated: true,completion: nil)
    }
    
}

extension AddOnViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addOnViewControllerVM?.addOns?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddOnTableViewCell
        cell.addOnView.layer.borderColor = UIColor.white.cgColor
        cell.addOnView.layer.borderWidth = 2
        cell.buttonAdd.tag = indexPath.row
        cell.itemAdded  = { (itemCount, index) in
            DispatchQueue.main.async {
                self.addOnViewControllerVM?.updateValues(itemCount: itemCount, index: index)
            }
        }
        cell.addOnTableViewCellVM = self.addOnViewControllerVM?.getAddOnTableViewCellVM(index: indexPath.row)
    
        return cell
    }
    
    
    
    
}
