//
//  MessageModel.swift
//  TinkoffChat
//
//  Created by Vasily on 25.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//


protocol MessageCellConfiguration: class {
    var text: String? { get set }
    
}

class Message: MessageCellConfiguration {
    var text: String?
    let received: Bool
    init(text: String?, received: Bool) {
        self.text = text
        self.received = received
        
    }
}
