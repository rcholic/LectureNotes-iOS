//
//  NoteListTableViewCellNoImage.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/23/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit

class NoteListTableViewCellNoImage: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dateUpdated: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
