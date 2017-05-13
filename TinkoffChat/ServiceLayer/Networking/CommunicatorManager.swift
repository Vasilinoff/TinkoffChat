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
    func send(message: Message)
}

class CommunicatorManager {
    weak var contactsDelegate: ContactsDelegate?
    weak var activeContactDelegate: ContactManagerDelegate?
    var dataService = DataService()
    
    var communicator: Communicator
    
    var activeContactName: String?
    
    init() {
        self.communicator = MultipeerCommunicator()
        self.communicator.delegate = self
    }
}

extension CommunicatorManager: ContactManager {
    
    
    func send(message: Message) {
        guard let recipientUsername = message.conversation?.conversationId else {
            fatalError()
        }
        communicator.sendMessage(string: message.text, to: recipientUsername, completionHandler: nil)
    }
}

extension CommunicatorManager: CommunicatorDelegate {
    func didFoundUser(userID: String, userName: String?) {

        let conversation = dataService.findOrIntesrConversation(userId: userID)
        let user = dataService.findOrInsertUser(userId: userID)
        conversation?.addToParticipants(user)
        
        contactsDelegate?.contactListUpdated()
        
        if userID == activeContactName {
            activeContactDelegate?.becomeOnline()
        }
    }

    func didLostUser(userID: String) {
//        let lostConversation = conversations.filter({ $0.name == userID  })
//        
//        for conversation in lostConversation {
//            conversation.participants
//        }
//        contactsDelegate?.contactListUpdated()
//        
//        if userID == activeContact?.name {
//            activeContactDelegate?.becomeOffline()
//        }
    }

    func failedToStartBrowsingForUsers(error: Error) {

    }

    func failedToStartAdvertising(error: Error) {

    }

    func didRecievedMessage(text: String, fromUser: String, toUser: String) {
        
        
        contactsDelegate?.contactListUpdated()
        
        if fromUser == activeContactName {
            activeContactDelegate?.didRecieve(message: text)
        }
    }
}
