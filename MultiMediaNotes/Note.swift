//
//  Note.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/23/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
//import CoreData
import RealmSwift

class Note: Object {
    dynamic var updatedAt: NSDate = NSDate()
    dynamic var createdAt: NSDate = NSDate()
    dynamic var subject: String? = nil
    var drawnImages: [UIImage] = []
    let noteImages = List<NoteImage>()
    
    let recordings = List<NoteAudio>() // recorded audio paths
//    dynamic var imageData = List<NSData>() // checkout: https://realm.io/docs/swift/latest/#to-many-relationships
    
    override static func ignoredProperties() -> [String] {
        return ["drawnImages"]
    }
}
