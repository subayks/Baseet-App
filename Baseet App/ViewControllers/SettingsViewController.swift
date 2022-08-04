//
//  SettingsViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 11/07/22.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTB: UITableView!
    
    let settingnamesArray = ["Edit Profile","Security","Notifications","Change Location"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func settingsBackBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    

}

extension SettingsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingnamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableViewCell
        
        cell.settinglbl.text = settingnamesArray[indexPath.row]
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0
        {
            let vc = self.storyboard?.instantiateViewController(identifier: "EditProfileViewController") as! EditProfileViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath.row == 1{

//            let vc = self.storyboard?.instantiateViewController(identifier:  "MyOrderVC") as! MyOrderVC
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
        }
        if indexPath.row == 2{

            let vc = self.storyboard?.instantiateViewController(identifier: "EditNotificationVC") as! EditNotificationVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath.row == 3{

//            let vc = self.storyboard?.instantiateViewController(identifier: "MyFavoritesViewController") as! MyFavoritesViewController
//           vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    
}
