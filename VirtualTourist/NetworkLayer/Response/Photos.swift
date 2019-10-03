//
//  Photos.swift
//  VirtualTourist
//
//  Created by Elaine Ernst on 2019/10/01.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

struct PhotoResponse: Codable {
    let photos: Photos
    let stat: String
    
}

struct Photos: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [CurrentPhoto]
}

struct CurrentPhoto: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    
    func photoURL() -> URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg")!
    }
    
}
