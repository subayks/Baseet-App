//
//  LogoutVC.swift
//  Baseet App
//
//  Created by VinodKatta on 13/07/22.
//

import UIKit

class LogoutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    
    @IBAction func Logout(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
}
