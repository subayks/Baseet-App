//
//  MyPlacesViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 13/07/22.
//

import UIKit

class MyPlacesViewController: UIViewController {
    
    @IBOutlet weak var myPlacesTB: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
    }
    
    @IBAction func myPlacesBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
   

}

extension MyPlacesViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyPlacesTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
    
    
    
}
