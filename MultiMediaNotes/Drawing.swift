//
//  Drawing.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/30/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit

open class Drawing: NSObject {
    open var stroke: UIImage?
    open var background: UIImage?
    
    public init(stroke: UIImage? = nil, background: UIImage? = nil) {
        self.stroke = stroke
        self.background = background
    }
}
