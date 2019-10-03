//
//  ProviderProtocol.swift
//  FutureBankSDK
//
//  Created by Elaine Ernst on 2019/07/31.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

protocol ProviderProtocol {
    func request<T>(type: T.Type, service: ServiceProtocol, completion: @escaping (Result<T, NetworkError>) -> ()) where T: Decodable
}
