//
//  PhotoRequest.swift
//  VirtualTourist
//
//  Created by Elaine Ernst on 2019/10/01.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

struct PhotoRequest: Codable{
    let method: String
    let api_key: String
    let lat: Double
    let lon: Double
    let format: String
    let nojsoncallback: String
    let per_page: Int
    let page : Int
}

