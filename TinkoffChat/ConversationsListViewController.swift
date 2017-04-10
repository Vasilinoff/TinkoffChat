//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Vasily on 24.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import UIKit
var contacts = [Contact]()
class ConversationsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    
    let serviceManager = MultipeerCommunicator()
    
    //MARK: Фильтр для онлайн
    var contactsOnline: [Contact] {
        get {
            return contacts.filter({ $0.online })
        }
    }
    //MARK: Фильтр для офлайн
    var contactsOffline: [Contact] {
        get {
            return contacts.filter({ (!$0.online)&&($0.message != nil)  })
        }
    }
    
    
    
    private var sectionHeaderTitles = ["Online", "History"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serviceManager.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        
        //MARK: Добавление контактов
        
        //fillContactModel()
    }
    
    //MARK: функции для протокола
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 ? contactsOnline : contactsOffline).count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaderTitles[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactCell = self.tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"


        let contact = (indexPath.section == 0 ? contactsOnline : contactsOffline)[indexPath.row]
        contactCell.nameLabel.text = contact.name
        contactCell.dateLabel.text = dateFormatter.string(from: contact.date!)
        
        if contact.online {
            contactCell.backgroundColor = UIColor(red: 243/255, green: 232/255, blue: 234/255, alpha: 1.0)
        } else {
            contactCell.backgroundColor = UIColor.white
        }
        
        if let message = contact.message {
            contactCell.messageLabel.text = message
        } else {
            contactCell.messageLabel.text = "No messages yet"
            contactCell.messageLabel.font = UIFont.italicSystemFont(ofSize: 16.0)
            contactCell.dateLabel.text = nil
            
        }
        
        if contact.hasUnreadedMessages {
            contactCell.messageLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        } else {
            contactCell.messageLabel.font = UIFont.systemFont(ofSize: 16.0)
        }
        
        
        contactCell.detailTextLabel?.text = contact.message
        
        return contactCell
    }
    //MARK: готовимся к сиге
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendDataSegue" {
            if let destination = segue.destination as? ConversationViewController {
                let path = tableView.indexPathForSelectedRow
                let cell = tableView.cellForRow(at: path!) as! ContactTableViewCell
                destination.name = cell.nameLabel.text
            }
        }
    }

    
}

extension ConversationsListViewController: CommunicatorDelegate {
    
    func didFoundUser(userID: String, userName: String?) {
        let contact = Contact.init(name: userID, message: nil, date: Date(), online: true, hasUnreadedMessages: false)
        contacts.append(contact)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didLostUser(userID: String) {
        contacts = contacts.filter({ $0.name != userID  })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
    
    }
    
    func failedToStartAdvertising(error: Error) {
    
    }
    
    func didRecievedMessage(text: String, fromUser: String, toUser: String) {
    
    }
}
