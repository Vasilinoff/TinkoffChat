//
//  ProfileDataManager.swift
//  TinkoffChat
//
//  Created by Vasily on 23.04.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation

enum Metod {
    case GCD
    case Operation
}

class ProfileDataManager {
    
    let metod: Metod
    init(metod: Metod) {
        self.metod = metod
    }
    
    func loadProfileData(handler: @escaping (Profile?, DataManagerError?) -> () ) {
        let dataManager: DataManager = (metod == .GCD ) ? GCDDataManager.init(fileName: "ProfileData") : OperationDataManager.init()
        
        dataManager.loadData(fromFile: "ProfileData") { (data, error) in
            guard let data = data else {
                handler(nil, .loadError)
                return
            }
            
            guard let profileData = Profile.create(fromData: data) else {
                handler(nil, .loadError)
                return
            }

            handler(profileData, nil)
        }
    }
    
    func save(profileData: Profile, handler: @escaping (DataManagerError?) -> () ) {
        let dataManager: DataManager = (metod == .GCD ) ? GCDDataManager.init(fileName: "ProfileData") : OperationDataManager.init()
        
        dataManager.save(data: profileData.binaryData, toFile: "ProfileData") { (error) in
            handler(error)
        }
    }
}
