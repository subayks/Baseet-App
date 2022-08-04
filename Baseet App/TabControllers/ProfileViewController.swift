//
//  ProfileViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 08/07/22.
//

import UIKit

class ProfileViewController: UIViewController {
    var logOut_vc: LogoutVC!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        logOut_vc = self.storyboard?.instantiateViewController(withIdentifier: "LogoutVC") as? LogoutVC
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.gray, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 5.0)

        
    }
    


    
    func show_menu(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "LogoutVC") as! LogoutVC
        vc.modalTransitionStyle = .crossDissolve
       // vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func logoutpopViewBtn(_ sender: Any) {
        show_menu()
    }
}
