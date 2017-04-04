//
//  profileData.swift
//  TinkoffChat
//
//  Created by Vasily on 01.04.17.
//  Copyright © 2017 Vasily. All rights reserved.


import Foundation
import UIKit

class ProfileData: NSObject, NSCoding {
    
    enum Keys: String {
        case name
        case about
        case image
        case color
    }
    
    var nameValue = "your name"
    var aboutValue = "your information"
    var profileImage = #imageLiteral(resourceName: "placeholder")
    var colorValue = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    static func create(fromData data: Data) -> ProfileData? {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? ProfileData
    }
    
    init(name: String, about: String, image: UIImage, color: UIColor) {
        nameValue = name
        aboutValue = about
        profileImage = image
        colorValue = color
        
    }
    
    required init(coder decoder: NSCoder) {
        if let nameObj = decoder.decodeObject(forKey: Keys.name.rawValue) as? String {
            nameValue = nameObj
        }
        if let aboutObj = decoder.decodeObject(forKey: Keys.about.rawValue) as? String {
            aboutValue = aboutObj
        }
        if let imageObj = decoder.decodeObject(forKey: Keys.image.rawValue) as? UIImage {
            profileImage = imageObj
        }
        if let colorObj = decoder.decodeObject(forKey: Keys.color.rawValue) as? UIColor {
            colorValue = colorObj
        }
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nameValue, forKey: Keys.name.rawValue)
        aCoder.encode(aboutValue, forKey: Keys.about.rawValue)
        aCoder.encode(profileImage, forKey: Keys.image.rawValue)
        aCoder.encode(colorValue, forKey: Keys.color.rawValue)
    }
    
    var binaryData: Data {
        get {
            return NSKeyedArchiver.archivedData(withRootObject: self)
        }
    }
}
