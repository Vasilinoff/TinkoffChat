//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Vasily on 26.04.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataStack {
    private var  storeURL: URL {
        get {
            let documentsDirURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentsDirURL.appendingPathComponent("Store.sqlite")
            
            return url
        }
    }
    
    static let sharedCoreDataStack = CoreDataStack()
    
    fileprivate init() {}
    
    private let managedObjectModelName = "ProfileDataModel"
    private var _managedObjectModel: NSManagedObjectModel?
    private var managedObjectModel: NSManagedObjectModel? {
        get {
            if _managedObjectModel == nil {
                guard let modelURL = Bundle.main.url(forResource: managedObjectModelName, withExtension: "momd") else {
                    print("Empty model url!")
                    return nil
                }
                
                _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
            }
            
            return _managedObjectModel
        }
    }
    
    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        get {
            if _persistentStoreCoordinator == nil {
                guard let model = self.managedObjectModel else {
                    print("Empty managed obejct model!")
                    return nil
                }
                
                _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
                
                do {
                    try _persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                } catch {
                    assert(false, "Error adding persistent store to coordinator: \(error)")
                }
            }
            
            return _persistentStoreCoordinator
        }
    }
    
    private var _masterContext: NSManagedObjectContext?
    private var masterComtext: NSManagedObjectContext? {
        get {
            if _masterContext == nil {
                let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
                guard let persistentStoreCoordinator = self.persistentStoreCoordinator else {
                    print("Empty persistent store coordinator!")
                    
                    return nil
                }
                
                context.persistentStoreCoordinator = persistentStoreCoordinator
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _masterContext = context
            }
            
            return _masterContext
        }
    }
    
    private var _mainContext: NSManagedObjectContext?
    public var mainContext: NSManagedObjectContext? {
        get {
            if _mainContext == nil {
                let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
                guard let parentContext = self.masterComtext else {
                    print("No master context!")
                    
                    return nil
                }
                
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _mainContext = context
            }
            
            return _mainContext
        }
    }
    
    private var _saveContext: NSManagedObjectContext?
    public var saveContext: NSManagedObjectContext? {
        get {
            if _saveContext == nil {
                let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
                guard let parentContext = self.mainContext else {
                    print("No master context!")
                    
                    return nil
                }
                
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                context.undoManager = nil
                _saveContext = context
            }
            
            return _saveContext
        }
    }
    
    public func performSave(context: NSManagedObjectContext, completionHandler: (() -> Void)? ) {
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                }
                catch {
                    print("context save error: \(error)")
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent, completionHandler: completionHandler)
                } else {
                    completionHandler?()
                }
                
            }
        }  else {
            completionHandler?()
        }
    }
    
//    static func insertProfile(in context : NSManagedObjectContext) -> Profile? {
//        if let profile = NSEntityDescription.insertNewObject(forEntityName: "Profile", into: context) as? Profile  {
//            if profile.name == nil {
//                profile.name = "name"
//                profile.about = "about"
//                
//                let img = UIImage(named: "placeholder")
//                let imgData = UIImageJPEGRepresentation(img!, 1)
//                
//                profile.setValue(imgData, forKey: "photo")
//                
//                return profile
//            }
//            return profile
//        }
//        else {
//            return nil
//        }
//    }
//    
//    static func findOrInserNewProfile( in context: NSManagedObjectContext) -> Profile? {
//        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
//            print("Model is not available in context")
//            assert(false)
//            return nil
//        }
//        
//        var profile: Profile?
//        guard let fetchRequest = Profile.fetchRequestProfile(model: model) else {
//            return nil
//        }
//        return profile
//    }
//}


}
