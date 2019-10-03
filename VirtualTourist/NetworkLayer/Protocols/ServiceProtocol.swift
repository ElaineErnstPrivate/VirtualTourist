//
//  URLSessionProtocol.swift
//  FutureBankSDK
//
//  Created by Elaine Ernst on 2019/07/19.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

 typealias Headers = [String: String]

 enum ParametersEncoding {
    case url
    case json
}

 protocol ServiceProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: Headers? { get }
    var parametersEncoding: ParametersEncoding { get }
}
