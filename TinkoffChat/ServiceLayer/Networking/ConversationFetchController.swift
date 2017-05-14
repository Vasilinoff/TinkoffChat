import Foundation
import UIKit
import CoreData

class ConversationFetchController : NSObject, NSFetchedResultsControllerDelegate {
    
    fileprivate let receivedCellId = "received"
    fileprivate let sendedCellId = "sended"
    fileprivate let headerTitles = ["Online", "History"]
    
    fileprivate let tableView: UITableView
    fileprivate let fetchResultsController: NSFetchedResultsController<Message>
    
    init(with tableView: UITableView, identifier: String) {
        self.tableView = tableView
        let context = CoreDataStack.sharedCoreDataStack.mainContext!
        
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequestMessage(context: context, conversationId: identifier)!
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:#keyPath(Message.date), ascending: false)]
        
        
        self.fetchResultsController = NSFetchedResultsController<Message>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.fetchResultsController.delegate = self
        
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
    }
    
    //MARK: -
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            deleteRowsInTableAtIndexPath(indexPath)
        case .insert:
            insetRowsInTableAtIndexPath(newIndexPath)
        case .move:
            deleteRowsInTableAtIndexPath(indexPath)
            insetRowsInTableAtIndexPath(newIndexPath)
        case .update:
            reloadRowsInTableAtIndexPath(indexPath)
        }
    }
    
    fileprivate func deleteRowsInTableAtIndexPath(_ indexPath: IndexPath?) {
        if let indexPath = indexPath {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    fileprivate func insetRowsInTableAtIndexPath(_ indexPath: IndexPath?) {
        if let indexPath = indexPath {
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    fileprivate func reloadRowsInTableAtIndexPath(_ indexPath: IndexPath?) {
        if let indexPath = indexPath {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: 		NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
}

extension ConversationFetchController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard  let sectionsCount = fetchResultsController.sections?.count else { return 0 }
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(inSection: section)
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        guard let sections = fetchResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = fetchResultsController.object(at: indexPath)
        
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
