//
//  Note.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/23/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
import CoreData

@objc class Note: NSManagedObject {
    @NSManaged var updatedAt: NSDate
    @NSManaged var createdAt: NSDate
    @NSManaged var remindDate: NSDate?
    @NSManaged var subject: String
    //    @NSManaged var drawImages: [DrawViewImage]
    //    @NSManaged var drawing: DrawView
    @NSManaged var drawnImages: [NSData] // NSMutableArray
    
}
