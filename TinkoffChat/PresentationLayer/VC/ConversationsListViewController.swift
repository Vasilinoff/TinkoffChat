//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Vasily on 24.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import UIKit
class ConversationsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    
    let serviceManager = CommunicatorManager()
    
    var conversations: [ConversationCellConfiguration] {
        get {
            return serviceManager.transportContacts
        }
    }
    //MARK: Фильтр для онлайн
    var conversationsOnline: [ConversationCellConfiguration] {
        get {
            return conversations.filter({ $0.online })
        }
    }
    //MARK: Фильтр для офлайн
    var conversationsOffline: [ConversationCellConfiguration] {
        get {
            return conversations.filter({ (!$0.online)  })
        }
    }
    
    private var sectionHeaderTitles = ["Online", "History"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serviceManager.contactsDelegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }

    //MARK: функции для протокола
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 ? conversationsOnline : conversationsOffline).count
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

        let contact = (indexPath.section == 0 ? conversationsOnline : conversationsOffline)[indexPath.row]
        contactCell.nameLabel.text = contact.name
        
        if contact.lastMessageText != nil {
            contactCell.dateLabel?.isHidden = false
            contactCell.dateLabel?.text = dateFormatter.string(from: (contact.lastMessageDate)!)
        } else {
            contactCell.messageLabel?.text = "No messages yet"
            contactCell.dateLabel?.isHidden = true
        }
        if contact.online {
            contactCell.backgroundColor = UIColor(red: 243/255, green: 232/255, blue: 234/255, alpha: 1.0)
        } else {
            contactCell.backgroundColor = UIColor.white
        }
        
        if let message = contact.lastMessageText {
            contactCell.messageLabel.text = message        }

        if contact.hasUnreadedMessages {
            contactCell.messageLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        } else {
            contactCell.messageLabel.font = UIFont.systemFont(ofSize: 16.0)
        }

        contactCell.detailTextLabel?.text = contact.lastMessageText
        
        return contactCell
    }
    //MARK: готовимся к сиге
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendDataSegue" {
            if let controller = segue.destination as? ConversationViewController {
                let path = tableView.indexPathForSelectedRow
                controller.contactManager = serviceManager as ContactManager
                
                let cell = tableView.cellForRow(at: path!) as! ContactTableViewCell
                let name = cell.nameLabel.text
                
                serviceManager.activeContactName = name
                serviceManager.activeContactDelegate = controller
            }
        }
    }
}

extension ConversationsListViewController: ContactsDelegate {
    func contactListUpdated() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
