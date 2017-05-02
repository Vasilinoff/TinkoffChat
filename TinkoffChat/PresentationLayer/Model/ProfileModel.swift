//
//  profileData.swift
//  TinkoffChat
//
//  Created by Vasily on 01.04.17.
//  Copyright © 2017 Vasily. All rights reserved.


import Foundation
import UIKit

class ProfileModel: NSObject {
    
    enum Keys: String {
        case name
        case about
        case image
        //case color
    }
    
    var nameValue = "your name"
    var aboutValue = "your information"
    var profileImage = #imageLiteral(resourceName: "placeholder")
    //var colorValue = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    static func create(fromData data: Data) -> ProfileModel? {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? ProfileModel
    }
    
    init(name: String?, about: String?, image: UIImage?) {
        nameValue = name ?? "your name"
        aboutValue = about ?? "your information"
        profileImage = image ?? #imageLiteral(resourceName: "placeholder")
        //colorValue = color
        
    }
    
    var binaryData: Data {
        get {
            return NSKeyedArchiver.archivedData(withRootObject: self)
        }
    }
}
