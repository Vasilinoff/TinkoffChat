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

extension AppUser {
    static func fetchRequestAppUser(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        let templateName = "AppUser"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
            assert(false, "No template with name \(templateName)")
            return nil
        }
        
        return fetchRequest
    }
}

extension Conversation {
    static func fetchRequestConversation(model: NSManagedObjectModel) -> NSFetchRequest<Conversation>? {
        let templateName = "Conversation"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<Conversation> else {
            assert(false, "no template with name \(templateName)")
            
            return nil
        }
        
        return fetchRequest
    }
}

extension User {
    static func fetchRequestUser(model: NSManagedObjectModel, identifier: String) -> NSFetchRequest<User>? {
        let templateName = "User"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["identifier" : identifier]) as? NSFetchRequest<User> else {
            assert(false, "No template with name \(templateName)")
            
            return nil
        }
        
        return fetchRequest
    }
}

extension Message {
    static func fetchRequest(model: NSManagedObjectModel, conversationIdentifier: String) -> NSFetchRequest<Message>? {
        let templateName = "Message"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["indentifier" : conversationIdentifier]) as? NSFetchRequest<Message> else {
            assert(false, "No template with name \(templateName)")
            
            return nil
        }
        
        return fetchRequest
    }
}

class DataService {
    fileprivate let coreDataStack = CoreDataStack.sharedCoreDataStack
    
    func saveProfileData(_ profileModel: ProfileModel, completion: @escaping (Bool, Error?) -> Void) {
        if let context = coreDataStack.saveContext {
            if let appUser = findOrInsertAppUser(in: context) {
                let profile = Profile(context: context)
                profile.name = profileModel.nameValue
                profile.about = profileModel.aboutValue
                profile.image = UIImageJPEGRepresentation(profileModel.profileImage, 1.0) as  Data?
                appUser.profile = profile
                
            }
            
            performSave(context: context, completionHandler: completion)
        }
    }
    
    
    fileprivate func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        if let context = coreDataStack.saveContext {
            let request = AppUser.fetchRequestAppUser(model: (context.persistentStoreCoordinator?.managedObjectModel)!)!
            let appUser = findOrInsert(in: context, request: request, entityName: "AppUser")
            
            return appUser
        }
        
        return nil
    }
    
    func loadAppUser(completion: @escaping (AppUser?, Error?) -> Void) {
        if let context = coreDataStack.mainContext {
            let request = AppUser.fetchRequestAppUser(model: (context.persistentStoreCoordinator?.managedObjectModel)!)!

            if let appUser = findOrInsert(in: context, request: request, entityName: "AppUser") {
                let currentUser = User(context: context)
                currentUser.userId = UIDevice.current.name
                appUser.currentUser = currentUser
                completion(appUser, nil)
                return
            }
        }
        completion(nil, nil)
    }
    
//    func loadConversations(completion: @escaping ([Conversation]?) -> Void ) {
//        loadAppUser { (appUser, error) in
//            completion(appUser!.currentUser?.conversations?.allObjects as? [Conversation])
//        }
//    }
    
    fileprivate func insert<T>(in context: NSManagedObjectContext, entityName: String) -> T? {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T
    }
    
    fileprivate func findOrInsert<T> (in context: NSManagedObjectContext, request: NSFetchRequest<T>, entityName: String) -> T? {
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
    
    func findOrIntesrConversation(userId: String) -> Conversation? {
        if let context = coreDataStack.saveContext {
            let request = Conversation.fetchRequestConversation(model: (context.persistentStoreCoordinator?.managedObjectModel)!)!
            let conversation = findOrInsert(in: context, request: request, entityName: "Conversation")
            conversation?.conversationId = userId
            
            performSave(context: context, completionHandler: { _,_ in  })
            return conversation
            
        }
        
        return nil
    }
    
    func insertMessage(messageId: String, text: String) -> Message? {
        if let context = coreDataStack.saveContext {
            let message: Message = insert(in: context, entityName: "Message")!
            message.text = text
            performSave(context: context, completionHandler: { _,_ in })
            return message
        }
        
        return nil
    }
    
 
    func findOrInsertUser(userId: String) -> User {
        let context = coreDataStack.mainContext
        let request = User.fetchRequestUser(model: (context?.persistentStoreCoordinator?.managedObjectModel)!, identifier: userId)!
        let user = findOrInsert(in: context!, request: request, entityName: "User")
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
