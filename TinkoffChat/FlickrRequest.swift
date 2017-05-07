//
//  FlickrRequest.swift
//  TinkoffChat
//
//  Created by Vasily on 07.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation

class FlickrRequest: Requestable {
    static let apiKey = "50ec53feb856f7348251607f36a75ebb"
    let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=random&per_page=20&format=json&nojsoncallback=1"
    
    
    var urlRequest: URLRequest? {
        let urlString: String = URLString
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        
        return nil
    }
    
    
    
}
