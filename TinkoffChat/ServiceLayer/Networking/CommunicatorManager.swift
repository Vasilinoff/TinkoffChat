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
    func send(message: String, to user: String)
    var activeContactName: String? { get }
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
    
    
    func send(message: String, to user: String) {
        communicator.sendMessage(string: message, to: user) { success, error in
            if success {
                let conversation = self.dataService.findOrCreateConversation(conversationId: self.activeContactName!)
                self.dataService.saveSendedMessage(conversation: conversation!, to: user, text: message)
            } else {
                print("\(String(describing: error))")
            }
            
        }
    }
}

extension CommunicatorManager: CommunicatorDelegate {
    func didFoundUser(userID: String, userName: String?) {
        dataService.saveFoundedConversation(conversationId: userID)
        
        let conversation = dataService.findOrCreateConversation(conversationId: userID)
        conversation?.isOnline = true
        let user = dataService.findOrCreateUser(userId: userID)
        user.isOnline = true
        
        contactsDelegate?.contactListUpdated()
        
        if userID == activeContactName {
            activeContactDelegate?.becomeOnline()
        }
    }

    func didLostUser(userID: String) {
        let conversation = dataService.findOrCreateConversation(conversationId: userID)
        conversation?.isOnline = false
        
        let user = dataService.findOrCreateUser(userId: userID)
        user.isOnline = false
    }

    func failedToStartBrowsingForUsers(error: Error) {

    }

    func failedToStartAdvertising(error: Error) {

    }

    func didRecievedMessage(text: String, fromUser: String, toUser: String) {
        
        contactsDelegate?.contactListUpdated()
        let conversation = dataService.findOrCreateConversation(conversationId: fromUser)
        
        dataService.saveReceivedMessage(conversation: conversation!, conversationId: fromUser, text: text)
        
        if fromUser == activeContactName {
            activeContactDelegate?.didRecieve(message: text)
        }
    }
}
