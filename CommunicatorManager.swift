//
//  CommunicatorManager.swift
//  TinkoffChat
//
//  Created by Vasily on 14.04.17.
//  Copyright © 2017 Vasily. All rights reserved.
//
import Foundation

protocol ContactsDelegate: class {
    func contactListUpdated()
}

protocol ContactManagerDelegate: class {
    func didRecieve(message: String)
    func becomeOnline()
    func becomeOffline()
}

protocol ContactManager {
    func send(message: String)
    var activeContact: ConversationCellConfiguration? { get }
    var activeContactMessages: [MessageCellConfiguration]? { get }
}

class CommunicatorManager {
    weak var contactsDelegate: ContactsDelegate?
    weak var activeContactDelegate: ContactManagerDelegate?
    
    var communicator: Communicator
    
    fileprivate var contacts: [Contact] = []
    
    var transportContacts: [ConversationCellConfiguration] {
        get {
            return contacts
        }
    }
    
    var activeContactName: String?
    
    init() {
        self.communicator = MultipeerCommunicator()
        self.communicator.delegate = self
    }
}

extension CommunicatorManager: ContactManager {
    var activeContact: ConversationCellConfiguration? {
        get {
            return contacts.filter({ $0.name == activeContactName }).first
        }
    }
    var activeContactMessages: [MessageCellConfiguration]? {
        get {
            return contacts.filter({ $0.name == activeContactName }).first?.messages
        }
    }
    
    func send(message: String) {
        guard let recipientUsername = activeContact?.name else {
            fatalError()
        }
        communicator.sendMessage(string: message, to: recipientUsername, completionHandler: nil)
        
        let contact = contacts.filter({ $0.name == recipientUsername }).first
        contact?.messages.append(Message(text: message, received: false, date: Date()))
        
        contacts.append(contact!)

    }
    
}

extension CommunicatorManager: CommunicatorDelegate {
    func didFoundUser(userID: String, userName: String?) {
        var contact: Contact! = contacts.filter({ $0.name == userID}).first
        if contact == nil {
            contact = Contact(name: userID, online: true, messages: [])
            contacts.append(contact)
        }
        
        contact.online = true
        
        contactsDelegate?.contactListUpdated()
        
        if userID == activeContact?.name {
            activeContactDelegate?.becomeOnline()
        }
    }

    func didLostUser(userID: String) {
        let lostContacts = contacts.filter({ $0.name == userID  })
        
        for contact in lostContacts {
            contact.online = false
        }
        contactsDelegate?.contactListUpdated()
        
        if userID == activeContact?.name {
            activeContactDelegate?.becomeOffline()
        }
    }

    func failedToStartBrowsingForUsers(error: Error) {

    }

    func failedToStartAdvertising(error: Error) {

    }

    func didRecievedMessage(text: String, fromUser: String, toUser: String) {
        let contact = contacts.filter({ $0.name == fromUser }).first
        contact?.messages.append(Message(text: text, received: true, date: Date()))
        
        contactsDelegate?.contactListUpdated()
        
        if fromUser == activeContact?.name {
            activeContactDelegate?.didRecieve(message: text)
        }
    }
}
