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
    let fileName: String
    var data: Data?
    private var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent(fileName).path
    }
    
    init( fileName: String) {
        self.fileName = fileName
    }
    
    func loadData(fromFile fileName: String, handler: @escaping (Data?, DataManagerError?) -> () ) {
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            let fileHandle = FileHandle.init(forReadingAtPath: self.filePath)
            self.data = fileHandle?.readDataToEndOfFile()
            handler(self.data, .loadError)
        }
    }
    
    func save(data: Data, toFile fileName: String, handler: @escaping (DataManagerError?) -> () ) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            let manager = FileManager.default
            manager.createFile(atPath: self.filePath, contents: data, attributes: nil)
            handler(.saveError)
        }
    }
}
