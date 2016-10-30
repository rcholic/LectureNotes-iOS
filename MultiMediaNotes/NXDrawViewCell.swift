//
//  NXDrawViewCell.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/30/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol NXDrawViewCellDelegate: class {
    func removeCell(cell: NXDrawViewCell, index: Int)
}

class NXDrawViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    weak var delegate: NXDrawViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
