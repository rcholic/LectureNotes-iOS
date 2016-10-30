//
//  UIImageExtractExt.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/30/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit

public extension UIImage {
    public func asPNGData() -> Data? {
        return UIImagePNGRepresentation(self)
    }
    
    public func asJPEGData(_ quality: CGFloat) -> Data? {
        return UIImageJPEGRepresentation(self, quality);
    }
    
    public func asPNGImage() -> UIImage? {
        if let data = self.asPNGData() {
            return UIImage.init(data: data)
        }
        
        return nil
    }
    
    public func asJPGImage(_ quality: CGFloat) -> UIImage? {
        if let data = self.asJPEGData(quality) {
            return UIImage.init(data: data)
        }
        
        return nil
    }
}
