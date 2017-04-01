//
//  profileData.swift
//  TinkoffChat
//
//  Created by Vasily on 01.04.17.
//  Copyright © 2017 Vasily. All rights reserved.


import Foundation
import UIKit

class ProfileData: NSObject, NSCoding {
    
    struct Keys {
        static let name = "name"
        static let about = "about"
        static let image = "image"
        static let color = "color"
    }
    
    private var _nameValue = "your name"
    private var _aboutValue = "your information"
    private var _profileImage = #imageLiteral(resourceName: "placeholder")
    private var _color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    init(name: String, about: String, image: UIImage, color: UIColor) {
        _nameValue = name
        _aboutValue = about
        _profileImage = image
        _color = color
        
    }
    
    required init(coder decoder: NSCoder) {
        if let nameObj = decoder.decodeObject(forKey: Keys.name) as? String {
            _nameValue = nameObj
        }
        if let aboutObj = decoder.decodeObject(forKey: Keys.about) as? String {
            _aboutValue = aboutObj
        }
        if let imageObj = decoder.decodeObject(forKey: Keys.image) as? UIImage {
            _profileImage = imageObj
        }
        if let colorObj = decoder.decodeObject(forKey: Keys.color) as? UIColor {
            _color = colorObj
        }
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_nameValue, forKey: Keys.name)
        aCoder.encode(_aboutValue, forKey: Keys.about)
        aCoder.encode(_profileImage, forKey: Keys.image)
        aCoder.encode(_color, forKey: Keys.color)
    }
    
    var nameValue: String {
        get {
            return _nameValue
        }
        set {
            _nameValue = newValue
        }
        
    }
    
    var aboutValue: String {
        get {
            return _aboutValue
        }
        set {
            _aboutValue = newValue
        }
    }
    
    var profileImage: UIImage {
        get {
            return _profileImage
        }
        set {
            _profileImage = newValue
        }
    }
    
    var color: UIColor {
        get {
            return _color
        }
        set {
            _color = newValue
        }
    }
}
