//
//  MessageModel.swift
//  TinkoffChat
//
//  Created by Vasily on 25.03.17.
//  Copyright © 2017 Vasily. All rights reserved.
//
import Foundation

protocol MessageConfiguration: class {
    var text: String { get }
    var received: Bool { get }
    var date: Date { get }
}

