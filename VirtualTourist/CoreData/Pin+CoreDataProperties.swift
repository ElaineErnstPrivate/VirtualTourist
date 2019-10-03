//
//  Pin+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Elaine Ernst on 2019/10/03.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitute: Double
    @NSManaged public var longitude: Double
    @NSManaged public var urls: String?
    @NSManaged public var createdDate: NSDate?
    @NSManaged public var image: NSSet?

}

// MARK: Generated accessors for image
extension Pin {

    @objc(addImageObject:)
    @NSManaged public func addToImage(_ value: Photo)

    @objc(removeImageObject:)
    @NSManaged public func removeFromImage(_ value: Photo)

    @objc(addImage:)
    @NSManaged public func addToImage(_ values: NSSet)

    @objc(removeImage:)
    @NSManaged public func removeFromImage(_ values: NSSet)

}
