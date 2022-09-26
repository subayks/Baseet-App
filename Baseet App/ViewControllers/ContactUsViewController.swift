//
//  ContactUsViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 11/07/22.
//

import UIKit

class ContactUsViewController: UIViewController {

    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
    }
    
    func setupNavigationBar() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            self.profileIcon.isHidden = true
            self.nameLabel.isHidden = true
        } else {
            self.profileIcon.isHidden = false
            self.nameLabel.isHidden = false
            self.nameLabel.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
        }
    }

    @IBAction func contactBackBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    

}
