//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Vasily on 25.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var textFieldBottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var sendButtonBottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    
    var contactManager: ContactManager!
    var conversationFetchController: ConversationFetchController?

    
    var conversationId: String {
        get {
            return contactManager.activeContactName!
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleName()
        
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        messagesTableView.estimatedRowHeight = 44
        messagesTableView.separatorStyle = .none
        
        conversationFetchController = ConversationFetchController(with: messagesTableView, identifier: conversationId)
        
        sendMessageButton.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(ConversationViewController.keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ConversationViewController.keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let info = notification.userInfo, let keyboardFrame = info [UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let frame = keyboardFrame.cgRectValue
            textFieldBottomConstrain.constant = frame.size.height + 1.0
            sendButtonBottomConstrain.constant = frame.size.height + 1.0
            UIView.animate(withDuration: 0.8) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        textFieldBottomConstrain.constant = 40
        sendButtonBottomConstrain.constant = 40
        
        UIView.animate(withDuration: 0.8) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func messageTextFieldChanged(_ sender: UITextField) {
        if (messageTextField.text != "") {
            
            if !sendMessageButton.isEnabled {
                let transform = sendMessageButton.transform
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .transitionFlipFromTop, animations: {
                    self.sendMessageButton.transform = CGAffineTransform.init(scaleX: 1.15, y: 1.15)
                    
                }) { (success: Bool) in
                    if success {
                        
                        UIView.animate(withDuration: 0.5, animations: {
                            
                            self.sendMessageButton.transform = transform
                        })
                    }
                }
            }
            
            sendMessageButton.isEnabled = true
            
        } else {
            sendMessageButton.isEnabled = false
        }
    }
    
    @IBAction func sendMessageAction(_ sender: UIButton) {
        
        contactManager.send(message: messageTextField.text!, to: conversationId)
        messageTextField.text = ""
        sendMessageButton.isEnabled = false
    }
    
    
    fileprivate func changeTitleColorAnimation(with color: UIColor) {
        let lablel = self.navigationItem.titleView as! UILabel
        UIView.transition(with: lablel, duration: 1, options: .transitionCrossDissolve, animations: { lablel.textColor = color }, completion: nil)
    }
    
    fileprivate func setTitleName() {
        let titleLabel = UILabel()
        titleLabel.text = conversationId
        self.navigationItem.titleView = titleLabel
        self.navigationItem.titleView?.sizeToFit()
    }
    
}

extension ConversationViewController: ContactManagerDelegate {
    
    func becomeOnline() {
        print("online")
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1) {
                self.navigationItem.titleView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            
            self.changeTitleColorAnimation(with: UIColor(red: 0/255, green: 128/255, blue: 64/255, alpha: 1))
        }
    }
    
    func becomeOffline() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, animations: {
                self.navigationItem.titleView?.transform = CGAffineTransform.identity
            })
            
            self.changeTitleColorAnimation(with: UIColor.black)
        }
    }
}


