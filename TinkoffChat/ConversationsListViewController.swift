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
    
    var contacts = [Contact]()
    
    var contactsOnline: [Contact] {
        get {
            return contacts.filter({ $0.online })
        }
    }

    var contactsOffline: [Contact] {
        get {
            return contacts.filter({ (!$0.online)&&($0.message != nil)  })
        }
    }
    
    
    
    private var sectionHeaderTitles = ["Online", "History"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        contacts.append(Contact(name: "first", message: nil, date: Date.init(), online: true, hasUnreadedMessages: false))
        contacts.append(Contact(name: "second", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init(), online: false, hasUnreadedMessages: true))
         contacts.append(Contact(name: "six", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: true, hasUnreadedMessages: false))
         contacts.append(Contact(name: "six", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: true, hasUnreadedMessages: true))
         contacts.append(Contact(name: "six", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: true, hasUnreadedMessages: false))
         contacts.append(Contact(name: "six", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: true, hasUnreadedMessages: true))
         contacts.append(Contact(name: "six", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: true, hasUnreadedMessages: false))
         contacts.append(Contact(name: "six", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: true, hasUnreadedMessages: false))
         contacts.append(Contact(name: "six", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: true, hasUnreadedMessages: false))
         contacts.append(Contact(name: "six", message: nil, date: Date.init() , online: true, hasUnreadedMessages: false))
        contacts.append(Contact(name: "third", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: false, hasUnreadedMessages: false))
        contacts.append(Contact(name: "third", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: false, hasUnreadedMessages: false))
        contacts.append(Contact(name: "third", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: false, hasUnreadedMessages: false))
        contacts.append(Contact(name: "third", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: false, hasUnreadedMessages: false))
        contacts.append(Contact(name: "third", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: false, hasUnreadedMessages: false))
        contacts.append(Contact(name: "chetiri", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: false, hasUnreadedMessages: true))
        contacts.append(Contact(name: "five", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: false, hasUnreadedMessages: false))
        contacts.append(Contact(name: "six", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: true, hasUnreadedMessages: false))
        contacts.append(Contact(name: "seven", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: false, hasUnreadedMessages: true))
        contacts.append(Contact(name: "nine", message: nil, date: Date.init() , online: false, hasUnreadedMessages: true))
        contacts.append(Contact(name: "ten", message: nil, date: Date.init(), online: false, hasUnreadedMessages: true))
        contacts.append(Contact(name: "eleven", message: "first messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst messagefirst message", date: Date.init() , online: false, hasUnreadedMessages: true))
        
    }
    
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
        dateFormatter.dateFormat = "hh:mm:ss"


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
