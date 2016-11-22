//
//  NoteImage.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 11/21/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
import RealmSwift

class NoteImage: Object {
    var image: UIImage = UIImage()
    dynamic var imageData: Data = Data()
    
    override static func ignoredProperties() -> [String] {
        return ["image"]
    }
}
