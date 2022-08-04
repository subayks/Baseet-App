//
//  OtpViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 08/07/22.
//

import UIKit

class OtpViewController: UIViewController,UITextFieldDelegate

{

    @IBOutlet weak var timeBtn: UIButton!
    
    var timer = 30
       {
        didSet
            {
                timeBtn.setTitle(" RESEND IN \(String(timer)) S", for: .normal)
            }
        }
    
    @IBOutlet weak var TF1: UITextField!
    @IBOutlet weak var TF2: UITextField!
    @IBOutlet weak var TF3: UITextField!
    @IBOutlet weak var TF4: UITextField!
    
    var myTimer = Timer()
    
    var timerCount:Timer!
    var secondsToCount = 30
    
    override func viewDidLoad()
    {
        timerCount = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
//        timerCount = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer1), userInfo: nil, repeats: true)
        
//        myTimer.invalidate()
//        myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        super.viewDidLoad()
        TF1.addBottomBorder()
        TF2.addBottomBorder()
        TF3.addBottomBorder()
        TF4.addBottomBorder()
        
        
                TF1.delegate = self
                TF2.delegate = self
                TF3.delegate = self
                TF4.delegate = self

    }
    
    @objc func updateTimer()
  {
      if self.timer > 0 {
           self.timer -= 1
       }
       else
       if self.timer == 0 {
           self.timer = 30
           timeBtn.setTitle("SEND AGAIN \(String(secondsToCount))", for: .normal)
          
           timerCount.invalidate()
       }
    }
    
    
    
  
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if ((textField.text?.count)! < 1 ) && (string.count > 0) {
                if textField == TF1 {
                    TF2.becomeFirstResponder()
                }
                
                if textField == TF2 {
                    TF3.becomeFirstResponder()
                }
                
                if textField == TF3 {
                    TF4.becomeFirstResponder()
                }
                
                if textField == TF4 {
                    TF4.resignFirstResponder()
                }
                
                textField.text = string
                return false
            } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
                if textField == TF2 {
                    TF1.becomeFirstResponder()
                }
                if textField == TF3 {
                    TF2.becomeFirstResponder()
                }
                if textField == TF4 {
                    TF3.becomeFirstResponder()
                }
                if textField == TF1 {
                    TF1.resignFirstResponder()
                }
                
                textField.text = ""
                return false
            } else if (textField.text?.count)! >= 1 {
                textField.text = string
                return false
            }
            
            return true
        }
    
    
    @IBAction func continueOtpActn(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "tabVC") 
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
