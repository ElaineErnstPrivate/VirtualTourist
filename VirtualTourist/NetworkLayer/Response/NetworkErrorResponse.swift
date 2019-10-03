//
//  NetworkErrorResponse.swift
//
//  Created by Elaine Ernst on 2019/07/31.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable  {
    
     var status: Int
     var error: String
}
