//
//  RequestsFactory.swift
//  TinkoffChat
//
//  Created by Vasily on 07.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation

struct RequestsFactory {
    struct FlickrReq {
        static func flickrConfig() -> RequestConfig<[FlickrPhoto]> {
            let request = FlickrRequest()
            return RequestConfig<[FlickrPhoto]>(request: request, parser: FlickrParser() )
        }
    }
}
