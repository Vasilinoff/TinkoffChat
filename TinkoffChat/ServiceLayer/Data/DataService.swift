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
    
    func saveProfileData(_ profileModel: ProfileModel, completion: @escaping (Bool, Error?) -> Void) {
        if let context = coreDataStack.saveContext {
            if let appUser = findAppUser(in: context) {
                let profile = Profile(context: context)
                profile.name = profileModel.nameValue
                profile.about = profileModel.aboutValue
                profile.image = UIImageJPEGRepresentation(profileModel.profileImage, 1.0) as  Data?
                appUser.profile = profile
                
            }
            
            performSave(context: context, completionHandler: completion)
        }
    }
    
    
    fileprivate func findAppUser(in context: NSManagedObjectContext) -> AppUser? {
        if let context = coreDataStack.saveContext {
            let request = AppUser.fetchRequestAppUser(model: (context.persistentStoreCoordinator?.managedObjectModel)!)!
            let appUser = find(in: context, request: request, entityName: "AppUser")
            
            return appUser
        }
        
        return nil
    }
    
    func loadAppUser(completion: @escaping (AppUser?, Error?) -> Void) {
        if let context = coreDataStack.mainContext {
            let request = AppUser.fetchRequestAppUser(model: (context.persistentStoreCoordinator?.managedObjectModel)!)!

            if let appUser = find(in: context, request: request, entityName: "AppUser") {
                let currentUser = User(context: context)
                currentUser.userId = UIDevice.current.name
                appUser.currentUser = currentUser
                completion(appUser, nil)
                return
            }
        }
        completion(nil, nil)
    }
    
    
    fileprivate func insert<T>(in context: NSManagedObjectContext, entityName: String) -> T? {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T
    }
    
    fileprivate func find<T> (in context: NSManagedObjectContext, request: NSFetchRequest<T>, entityName: String) -> T? {
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
    
    func findConversation(conversationId: String) -> Conversation? {
        if let context = coreDataStack.mainContext {
            let request = Conversation.fetchRequestConversation(model: (context.persistentStoreCoordinator?.managedObjectModel)!, identifier: conversationId)!
            let conversation = find(in: context, request: request, entityName: "Conversation")
            conversation?.conversationId = conversationId
            
            performSave(context: context, completionHandler: { _,_ in  })
            return conversation
            
        }
        
        return nil
    }
    
    func saveFoundedConversation(conversationId: String) {
        if let context = coreDataStack.mainContext {
            var conversation = findConversation(conversationId: conversationId)
            
            let user = findUser(userId: conversationId)
            conversation?.addToParticipants(user)
            
        }
    }

    
    func saveSendedMessage(conversation: Conversation, to user: String, text: String) {
        if let context = coreDataStack.mainContext {
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
        if let context = coreDataStack.mainContext {
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
        message.date = Date()
        message.text = text
        
        return message
    }
    
 
    func findUser(userId: String) -> User {
        let context = coreDataStack.mainContext
        let request = User.fetchRequestUser(model: (context?.persistentStoreCoordinator?.managedObjectModel)!, identifier: userId)!
        let user = find(in: context!, request: request, entityName: "User")
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
