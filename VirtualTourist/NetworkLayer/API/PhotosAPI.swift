//
//  PhotosApi.swift
//  VirtualTourist
//
//  Created by Elaine Ernst on 2019/10/01.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

enum PhotosAPI{
    case getPhotos(request: PhotoRequest)

}

extension PhotosAPI: ServiceProtocol{
    var baseURL: URL {
        switch self {
        case .getPhotos:
            return URL(string: NetworkManager.shared.baseUrl)!
        }
    }
    
    var path: String {
        switch self {
        case .getPhotos:
            return "/services/rest/"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPhotos:
            return .get
        }
    }
    
    var task: HTTPTask{
        switch self{
        case .getPhotos(let params):
            do{
                let param = try params.asDictionary()
                return .requestParameters(param)
                
            }
            catch{
                return .requestPlain
            }
        }
        
    }
    
    var parametersEncoding: ParametersEncoding {
        switch self {
        case .getPhotos:
            return .url
        }
    }
    
    var headers: Headers? {
        switch self{
        case .getPhotos:
            
            let headers = ["Content-Type": "application/json",
                           "Accept" : "application/json"]
            
            return headers
        }
    }
}

