//
//  MyFavoritesViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 13/07/22.
//

import UIKit

class MyFavoritesViewController: UIViewController {

    @IBOutlet weak var myFevTB: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    
    @IBAction func myFevBack(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
}

extension MyFavoritesViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyFevTableViewCell
        return cell
    }
    
    
    
    
    
}
