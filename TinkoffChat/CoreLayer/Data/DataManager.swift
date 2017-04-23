//
//  DataManager.swift
//  TinkoffChat
//
//  Created by Vasily on 03.04.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation

enum DataManagerError: Error {
    case saveError
    case loadError
}

protocol DataManager {
    func save(data: Data, toFile fileName: String, handler: @escaping (DataManagerError?) -> () )
    func loadData(fromFile fileName: String, handler: @escaping (Data?, DataManagerError?) -> () )
}
