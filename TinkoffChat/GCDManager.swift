//
//  GCD.swift
//  TinkoffChat
//
//  Created by Vasily on 02.04.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation
import UIKit

class GCDManager {
    var data = ProfileData(name: "name", about: "about", image: #imageLiteral(resourceName: "placeholder"), color: UIColor.black)
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent("ProfileData").path
    }
    
    func loadData() -> ProfileData {
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: self.filePath) as? ProfileData {
                self.data = ourData
                
            }
        }
        return self.data
    }
    
     func saveData(profileData: ProfileData) {
        self.data = profileData
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            NSKeyedArchiver.archiveRootObject(self.data, toFile: self.filePath)
        }
        
    
        print("saveData")
    }

    
    
    
}
