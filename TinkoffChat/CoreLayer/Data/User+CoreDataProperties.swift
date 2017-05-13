//
//  User+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Vasily on 10.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var isOnline: Bool
    @NSManaged public var name: String?
    @NSManaged public var userId: String?
    @NSManaged public var conversations: NSSet?

}

// MARK: Generated accessors for conversations
extension User {

    @objc(addConversationsObject:)
    @NSManaged public func addToConversations(_ value: Conversation)

    @objc(removeConversationsObject:)
    @NSManaged public func removeFromConversations(_ value: Conversation)

    @objc(addConversations:)
    @NSManaged public func addToConversations(_ values: NSSet)

    @objc(removeConversations:)
    @NSManaged public func removeFromConversations(_ values: NSSet)

}
