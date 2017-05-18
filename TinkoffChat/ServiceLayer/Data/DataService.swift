//
//  AppUserDataService.swift
//  TinkoffChat
//
//  Created by Vasily on 10.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataService {
    fileprivate let coreDataStack = CoreDataStack.sharedCoreDataStack
    
    fileprivate func insert<T>(in context: NSManagedObjectContext, entityName: String) -> T? {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T
    }
    
    fileprivate func findOrCreate<T> (in context: NSManagedObjectContext, request: NSFetchRequest<T>, entityName: String) -> T? {
        var value: T?
        
        do {
            let results = try context.fetch(request)
            if let foundValue = results.first {
                value = foundValue
            }
        }
        catch {
            print("Failed to fetch")
        }
        
        if value == nil {
            value = insert(in: context, entityName: entityName)
        }
        
        return value
    }
    
    func findOrCreateConversation(conversationId: String) -> Conversation? {
        if let context = coreDataStack.saveContext {
            let request = Conversation.fetchRequestConversation(model: (context.persistentStoreCoordinator?.managedObjectModel)!, identifier: conversationId)!
            let conversation = findOrCreate(in: context, request: request, entityName: "Conversation")
            conversation?.conversationId = conversationId
            
            return conversation
            
        }
        
        return nil
    }
    
    func saveFoundedConversation(conversationId: String) {
        if let context = coreDataStack.saveContext {
            let conversation = findOrCreateConversation(conversationId: conversationId)
            let user = findOrCreateUser(userId: conversationId)
            conversation?.addToParticipants(user)
            performSave(context: context, completionHandler: { _,_ in })
            
        }
    }
    
    func makeConversationsOffline() {
        if let context = coreDataStack.saveContext {
            let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
            do {
                let conversations = try context.fetch(request)
                
                for conversation in conversations {
                    conversation.isOnline = false
                }
                performSave(context: context, completionHandler: { _,_ in })
                
            } catch {
                
            }
        }
    }

    
    func saveSendedMessage(conversation: Conversation, to user: String, text: String) {
        if let context = coreDataStack.saveContext {
            let message = createMessage(with: text, context: context)
            message.text = text
            message.conversation = conversation
            message.conversation?.conversationId = user
            message.read = true
            message.received = false
            
            performSave(context: context, completionHandler: { _,_ in })
        }
    }
    
    func saveReceivedMessage(conversation: Conversation, conversationId: String, text: String) {
        if let context = coreDataStack.saveContext {
            let message = createMessage(with: text, context: context)
            message.text = text
            message.conversation = conversation
            message.conversation?.conversationId = conversationId
            message.read = false
            message.received = true
            
            performSave(context: context, completionHandler: { _,_ in })
        }

    }
    
    fileprivate func createMessage(with text: String, context: NSManagedObjectContext) -> Message {
        let message = Message(context: context)
        message.messageId = generateId()
        message.date = Date()
        message.text = text
        message.received = false
        
        return message
    }
    
 
    func findOrCreateUser(userId: String) -> User {
        let context = coreDataStack.saveContext
        let request = User.fetchRequestUser(model: (context?.persistentStoreCoordinator?.managedObjectModel)!, identifier: userId)!
        let user = findOrCreate(in: context!, request: request, entityName: "User")
        user?.userId = userId
        
        performSave(context: context!, completionHandler: { _,_ in  })
        return user!
    }
    
    fileprivate func performSave(context: NSManagedObjectContext, completionHandler: @escaping (Bool, Error?) -> Void) {
        if context.hasChanges {
            context.perform {
                [weak self] in
                
                do {
                    try context.save()
                }
                catch {
                    DispatchQueue.main.async { completionHandler(false, error) }
                    print("Context save error: \(error)")
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent, completionHandler: completionHandler)
                }
                else {
                    DispatchQueue.main.async { completionHandler(true, nil) }
                }
            }
        }
        else {
            completionHandler(true, nil)
        }
    }
}

func generateId() -> String {
    return ("\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString())!
}
