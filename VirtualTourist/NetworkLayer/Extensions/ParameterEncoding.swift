//
//  ParameterEncoding.swift
//  FutureBankSDK
//
//  Created by Elaine Ernst on 2019/07/31.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
