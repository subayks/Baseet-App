//
//  MapkitViewVC.swift
//  Baseet App
//
//  Created by VinodKatta on 26/07/22.
//

import UIKit

class MapkitViewVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func DoneBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "DeliveredSucessViewVC") as! DeliveredSucessViewVC
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    

}
