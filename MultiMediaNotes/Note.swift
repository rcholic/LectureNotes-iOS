//
//  Note.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/23/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
import CoreData
import RealmSwift

//@objc class Note: NSManagedObject {
//    @NSManaged var updatedAt: NSDate
//    @NSManaged var createdAt: NSDate
//    @NSManaged var remindDate: NSDate?
//    @NSManaged var subject: String
//    //    @NSManaged var drawImages: [DrawViewImage]
//    //    @NSManaged var drawing: DrawView
//    @NSManaged var drawnImages: [NSData] // NSMutableArray
//    
//}

class Note: Object {
    dynamic var updatedAt: NSDate = NSDate()
    dynamic var createdAt: NSDate = NSDate()
    dynamic var subject: String? = nil
    var drawnImages: [UIImage] = []
    dynamic var imageData: [Data] = []
//    dynamic var imageData = List<NSData>() // checkout: https://realm.io/docs/swift/latest/#to-many-relationships
    
    override static func ignoredProperties() -> [String] {
        return ["drawnImages"]
    }
}
