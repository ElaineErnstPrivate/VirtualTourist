//
//  Result.swift
//
//  Created by Elaine Ernst on 2019/08/16.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation


enum Result<T, E: Error>{
    case success(T)
    case failure(E)
}
