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
    var deleteButton: UIButton = UIButton(type: UIButtonType.custom)
    weak var delegate: NXDrawViewCellDelegate?
    weak var canvasView: Canvas?
    weak var canvasDelegate: ExtendedCanvasDelegate? // CanvasDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        
        guard let canvasView = canvasView else { return }
        self.viewContainer.addSubview(canvasView)
        canvasView.delegate = canvasDelegate
        canvasView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.contentView)
            make.right.bottom.equalTo(self.contentView).offset(-10)
        }
        
        deleteButton.layer.borderColor = UIColor.clear.cgColor
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setBackgroundImage(UIImage(named: "btn_icon_sticker_delete"), for: .normal)
        
        deleteButton.addTarget(self, action: #selector(self.deleteCell), for: .touchUpInside)

        viewContainer.addSubview(deleteButton)
        
        //        canvasView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.top.equalTo(canvasView).offset(-6)
            make.right.equalTo(canvasView).offset(8)
        }
        
        viewContainer.bringSubview(toFront: deleteButton)        
    }
    
    @objc private func deleteCell(sender: AnyObject) {
        print("about to delete cell!")
        if let button = sender as? UIButton {
            print("sender button index: \(button.tag)")
            delegate?.removeCell(cell: self, index: button.tag)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
