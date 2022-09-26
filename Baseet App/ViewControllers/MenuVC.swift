//
//  menuVC.swift
//  Baseet App
//
//  Created by VinodKatta on 09/07/22.
//

import UIKit

class MenuVC: UIViewController {
    
    @IBOutlet weak var contactIcon: UIImageView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var phonenumberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var menuTb: UITableView!
    var menuVM = MenuVM()
    
    let sidenameArray = ["Home","My Orders","My Places","My Favorites","My Wallet","Invite Friend","Notifications","Settings","Contact Us","Join Us","LogOut"]
    
    let sidenameArrayUnauth = ["Home","Invite Friend","Join Us","Contact Us","Login"]
    
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
    
    let imageArrayUnauth = [
    UIImage(named: "home_icon"),
    UIImage(named: "conntect"),
    UIImage(named: "conntect"),
    UIImage(named: "pointloc"),
    UIImage(named: "conntect")]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.menuVM.reloadClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.menuTb.reloadData()
                self.setupNavigationBar()
            }
        }
        
        self.menuVM.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.menuVM.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.menuVM.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    func setupNavigationBar() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            self.profileIcon.isHidden = true
            self.nameLabel.isHidden = true
            self.phonenumberLabel.isHidden = true
            self.contactIcon.isHidden = true
            self.bgImage.image = UIImage(named: "Baseet_Banner")
            self.bgImage.contentMode = .center
        } else {
            self.profileIcon.isHidden = false
            self.nameLabel.isHidden = false
            self.contactIcon.isHidden = false
            self.phonenumberLabel.isHidden = false
            self.nameLabel.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
            self.phonenumberLabel.text = UserDefaults.standard.string(forKey: "PhoneNumber")
            self.profileIcon.loadImageUsingURL(UserDefaults.standard.string(forKey: "ProfileImage"))
            self.bgImage.image = UIImage(named: "bg")
            self.bgImage.contentMode = .scaleToFill
        }
    }

}

extension MenuVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            return sidenameArrayUnauth.count

        } else {
        return sidenameArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            cell.menuName.text = sidenameArrayUnauth[indexPath.row]
            cell.menuImage.image = imageArrayUnauth[indexPath.row]
        } else {
        cell.menuName.text = sidenameArray[indexPath.row]
        cell.menuImage.image = imageArray[indexPath.row]
        }
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            if indexPath.row == 0
            {
                let vc = self.storyboard?.instantiateViewController(identifier: "tabVC")
                vc!.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: true, completion: nil)
            }
            
            if indexPath.row == 1  {
                let vc = self.storyboard?.instantiateViewController(identifier: "InviteFriendsViewController") as! InviteFriendsViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                }
            if indexPath.row == 2
            {
             let vc = self.storyboard?.instantiateViewController(identifier: "ContactUsViewController") as! ContactUsViewController
             vc.modalPresentationStyle = .fullScreen
             self.present(vc, animated: true, completion: nil)
            }
            
            if indexPath.row == 3
            {
             let vc = self.storyboard?.instantiateViewController(identifier: "JoinUsViewController") as! JoinUsViewController
             vc.modalPresentationStyle = .fullScreen
             self.present(vc, animated: true, completion: nil)
            }
            if indexPath.row == 4
            {
             let vc = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
             vc.modalPresentationStyle = .fullScreen
                vc.navigationClosure =  { [weak self] in
                    DispatchQueue.main.async {
                        self?.menuVM.getCustomerInfo()
                    }
                }
             self.present(vc, animated: true, completion: nil)
            }
        } else {
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
               
                let vc = self.storyboard?.instantiateViewController(identifier: "SettingsViewController") as! SettingsViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
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
     
    
}
