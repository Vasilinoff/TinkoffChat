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
    var message: String? { get set }
    var date: Date? { get set }
    var online: Bool { get set }
    var hasUnreadedMessages: Bool { get set }
}

class Contact: ConversationCellConfiguration {
    let name: String
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadedMessages: Bool
    init(name: String, message: String?, date: Date?, online: Bool, hasUnreadedMessages: Bool) {
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadedMessages = hasUnreadedMessages
        
    }
}
