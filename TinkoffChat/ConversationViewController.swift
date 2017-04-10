//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Vasily on 25.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import UIKit
var messages = [Message]()

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: заполняем сообщения
        //fillMessageModel()
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        messagesTableView.estimatedRowHeight = 44
        
        self.title = name
    }
    
    //MARK: соответствуем протоколу
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
