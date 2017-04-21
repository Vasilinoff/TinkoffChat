//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Vasily on 03.04.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation

class OperationDataManager: DataManager {
    let operationQueue = { () -> OperationQueue in
        let queue =  OperationQueue()
        queue.qualityOfService = .utility
        return queue
    }()
    
    func loadProfileData(handler: @escaping (Profile?, DataManagerError?) -> () ) {
        let loadOperation = LoadDataOperation(fileName: "ProfileData")
        loadOperation.completionBlock = {
            guard let data = loadOperation.data, let profileData = Profile.create(fromData: data) else {
                handler(nil, .loadError)
                return
            }
            
            handler(profileData, nil)
        }
        
        operationQueue.addOperation(loadOperation)
    }
    
    func save(profileData: Profile, handler: @escaping (DataManagerError?) -> () ) {
        let saveOperation = SaveDataOperation(data: profileData.binaryData, fileName: "ProfileData")
        saveOperation.completionBlock =  {
            handler(.saveError)
        }
        
        operationQueue.addOperation(saveOperation)

    }

}
