//
//  URLComponentsExtension.swift
//
//
//  Created by Elaine Ernst on 2019/07/31.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

extension URLComponents {
    
    init(service: ServiceProtocol) {
        let url = service.baseURL.appendingPathComponent(service.path)
        self.init(url: url, resolvingAgainstBaseURL: false)!
        
        guard case let .requestParameters(parameters) = service.task, service.parametersEncoding == .url else {
            return
        }
        
        queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: String(describing: value))
        }
    }
}
