//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Vasily on 07.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation

class RequestSender: IRequestSender {
    let session = URLSession.shared
    
    func send<T>(config: RequestConfig<T>, completionHandler: @escaping (Result<T>) -> ()) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.Fail("url string can't parser to URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(Result.Fail(error.localizedDescription))
                return
            }
            
            guard let data = data,
                let parseModel: T = config.parser.parse(data: data) else {
                    completionHandler(Result.Fail("recieved data can't be parsed"))
                    return
            }
            completionHandler(Result.Success(parseModel))
        }
        
        task.resume()
    }
    
}
