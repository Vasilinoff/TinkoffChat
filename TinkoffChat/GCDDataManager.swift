//
//  GCD.swift
//  TinkoffChat
//
//  Created by Vasily on 02.04.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation
import UIKit

class GCDDataManager: DataManager {
        var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent("ProfileData").path
    }
    
    func loadProfileData(handler: @escaping (ProfileData?, DataManagerError?) -> ()) {
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: self.filePath) as? ProfileData {
                handler(ourData, .loadError)
            }
        }
    }
    
    func save(profileData: ProfileData, handler: @escaping (DataManagerError?) -> () ) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            NSKeyedArchiver.archiveRootObject(profileData, toFile: self.filePath)
            handler(.loadError)
        }
    }

    
    
    
}
