//
//  FlickrParser.swift
//  TinkoffChat
//
//  Created by Vasily on 07.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation

class Parser<T> {
    func parse(data: Data) -> T? { return nil }
}


class FlickrParser: Parser<[FlickrPhoto]> {
    
    override func parse (data: Data) -> [FlickrPhoto]? {
        do {
        
            guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] else {
                return nil
            }
            
            var flickrPhotos: [FlickrPhoto] = []

            guard let photosContainer = json["photos"] as? [String: AnyObject],
                let photosReceived = photosContainer["photo"] as? [[String: AnyObject]] else {
                    return nil
            }
            
            for photoObject in photosReceived {
                    guard let photoID = photoObject["id"] as? String,
                        let farm = photoObject["farm"] as? Int ,
                        let server = photoObject["server"] as? String ,
                        let secret = photoObject["secret"] as? String else {
                            continue
                    }
                let photo = FlickrPhoto(photoID: photoID, farm: farm, server: server, secret: secret)
                flickrPhotos.append(photo)
            }
            
            return flickrPhotos
            
        } catch {
            print("JSON serialization fail!")
        }
        
        return nil
    }
    
}
