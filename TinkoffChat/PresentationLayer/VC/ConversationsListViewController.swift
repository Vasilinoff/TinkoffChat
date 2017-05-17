//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Vasily on 24.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import UIKit
class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    var conversationListFetchController: ConversationListFetchController?
    
    let serviceManager = CommunicatorManager()
    
    private var sectionHeaderTitles = ["Online", "History"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serviceManager.contactsDelegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        conversationListFetchController = ConversationListFetchController(with: tableView)
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
                //serviceManager.activeConversation = cell.conversation
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
