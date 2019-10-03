//
//  NetorkManager.swift
//
//  Created by Elaine Ernst on 2019/09/02.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

class NetworkManager{
    
    static let shared = NetworkManager()
    var baseUrl : String = "https://www.flickr.com"
    var secretKey: String = "bca3db7734f7631a"
    var uniqueKey : String = "deafb48b1d626e75a884c0328e95d991"
   
    func configureNetworkLayer(baseUrl: String){
        self.baseUrl = baseUrl
    }
}
