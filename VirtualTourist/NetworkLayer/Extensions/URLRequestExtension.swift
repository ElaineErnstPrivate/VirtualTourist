//
//  URLRequestExtension.swift
//
//  Created by Elaine Ernst on 2019/07/31.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

extension URLRequest {
    
    init(service: ServiceProtocol) {
        let urlComponents = URLComponents(service: service)
        
        self.init(url: urlComponents.url!)
        httpMethod = service.method.rawValue
        service.headers?.forEach { key, value in
            addValue(value, forHTTPHeaderField: key)
        }
        
        guard case let .requestParameters(parameters) = service.task, service.parametersEncoding == .json else {
            return
        }
        httpBody = try? JSONSerialization.data(withJSONObject: parameters)
    }
}
