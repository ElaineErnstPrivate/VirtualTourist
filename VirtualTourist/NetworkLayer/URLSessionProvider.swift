//
//  URLSessionProvider.swift
//
//  Created by Elaine Ernst on 2019/07/19.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation
import UIKit
open class URLSessionProvider:NSObject, ProviderProtocol, URLSessionDelegate{
    
    var session: URLSessionProtocol
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = URLSession(configuration: .default, delegate: URLSession.shared.delegate, delegateQueue: nil)
        super.init()
    }
    
    func connection(session: URLSession, canAuthenticateAgainstProtectionSpace protectionSpace: URLProtectionSpace?) -> Bool {
        return true
    }
    
    func request<T>(type: T.Type, service: ServiceProtocol, completion: @escaping (Result<T, NetworkError>) -> ()) where T: Decodable {
    
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)

        let request = URLRequest(service: service)
        logRequest(request: request)
    
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            let httpResponse = response as? HTTPURLResponse
            self.handleDataResponse(data: data, response: httpResponse, error: error, completion: completion)
        }
        task.resume()
    }
    
    func requestDownloadData(url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        
        let downloadTask = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            // guard there is data
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let downloadedImage: UIImage? = UIImage(data: data)
            
            guard let image = downloadedImage else {
                completionHandler(nil, error)
                return
            }
            
            
            let imageData = UIImage.pngData(image)
            completionHandler(imageData(), nil)
        })
        downloadTask.resume()
        
    }
    private func logRequest(request: URLRequest){
        print("🚀 \(String(describing: request.httpMethod)): \(String(describing: request.url))")
        
        if let headers = request.allHTTPHeaderFields {
            
            print("Request Headers")
            print(headers)
            print("")
            
        }
        
        if let body = request.httpBody {
            if let bodyText = String(data: body, encoding:String.Encoding.utf8) {
                print("HTTP Body")
                print(bodyText)
                print("")
            }
        }
    }
    private func handleDataResponse<T: Decodable>(data: Data?, response: HTTPURLResponse?, error: Error?, completion: (Result<T, NetworkError>) -> ()) {
        if error != nil{
            completion(.failure(.connectivityError))
        }
        guard let response = response else {
            return completion(.failure(.unknownError))
        }
        self.logResponse(data, response: response, error: error)

        
        switch response.statusCode {
        case 200...299:
            
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            if let model = try? JSONDecoder().decode(T.self, from: data){
                completion(.success(model))
            }
            else if let model = try? JSONDecoder().decode(T.self, from: newData) {
                completion(.success(model))
            }
                
            else{
                return completion(.failure(.invalidData))

            }
         
        case 401...500:
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            completion(.failure(self.getApiError(data: data) ?? .unknownError))
        default:
            completion(.failure(.unknownError))
            
        }
    }
    
    private func logResponse(_ data: Data?, response: URLResponse?, error: Error?) {
        
        if let response = response as? HTTPURLResponse {
            print("Status Code")

            print(response.statusCode)
            print("")
            
            print("Response Headers")
            print(response.allHeaderFields)
            print("")
            
        }
        
        if let data = data {
            do {
                print(String(data: data, encoding: .utf8)!)
                let responseObject = try JSONSerialization.jsonObject(with: data, options: [])
                let data = try JSONSerialization.data(withJSONObject: responseObject, options: .prettyPrinted)
                let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print("Response Data")
                print(string ?? "")
               print("")
                
            }
            catch { }
        }
        
        if let error = error {
            
            print("HTTP Error")
            print(error)
            print("")
            
        }
        
    }
    private func getApiError(data: Data) -> NetworkError? {
        let range = (5..<data.count)
        let newData = data.subdata(in: range)
        if let error = try? JSONDecoder().decode(ErrorResponse.self, from: data){
            return .apiError(code:error.status, message: error.error)
        }
        else if let error = try? JSONDecoder().decode(ErrorResponse.self, from: newData) {
            return .apiError(code:error.status, message: error.error)
        }
        else{
            return .unknownError

        }
    }
}

