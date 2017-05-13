//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Vasily on 25.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var textFieldBottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var sendButtonBottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    var contactManager: ContactManager!
    
    var conversationId: String? {
        get {
            return contactManager.activeContact?.name
        }
    }
    
    
    var messages: [MessageCellConfiguration] {
        get {
            return contactManager.activeContactMessages!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: заполняем сообщения
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        messagesTableView.estimatedRowHeight = 44
        messagesTableView.separatorStyle = .none
        
        sendMessageButton.isEnabled = false
        
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
        contactManager.send(message: messageTextField.text!)
        messageTextField.text = ""
        sendMessageButton.isEnabled = false
        DispatchQueue.main.async {
            self.messagesTableView.reloadData()
        }
    }
    
    //MARK: соответствуем протоколу
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: MessageCell
        if messages[indexPath.row].received {
            cell = messagesTableView.dequeueReusableCell(withIdentifier: "received", for: indexPath) as! MessageCell
        } else {
            cell = messagesTableView.dequeueReusableCell(withIdentifier: "sended", for: indexPath) as! MessageCell
        }
        
        cell.textOfMessage.text = messages[indexPath.row].text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        cell.dateOfMessage?.text = dateFormatter.string(from: (messages[indexPath.row].date))
        
        return cell
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
