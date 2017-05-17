import Foundation
import UIKit
import CoreData

class ConversationFetchController: NSObject {
    
    fileprivate let receivedCellId = "received"
    fileprivate let sendedCellId = "sended"
    
    fileprivate let tableView: UITableView
    fileprivate let fetchedResultsController: NSFetchedResultsController<Message>
    
    fileprivate let frcDelegate: FRCDelegate
    
    init(with tableView: UITableView, identifier: String) {
        self.tableView = tableView
        let context = CoreDataStack.sharedCoreDataStack.mainContext!
        self.frcDelegate = FRCDelegate(tableView: tableView)
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequestMessage(context: context, conversationId: identifier)!
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:#keyPath(Message.date), ascending: true)]
        
        
        self.fetchedResultsController = NSFetchedResultsController<Message>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
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

extension ConversationFetchController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = fetchedResultsController.object(at: indexPath)
        
        var cell: MessageCell
        if message.received {
            cell = tableView.dequeueReusableCell(withIdentifier: receivedCellId, for: indexPath) as! MessageCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: sendedCellId, for: indexPath) as! MessageCell
        }
        
        cell.textOfMessage.text = message.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        cell.dateOfMessage?.text = dateFormatter.string(from: (message.date))
        
        return cell
    }
}
