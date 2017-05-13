//
//  MessageModel.swift
//  TinkoffChat
//
//  Created by Vasily on 25.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//
import Foundation

protocol MessageCellConfiguration: class {
    var text: String { get }
    var received: Bool { get }
    var date: Date { get }
}

class MessageModel: MessageCellConfiguration {
    let text: String
    let received: Bool
    let date: Date
    
    init(text: String, received: Bool, date: Date) {
        self.text = text
        self.received = received
        self.date = date
    }
    
}

