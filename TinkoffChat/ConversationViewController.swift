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
    
    var messages = [Message]()
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(Message(text: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", received: true))
        messages.append(Message(text: "text two text two text two text two text two text two text two text two text two text two text two", received: false))
        messages.append(Message(text: "text three", received: true))
        messages.append(Message(text: "text 4", received: false))
        messages.append(Message(text: "text 5", received: true))
        messages.append(Message(text: "text 6", received: false))
        
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        messagesTableView.estimatedRowHeight = 44
        
        self.title = name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if messages[indexPath.row].received {
            let cell = messagesTableView.dequeueReusableCell(withIdentifier: "received", for: indexPath) as! MessageCell
            cell.textOfMessage.text = messages[indexPath.row].text
            
            return cell
        } else {
            let cell = messagesTableView.dequeueReusableCell(withIdentifier: "sended", for: indexPath) as! MessageCell
            
            cell.textOfMessage.text = messages[indexPath.row].text
            return cell
        }
        
        
    }
    
    
}
