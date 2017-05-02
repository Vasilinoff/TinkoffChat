//
//  CoreDataEntityClass.swift
//  TinkoffChat
//
//  Created by Vasily on 02.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation
import CoreData

@objc(Profile)
public class Profile: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var about: String?
    @NSManaged var image: Data?
    
}
