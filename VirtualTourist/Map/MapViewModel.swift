//
//  MapViewModel.swift
//  VirtualTourist
//
//  Created by Elaine Ernst on 2019/10/01.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation
import MapKit
import CoreData
class ViewModel{
    static let shared = ViewModel()
  
    let manager = URLSessionProvider()
    var annotation = CLLocationCoordinate2D()
    var mapPins : [MKAnnotation] = []
    
    var pins : [Pin] = []
    var currentPin: Pin!
    var photosFromFlickr : PhotoResponse?
    var photos : [Photos] = []
   
    func getPhotos(page: Int? = 1 ,handler: @escaping(_ success: Bool ,_ error: NetworkError?) -> Void) {
        let request = PhotoRequest(method: "flickr.photos.search", api_key: NetworkManager.shared.uniqueKey, lat: annotation.latitude, lon: annotation.longitude, format: "json", nojsoncallback: "1",per_page: 12, page: page!)
        self.manager.request(type: PhotoResponse.self, service: PhotosAPI.getPhotos(request: request)) { response in
            switch response {
            case .success(let photos):
                
                self.photosFromFlickr = photos
                DispatchQueue.main.async {
                    handler(true, nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    handler(false ,error)
                }
            }
        }
    }
    
    func downloadImages(photoUrl: URL, handler: @escaping(_ success: Data? ,_ error: Error?) -> Void){
        self.manager.requestDownloadData(url: photoUrl) { (data, error) in
           
            if let error = error {
                handler(nil, error)
            }
            else{
                guard let photoData = data else{
                    return
                }
                handler(photoData, nil)
                print("DATA: ", photoData)
            }
        }
    }
}
