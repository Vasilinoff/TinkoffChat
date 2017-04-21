//
//  MessageModel.swift
//  TinkoffChat
//
//  Created by Vasily on 25.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//
import Foundation

protocol MessageCellConfiguration: class {
    var text: String? { get set }
    
}

class Message: MessageCellConfiguration {
    var text: String?
    let received: Bool
    let date: Date?
    private var dateFormaеter: DateFormatter?
    
    init(text: String?, received: Bool, date: Date?) {
        self.text = text
        self.received = received
        self.date = date
    }
    
}

