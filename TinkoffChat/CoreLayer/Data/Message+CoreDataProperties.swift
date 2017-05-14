//
//  Message+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Vasily on 10.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation
import CoreData


extension Message: MessageCellConfiguration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: Date
    @NSManaged public var received: Bool
    @NSManaged public var text: String
    @NSManaged public var messageId: String
    @NSManaged public var read: Bool
    @NSManaged public var conversation: Conversation?

}

extension Message {
    static func fetchRequestMessage(context: NSManagedObjectContext, conversationId: String) -> NSFetchRequest<Message>? {
        let templateName = "Message"
        let model = context.persistentStoreCoordinator?.managedObjectModel
        guard let fetchRequest = model?.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["conversationId" : conversationId]) as? NSFetchRequest<Message> else {
            assert(false, "No template with name \(templateName)")
            
            return nil
        }
        
        return fetchRequest
    }
    
    static func fetchRequestMessageId(context: NSManagedObjectContext, messageId: String) -> NSFetchRequest<Message>? {
        let templateName = "Message"
        let model = context.persistentStoreCoordinator?.managedObjectModel
        guard let fetchRequest = model?.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["messageId" : messageId]) as? NSFetchRequest<Message> else {
            assert(false, "No template with name \(templateName)")
            
            return nil
        }
        
        return fetchRequest
    }
}
