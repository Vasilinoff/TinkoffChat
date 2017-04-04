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
    func save(profileData: ProfileData, handler: @escaping (DataManagerError?) -> () )
    func loadProfileData(handler: @escaping (ProfileData?, DataManagerError?) ->() )
}
