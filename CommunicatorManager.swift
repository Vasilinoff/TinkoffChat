//
//  CommunicatorManager.swift
//  TinkoffChat
//
//  Created by Vasily on 14.04.17.
//  Copyright © 2017 Vasily. All rights reserved.
//
import Foundation

protocol ContactsDelegate: class {
    func contactCreated(withUser: String)
    func contactUpdated(withUser: String)
    func contactDestroyed(withUser: String)
}

protocol ContactManagerDelegate: class {
    func didRecieve(message: String)
    func becomeOnline()
    func becomeOffline()
}

protocol ContactManager {
    func send(message: String)
    var activeContact: Contact? { get set }
}

class CommunicatorManager {
    weak var contactsDelegate: ContactsDelegate?
    weak var activeContactDelegate: ContactManagerDelegate?
    
    var communicator: Communicator
    
    var contacts: [Contact] = []
    var activeContact: Contact?
    
    init() {
        self.communicator = MultipeerCommunicator()
        self.communicator.delegate = self
    }
}

extension CommunicatorManager: ContactManager {
    func send(message: String) {
        guard let recipientUsername = activeContact?.name else {
            fatalError()
        }
        communicator.sendMessage(string: message, to: recipientUsername, completionHandler: nil)
    }
    
}

extension CommunicatorManager: CommunicatorDelegate {
    func didFoundUser(userID: String, userName: String?) {
        let contact = Contact.init(name: userID, online: true, hasUnreadedMessages: false, messages: Message(text: nil, received: false, date: nil))
        contacts.append(contact)
        
        contactsDelegate?.contactCreated(withUser: userID)
        
        if userID == activeContact?.name {
            activeContactDelegate?.becomeOnline()
        }
    }

    func didLostUser(userID: String) {
        contacts = contacts.filter({ $0.name != userID  })
        contacts.first?.online = false
        contactsDelegate?.contactDestroyed(withUser: userID)
        
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
        
        contactsDelegate?.contactUpdated(withUser: fromUser)
        
        if fromUser == activeContact?.name {
            activeContactDelegate?.didRecieve(message: text)
        }
        
        
    }

}
