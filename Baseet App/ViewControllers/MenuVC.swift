//
//  menuVC.swift
//  Baseet App
//
//  Created by VinodKatta on 09/07/22.
//

import UIKit

class MenuVC: UIViewController {
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var phonenumberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var menuTb: UITableView!
    
    let sidenameArray = ["Home","My Orders","My Places","My Favorites","My Wallet","Invite Friend","Notifications","Settings","Contact Us","Join Us","LogOut"]
    
    let imageArray = [
    UIImage(named: "home_icon"),
    UIImage(named: "order"),
    UIImage(named: "my_places"),
    UIImage(named: "my_fovarites"),
    UIImage(named: "my_wallet"),
    UIImage(named: "conntect"),
    UIImage(named: "notifications"),
    UIImage(named: "settings_1"),
    UIImage(named: "pointloc"),
    UIImage(named: "conntect"),
    UIImage(named: "conntect")]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
    }
    

    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    func setupNavigationBar() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            self.profileIcon.isHidden = true
            self.nameLabel.isHidden = true
            self.phonenumberLabel.isHidden = true
        } else {
            self.profileIcon.isHidden = false
            self.nameLabel.isHidden = false
            self.nameLabel.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
            self.phonenumberLabel.text = UserDefaults.standard.string(forKey: "PhoneNumber")
            self.profileIcon.loadImageUsingURL(UserDefaults.standard.string(forKey: "ProfileImage"))
        }
    }

}

extension MenuVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sidenameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        cell.menuName.text = sidenameArray[indexPath.row]
        cell.menuImage.image = imageArray[indexPath.row]
        
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
        if indexPath.row == 0
        {
            let vc = self.storyboard?.instantiateViewController(identifier: "tabVC")
            vc!.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: true, completion: nil)
        }
        if indexPath.row == 1{

            let vc = self.storyboard?.instantiateViewController(identifier:  "MyOrderVC") as! MyOrderVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath.row == 2{

            let vc = self.storyboard?.instantiateViewController(identifier: "MyPlacesViewController") as! MyPlacesViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath.row == 3{

            let vc = self.storyboard?.instantiateViewController(identifier: "MyFavoritesViewController") as! MyFavoritesViewController
           vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        if indexPath.row == 4
        {
         let vc = self.storyboard?.instantiateViewController(identifier: "MyWalletViewController") as! MyWalletViewController
         vc.modalPresentationStyle = .fullScreen
         self.present(vc, animated: true, completion: nil)
        }

        if indexPath.row == 5
        {
        let vc = self.storyboard?.instantiateViewController(identifier: "InviteFriendsViewController") as! InviteFriendsViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        }
        
        if indexPath.row == 6
        {
         let vc = self.storyboard?.instantiateViewController(identifier: "NotificationsViewController") as! NotificationsViewController
         vc.modalPresentationStyle = .fullScreen
         self.present(vc, animated: true, completion: nil)
        }
        
          
        if indexPath.row == 7
        {
            if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
                let alert = UIAlertController(title: "Alert", message: "Please Login", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let vc = self.storyboard?.instantiateViewController(identifier: "SettingsViewController") as! SettingsViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        
        if indexPath.row == 8
        {
         let vc = self.storyboard?.instantiateViewController(identifier: "ContactUsViewController") as! ContactUsViewController
         vc.modalPresentationStyle = .fullScreen
         self.present(vc, animated: true, completion: nil)
        }
        
        if indexPath.row == 9
        {
         let vc = self.storyboard?.instantiateViewController(identifier: "JoinUsViewController") as! JoinUsViewController
         vc.modalPresentationStyle = .fullScreen
         self.present(vc, animated: true, completion: nil)
        }
        if indexPath.row == 10
        {
         let vc = self.storyboard?.instantiateViewController(identifier: "LogoutVC") as! LogoutVC
         vc.modalPresentationStyle = .fullScreen
         self.present(vc, animated: true, completion: nil)
        }
    }
     
    
}
