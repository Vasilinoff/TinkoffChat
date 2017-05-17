//
//  ProfileSaveService.swift
//  TinkoffChat
//
//  Created by Vasily on 02.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Profile {
    static func fetchRequestProfile(model: NSManagedObjectModel) -> NSFetchRequest<Profile>? {
        let templateName = "Profile"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<Profile> else {
            assert(false, "No template with name \(templateName)")
            return nil
        }
        
        return fetchRequest
    }
}

class ProfileSaveService {
    fileprivate let coreDataStack = CoreDataStack.sharedCoreDataStack
    
    func saveProfileData(_ profileModel: ProfileModel, completion: @escaping (Bool, Error?) -> Void) {
        if let context = coreDataStack.saveContext {
            if let profile = findOrCreateProfile(in: context) {
                profile.name = profileModel.nameValue
                profile.about = profileModel.aboutValue
                profile.image = UIImageJPEGRepresentation(profileModel.profileImage, 1.0) as  Data?
            }
            
            performSave(context: context, completionHandler: completion)
        }
    }
    
    fileprivate func findOrCreateProfile(in context: NSManagedObjectContext) -> Profile? {
        var profile: Profile?
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("No managed object model in context!")
            assert(false)
            
            return nil
        }
        
        guard let fetchRequest = Profile.fetchRequestProfile(model: model) else {
            
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            if let foundProfile = results.first {
                profile = foundProfile
            }
        }
        catch {
            print("Failed to fetch Profile")
        }
        
        if profile == nil {
            profile = insertProfile(in: context)
        }
        
        return profile
    }
    
    fileprivate func insertProfile(in context: NSManagedObjectContext) -> Profile? {
        return NSEntityDescription.insertNewObject(forEntityName: "Profile", into: context) as? Profile
    }

    func loadProfileData(completion: @escaping (ProfileModel?, Error?) -> Void) {
        var profileModel: ProfileModel?
        if let context = coreDataStack.mainContext {
            if let profile = findOrCreateProfile(in: context) {
                if let profileImage = profile.image {
                    let image = UIImage(data: profileImage as Data)
                    profileModel = ProfileModel(name: profile.name, about: profile.about, image: image)
                }
            }
        }
        
        completion(profileModel, nil)
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
