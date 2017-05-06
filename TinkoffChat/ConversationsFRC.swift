////
////  FRCManager.swift
////  TinkoffChat
////
////  Created by Vasily on 04.05.17.
////  Copyright © 2017 Vasily. All rights reserved.
////
//
//import Foundation
//import CoreData
//import UIKit
//
//class FetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate {
//
//    private let tableView: UITableView
//    
//    init(withTableView tableView: UITableView) {
//        self.tableView = tableView
//    }
//    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            guard let indexPath = newIndexPath else { return }
//            tableView.insertRows(at: [indexPath], with: .automatic)
//        case .delete:
//            guard let indexPath = indexPath else { return }
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        case .update, .move:
//            guard let indexPath = indexPath else { return }
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//            
//        }
//    }
//}
//
//class ConversationsFRC: NSFetchedResultsController<NSFetchRequestResult>  {
//    private let tableView: UITableView
//    let fetchControllerDelegate: FetchedResultsControllerDelegate
//    
//    init(managedObjectContext: NSManagedObjectContext, withDelegate delegate: FetchedResultsControllerDelegate) {
//        
//        self.delegate = fetchControllerDelegate
//        
//        super.init(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath:nil, cacheName: nil)
//    
//        tryFetch()
//    }
//    
//    
//    func tryFetch() {
//        do {
//            try performFetch()
//        } catch {
//            print(error)
//        }
//    }
//}
