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
    //var activeConversation: Conversation?
    
    init() {
        self.communicator = MultipeerCommunicator()
        self.communicator.delegate = self
    }
}

extension CommunicatorManager: ContactManager {
    
    
    func send(message: String, to user: String) {
        communicator.sendMessage(string: message, to: user) { success, error in
            if success {
                let conversation = self.dataService.findConversation(conversationId: self.activeContactName!)
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
        let conversation = dataService.findConversation(conversationId: fromUser)
        
        
        dataService.saveReceivedMessage(conversation: conversation!, conversationId: fromUser, text: text)
        
        if fromUser == activeContactName {
            activeContactDelegate?.didRecieve(message: text)
        }
    }
}
