//
//  NoteListTableViewCellWithImage.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/23/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit

let dateFormatter = DateFormatter()
class NoteListTableViewCellWithImage: UITableViewCell {

    @IBOutlet weak var firstImage: UIImageView!
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
    
    func bind(note: Note) {
        self.title.text = note.subject ?? "No subject"
        let date = dateFormatter.string(from: note.updatedAt as Date)
        self.dateUpdated.text = "\(date)" // TODO: display short date format: yyyy-MM-DD
        if let first = note.noteImages.first {
            firstImage.image = UIImage(data: first.imageData, scale: 1.0)
        }
    }
    
}
