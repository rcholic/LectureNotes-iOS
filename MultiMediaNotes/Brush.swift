//
//  Brush.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/30/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit

open class Brush: NSObject {
    open var color: UIColor = UIColor.black {
        willSet(colorValue) {
            color = colorValue
            isEraser = color.isEqual(UIColor.clear)
            blendMode = isEraser ? .clear : .normal
        }
    }
    open var width: CGFloat = 5.0
    open var alpha: CGFloat = 1.0
    
    internal var blendMode: CGBlendMode = .normal
    internal var isEraser: Bool = false
}
