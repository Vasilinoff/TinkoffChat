//
//  OperationManager.swift
//  TinkoffChat
//
//  Created by Vasily on 03.04.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation
import UIKit

class SaveDataOperation: Operation {
    let data: Data
    let fileName: String
    private var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent(fileName).path
    }
    
    init(data: Data, fileName: String) {
        self.data = data
        self.fileName = fileName
    }
    
    override func main() {
        let manager = FileManager.default
        manager.createFile(atPath: filePath, contents: data, attributes: nil)
    }
    
}
