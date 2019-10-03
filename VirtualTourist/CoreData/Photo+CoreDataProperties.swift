//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Elaine Ernst on 2019/10/03.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var imageData: NSData?
    @NSManaged public var url: String?
    @NSManaged public var pin: Pin?

}
