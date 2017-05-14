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
        
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        messagesTableView.estimatedRowHeight = 44
        messagesTableView.separatorStyle = .none
        
        conversationFetchController = ConversationFetchController(with: messagesTableView, identifier: conversationId)
        
        //sendMessageButton.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(ConversationViewController.keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ConversationViewController.keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        self.title = conversationId
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
            sendMessageButton.isEnabled = true
        } else {
            sendMessageButton.isEnabled = false
        }
    }
    
    @IBAction func sendMessageAction(_ sender: UIButton) {
        
        
        contactManager.send(message: messageTextField.text!, to: conversationId)
        messageTextField.text = ""
        sendMessageButton.isEnabled = false
        DispatchQueue.main.async {
            self.messagesTableView.reloadData()
        }
    }


}

extension ConversationViewController: ContactManagerDelegate {
    func didRecieve(message: String) {
        DispatchQueue.main.async {
            self.messagesTableView.reloadData()
        }
    }
    func becomeOnline() {
        sendMessageButton.isEnabled = true
        DispatchQueue.main.async {
            self.messagesTableView.reloadData()
        }
    }
    func becomeOffline() {
        sendMessageButton.isEnabled = false
        DispatchQueue.main.async {
            self.messagesTableView.reloadData()
        }
    }
}
