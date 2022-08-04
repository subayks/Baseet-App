//
//  OrderOntheWayVC.swift
//  Baseet App
//
//  Created by VinodKatta on 15/07/22.
//

import UIKit

class OrderOntheWayVC: UIViewController {
    
    @IBOutlet weak var orderTB: UITableView!
    
   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
     }
    

    
   
    
    @IBAction func trackOrderBtn(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MapkitViewVC") as! MapkitViewVC
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    

   

}

extension OrderOntheWayVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderOnTableViewCell
        return cell
    }
    
    
    
    
}
