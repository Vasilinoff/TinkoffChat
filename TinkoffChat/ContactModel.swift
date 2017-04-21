//
//  ContactModel.swift
//  TinkoffChat
//
//  Created by Vasily on 24.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation

protocol ConversationCellConfiguration {
    var name: String { get }
    //var lastMessage: Message? { get set }
    //var date: Date? { get set }
    var online: Bool { get set }
    var hasUnreadedMessages: Bool { get set }
}

class Contact: ConversationCellConfiguration {
    let name: String
    var lastMessage: Message? {
        get {
                return messages.last!
        }
    }
    
    var messages: [Message]
    //var date: Date?
    var online: Bool
    var hasUnreadedMessages: Bool
    init(name: String, online: Bool, hasUnreadedMessages: Bool, messages: Message) {
        self.name = name
        self.online = online
        self.hasUnreadedMessages = hasUnreadedMessages
        self.messages = [messages]
        
    }
}


