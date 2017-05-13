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
    @NSManaged public var read: Bool
    @NSManaged public var conversation: Conversation?

}
