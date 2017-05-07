//
//  Requestable.swift
//  TinkoffChat
//
//  Created by Vasily on 07.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation

protocol Requestable {
    var urlRequest: URLRequest? { get }
}
