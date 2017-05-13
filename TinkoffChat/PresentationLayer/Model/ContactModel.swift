//
//  ContactModel.swift
//  TinkoffChat
//
//  Created by Vasily on 24.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation

protocol ConversationCellConfiguration: class {
    var name: String { get }
    var lastMessageText: String? { get }
    var lastMessageDate: Date? { get }
    var online: Bool { get }
    var hasUnreadedMessages: Bool { get }
}

//class Contact: ConversationCellConfiguration {
//    let name: String
//    
//    var messages: [MessageModel]
//    var online: Bool
//    
//    private var lastMessage: MessageModel? {
//        get {
//            return messages.last
//        }
//    }
//    
//    var lastMessageText: String? {
//        get {
//            return lastMessage?.text
//        }
//    }
//    
//    var lastMessageDate: Date? {
//        get {
//            return lastMessage?.date
//        }
//    }
//    var hasUnreadedMessages: Bool {
//        get {
//            return true
//        }
//    }
//    
//    init(name: String, online: Bool, messages: [MessageModel]) {
//        self.name = name
//        self.online = online
//        self.messages = messages
//        
//    }
//}


