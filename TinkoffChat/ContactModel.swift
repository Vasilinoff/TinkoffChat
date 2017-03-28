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

func fillContactModel() {
    contacts.append(Contact(name: "first", message: nil, date: Date.init(), online: true, hasUnreadedMessages: false))
    contacts.append(Contact(name: "second", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init(), online: false, hasUnreadedMessages: true))
    contacts.append(Contact(name: "7", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: true, hasUnreadedMessages: false))
    contacts.append(Contact(name: "8", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: true, hasUnreadedMessages: true))
    contacts.append(Contact(name: "9", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: true, hasUnreadedMessages: false))
    contacts.append(Contact(name: "10", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: true, hasUnreadedMessages: true))
    contacts.append(Contact(name: "11", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: true, hasUnreadedMessages: false))
    contacts.append(Contact(name: "12", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: true, hasUnreadedMessages: false))
    contacts.append(Contact(name: "13", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: true, hasUnreadedMessages: false))
    contacts.append(Contact(name: "14", message: nil, date: Date.init() , online: true, hasUnreadedMessages: false))
    contacts.append(Contact(name: "15", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: false, hasUnreadedMessages: false))
    contacts.append(Contact(name: "16", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: false, hasUnreadedMessages: false))
    contacts.append(Contact(name: "17", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: false, hasUnreadedMessages: false))
    contacts.append(Contact(name: "18", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: false, hasUnreadedMessages: false))
    contacts.append(Contact(name: "19", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: false, hasUnreadedMessages: false))
    contacts.append(Contact(name: "20", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: false, hasUnreadedMessages: true))
    contacts.append(Contact(name: "21", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: false, hasUnreadedMessages: false))
    contacts.append(Contact(name: "22", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: true, hasUnreadedMessages: false))
    contacts.append(Contact(name: "23", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: false, hasUnreadedMessages: true))
    contacts.append(Contact(name: "24", message: nil, date: Date.init() , online: false, hasUnreadedMessages: true))
    contacts.append(Contact(name: "25", message: nil, date: Date.init(), online: false, hasUnreadedMessages: true))
    contacts.append(Contact(name: "26", message: "a a a a a a a a a a a a a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a aa a a a a a a a a a a", date: Date.init() , online: false, hasUnreadedMessages: true))
    
}
