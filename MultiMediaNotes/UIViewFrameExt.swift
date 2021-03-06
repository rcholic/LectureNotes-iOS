//
//  UIViewFrameExt.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/30/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /**
     Get Set x Position
     
     - parameter x: CGFloat
     by DaRk-_-D0G
     */
    internal var x:CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    /**
     Get Set y Position
     
     - parameter y: CGFloat
     by DaRk-_-D0G
     */
    internal var y:CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    /**
     Get Set Height
     
     - parameter height: CGFloat
     by DaRk-_-D0G
     */
    internal var height:CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    /**
     Get Set Width
     
     - parameter width: CGFloat
     by DaRk-_-D0G
     */
    internal var width:CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
}
