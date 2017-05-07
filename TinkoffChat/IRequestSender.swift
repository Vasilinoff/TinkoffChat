//
//  IRequestSender.swift
//  TinkoffChat
//
//  Created by Vasily on 07.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import Foundation

struct RequestConfig<T> {
    let request: Requestable
    let parser: Parser<T>
}

enum Result<FlickrPhoto> {
    case Success(FlickrPhoto)
    case Fail(String)
}

protocol IRequestSender {
    func send<T>(config: RequestConfig<T>, completionHandler: @escaping (Result<T>) -> Void)
}
