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
    
    func loadData(fromFile fileName: String, handler: @escaping (Data?, DataManagerError?) -> () ) {
        let loadOperation = LoadDataOperation(fileName: fileName)
        loadOperation.completionBlock = {
            if loadOperation.data?.count == 0 {
                handler(nil, .loadError)
                return
            }
            
            guard let data = loadOperation.data else {
                handler(nil, .loadError)
                return
            }
            
            handler(data, nil)
        }
        
        operationQueue.addOperation(loadOperation)
    }
    
    func save(data: Data, toFile fileName: String, handler: @escaping (DataManagerError?) -> () ) {
        let saveOperation = SaveDataOperation(data: data, fileName: fileName)
        saveOperation.completionBlock =  {
            handler(.saveError)
        }
        
        operationQueue.addOperation(saveOperation)

    }

}
