//
//  AppUser+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Vasily on 10.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation
import CoreData


extension AppUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppUser> {
        return NSFetchRequest<AppUser>(entityName: "AppUser")
    }

    @NSManaged public var users: NSSet?
    @NSManaged public var currentUser: User?
    @NSManaged public var profile: Profile?

}

// MARK: Generated accessors for users
extension AppUser {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: User)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: User)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}
