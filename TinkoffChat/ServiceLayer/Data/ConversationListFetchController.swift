import Foundation
import UIKit
import CoreData

class ConversationListFetchController : NSObject {
    
    fileprivate let conversationCell = "conversationCell"
    
    fileprivate let tableView: UITableView
    fileprivate let fetchedResultsController: NSFetchedResultsController<Conversation>
    fileprivate let frcDelegate: FRCDelegate

    
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        self.frcDelegate = FRCDelegate(tableView: tableView)
        
        let fetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:#keyPath(Conversation.conversationId), ascending: false)]
        
        let context = CoreDataStack.sharedCoreDataStack.mainContext
        
        self.fetchedResultsController = NSFetchedResultsController<Conversation>(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: #keyPath(Conversation.isOnline), cacheName: nil)
        
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.fetchedResultsController.delegate = frcDelegate
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
    }
}

extension ConversationListFetchController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard  let sectionsCount = fetchedResultsController.sections?.count else { return 0 }
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(inSection: section)
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { fatalError("Unexpected Section") }
        if (sectionInfo.name == "0") {
            return "Offline"
        } else {
            return "Online"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:conversationCell, for:indexPath) as! ContactTableViewCell
        let conversation = fetchedResultsController.object(at: indexPath)
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        cell.nameLabel.text = conversation.conversationId
        
        if conversation.isOnline == true {
            cell.backgroundColor = UIColor(red: 102/255, green: 255/255, blue: 204/255, alpha: 0.3)
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        if conversation.lastMessageText != nil {
            cell.dateLabel?.text =  dateFormatter.string(from: (conversation.lastMessageDate)!)
            cell.messageLabel.text = conversation.lastMessageText

        } else {
            cell.dateLabel?.isHidden = true
            cell.messageLabel.text = "no messages yet"
        }
        
        return cell
    }
    
}
