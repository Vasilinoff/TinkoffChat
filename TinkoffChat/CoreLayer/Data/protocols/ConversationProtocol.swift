//
//  ContactModel.swift
//  TinkoffChat
//
//  Created by Vasily on 24.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation

protocol ConversationConfiguration: class {
    var name: String { get }
    var lastMessageText: String? { get }
    var lastMessageDate: Date? { get }
    var online: Bool { get }
    var hasUnreadedMessages: Bool { get }
}

