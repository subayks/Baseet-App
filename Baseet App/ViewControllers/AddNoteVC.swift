//
//  AddNoteVC.swift
//  Baseet App
//
//  Created by VinodKatta on 17/07/22.
//

import UIKit
import AVFoundation
import CoreData

class AddNoteVC: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var personIMage: UIImageView!
    @IBOutlet weak var notesTextView: UITextView!
    var notes:((String, String)->())?
    @IBOutlet weak var playButton: UIButton!
    var soundPlayer:AVAudioPlayer?

    var soundRecorder:AVAudioRecorder?
var filename = "audio.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let disMissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(disMissKeyboardTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
               
    }
    
    func isPermissonGranted() ->Bool{
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            return true
        case .denied:
            return false
        case .undetermined:
            print("Request permission here")
            var isGranted = Bool()
            AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                // Handle granted
                isGranted = granted
            })
            if isGranted {
                return true
            } else {
                return false
            }
        @unknown default:
            return false
        }
    }
    
    @IBAction func buttonPlay(_ sender: UIButton) {
        self.recordButton.isEnabled = false
        preparePlayer()
        soundPlayer?.play()
    }
    
    func preparePlayer() {
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: self.getFinalURL() as URL)
            soundPlayer?.delegate = self
            soundPlayer?.prepareToPlay()
            soundPlayer?.volume = 1

           } catch {
              
           }
    }
    
    @IBAction func buttonPause(_ sender: Any) {
        soundPlayer?.stop()
        }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func actionClose(_ sender: Any) {
    }
    
    @IBAction func actionRecord(_ sender: UIButton) {
        if self.isPermissonGranted() {
        if sender.titleLabel?.text == "Record" {
            soundRecorder?.record()
            sender.setTitle("Stop", for: .normal)
            self.playButton.isEnabled = false
            self.pauseButton.isEnabled = false
        } else {
            soundRecorder?.stop()
            sender.setTitle("Record", for: .normal)
            self.playButton.isEnabled = true
            self.pauseButton.isEnabled = true
        }
        }
    }
    
    @IBAction func actionDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.notes?(self.notesTextView.text, "")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y  = 0
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func setupRecorder() {
        let recordSettings =  [AVFormatIDKey: kAudioFormatAppleLossless, AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue, AVEncoderBitRateKey: 320000, AVNumberOfChannelsKey: 2, AVSampleRateKey: 44100.0 ]
        as [String : Any]
      //  var error: NSError?
        do {
            soundRecorder = try AVAudioRecorder(url: self.getFinalURL() as URL, settings: recordSettings as [String: Any])
            
            soundRecorder?.delegate = self
            soundRecorder?.prepareToRecord()
           } catch {
              //hanldle error
           }
       
    }
    
    func getCacheDirect() ->String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        return path[0]
    }
    
    
    func getFinalURL() ->NSURL {
        let path = (self.getCacheDirect() as NSString).appendingPathComponent(filename)
        let filePath = NSURL(fileURLWithPath: path)
        return filePath
    }
}

extension AddNoteVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension AddNoteVC:  AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    // Microphone Access
        func checkMicrophoneAccess() {
            // Check Microphone Authorization
           
        }
    
    fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
        return input.rawValue
    }

    // Helper function inserted by Swift migrator.
    fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
    
    // completion of recording
       func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
           if flag {
               
               self.playButton.isEnabled = true
               
           }
       }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            
        self.recordButton.isEnabled = true
            
        }
}

