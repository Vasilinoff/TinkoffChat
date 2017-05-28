//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Vasily on 24.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import UIKit
class ConversationsListViewController: AnimationViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    var conversationListFetchController: ConversationListFetchController?
    
    let serviceManager = CommunicatorManager()
    
    private var sectionHeaderTitles = ["Online", "History"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        serviceManager.dataService.makeConversationsOffline()
        
        conversationListFetchController = ConversationListFetchController(with: tableView)
    }

    //MARK: готовимся к сиге
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendDataSegue" {
            if let controller = segue.destination as? ConversationViewController {
                let path = tableView.indexPathForSelectedRow
                controller.contactManager = serviceManager as ContactManager
                serviceManager.activeContactDelegate = controller
                
                let cell = tableView.cellForRow(at: path!) as! ContactTableViewCell
                let name = cell.nameLabel.text
                
                serviceManager.activeContactName = name                
            }
        }
    }
}



