//
//  ViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 07/07/22.
//

import UIKit

class LoginViewController: UIViewController

{

    @IBOutlet weak var numberTF: UITextField!{
        didSet{
            numberTF.leftImage(UIImage(named: "rightMark"), imageWidth: 10, padding: 20)
            
            
            
        }
    }
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
       
       
        
    }
    
    @IBAction func continueActn(_ sender: Any)
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "OtpViewController") as! OtpViewController
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
}


extension UITextField {
    func leftImage(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: imageWidth, height: frame.height)
        imageView.contentMode = .center
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 2 * padding, height: frame.height))
        containerView.addSubview(imageView)
        rightView = containerView
        rightViewMode = .always
    }
}
