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
    
    func flickrSearch(completionHandler: @escaping ([FlickrPhoto]?, String?) -> Void) {
        
        let requestConfig: RequestConfig<[FlickrPhoto]> = RequestsFactory.FlickrReq.flickrConfig()
        requestSender.send(config: requestConfig) { (result: Result<[FlickrPhoto]>) in
            switch result {
            case .Success(let apps):
                completionHandler(apps, nil)
            case .Fail(let error):
                completionHandler(nil, error)
            }
        }
    }
}
