//
//  NetworkError.swift
//  
//
//  Created by Elaine Ernst on 2019/07/31.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case connectivityError
    case unknownError
    case apiError(code: Int, message: String)
    case timeout
    case serviceUnavailable
    case custom(message: String)
    case cancelled
    case invalidData
    public var description: String {
        
        switch self {
        case .connectivityError:
            return "You have no connectivity. Please connect to the Internet and try again."
        case .unknownError:
            return "An unexpected error has occurred"
        case .apiError(_, let message):
            return message
        case .invalidData:
            return "Unable to parse data"
        case .timeout:
            return "The operation has timed out. Check your internet connection and try again."
        case .serviceUnavailable:
            return "Service is currently unavailable. Please try again later."
        case .custom(let message):
            return message
        case .cancelled:
            return "The request was cancelled."
        }
        
    }
    
}
