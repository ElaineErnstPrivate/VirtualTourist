//
//  HTTPTask.swift
//
//  Created by Elaine Ernst on 2019/07/19.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

typealias Parameters = [String: Any]

enum HTTPTask{
    case requestPlain
    case requestParameters(Parameters)
}
