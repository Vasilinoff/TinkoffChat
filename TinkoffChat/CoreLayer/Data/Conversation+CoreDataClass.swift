//
//  Conversation+CoreDataClass.swift
//  TinkoffChat
//
//  Created by Vasily on 10.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation
import CoreData

@objc(Conversation)
public class Conversation: NSManagedObject {
    

}

extension Conversation: ConversationCellConfiguration {
    fileprivate var lastMessage: Message? {
        return (self.messages?.allObjects as! [Message]).sorted(by: { $0.date < $1.date }).last
    }
    var name: String {
        return self.participants!.reduce("", { (result, element) -> String in
            let participant = element as! User
            return result + ", " + participant.userId!
        })
    }
    var lastMessageText: String? {
        return lastMessage?.text
    }
    var lastMessageDate: Date? {
        return lastMessage?.date
    }
    var online: Bool {
        return true
    }
    var hasUnreadedMessages: Bool {
        return lastMessage?.read ?? false 
    }
}
