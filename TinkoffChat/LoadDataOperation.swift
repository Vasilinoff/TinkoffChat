//
//  LoadDataOperation.swift
//  TinkoffChat
//
//  Created by Vasily on 03.04.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation

class LoadDataOperation: Operation {
    var data: Data?
    
    let fileName: String
    private var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent(fileName).path
    }
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    override func main() {
        let fileHandle = FileHandle.init(forReadingAtPath: filePath)
        data = fileHandle?.readDataToEndOfFile()
    }
}
