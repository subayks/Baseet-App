//
//  MyWalletViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 12/07/22.
//

import UIKit

class MyWalletViewController: UIViewController {
    
    var card_VC: MyWalletViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        card_VC = self.storyboard?.instantiateViewController(withIdentifier: "MyWalletViewController") as! MyWalletViewController
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
        

        // Do any additional setup after loading the view.
    }
    
    func show_menu(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddCardViewController") as! AddCardViewController
        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
   
    
    func close_menu()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCardBtn(_ sender: Any)
    {
        show_menu()
    }
    
    @objc func respondToGesture(gesture: UISwipeGestureRecognizer)
    {
        switch gesture.direction
        {
        case UISwipeGestureRecognizer.Direction.right:
            show_menu()
        case UISwipeGestureRecognizer.Direction.left:
            close_menu()
        default:
            break
        }
    }
    
    @IBAction func myWalletBackBtn(_ sender: Any) {
        
        self.dismiss(animated: true,completion: nil)
    }
    

}

extension UIImageView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}
