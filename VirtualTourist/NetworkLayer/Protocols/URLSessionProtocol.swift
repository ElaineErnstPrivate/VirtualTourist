//
//  NetworkRouter.swift
//  GKNetworkingLayer
//
//  Created by Elaine Ernst on 2019/07/19.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

public protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> ()
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask
    
}

extension URLSession: URLSessionProtocol {
    
    func dataTask(request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        return dataTask(with: request, completionHandler: completionHandler)
    }
}
