//
//  FlickrSearchService.swift
//  TinkoffChat
//
//  Created by Vasily on 07.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation

class FlickrSearchService {
    
    let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func flickrSearch() {
        
        let requestConfig: RequestConfig<[FlickrPhoto]> = RequestsFactory.FlickrReq.flickrConfig()
        requestSender.send(config: requestConfig) { (result: Result<[FlickrPhoto]>) in
    
        }
    }
}
