//
//  NotificationsViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 12/07/22.
//

import UIKit

class NotificationsViewController: UIViewController
{

    @IBOutlet weak var NotificationTB: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
    }
    

    @IBAction func notificationBackBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    

}

extension NotificationsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    
    
}
