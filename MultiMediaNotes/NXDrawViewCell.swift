//
//  NXDrawViewCell.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/30/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit
import SnapKit
import DKAudioPlayer

@objc protocol NXDrawViewCellDelegate: class {
    func removeCell(cell: NXDrawViewCell, index: Int)
}

class NXDrawViewCell: UITableViewCell {

//    @IBOutlet weak var viewContainer: UIView!
    var deleteButton: UIButton = UIButton(type: UIButtonType.custom)
    weak var delegate: NXDrawViewCellDelegate?
    weak var canvasView: Canvas?
    var recordings: [NoteAudio] = []
    weak var canvasDelegate:  ExtendedCanvasDelegate? // CanvasDelegate? //
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
    }
    
    override func layoutSubviews() {
        
        guard let canvasView = canvasView else { return }
        self.contentView.addSubview(canvasView)
        canvasView.delegate = canvasDelegate
        canvasView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.contentView)
            make.right.bottom.equalTo(self.contentView).offset(-10)
        }
        
        deleteButton.layer.borderColor = UIColor.clear.cgColor
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setBackgroundImage(UIImage(named: "btn_icon_sticker_delete"), for: .normal)
        
        deleteButton.addTarget(self, action: #selector(self.deleteCell(sender:)), for: .touchUpInside)

//        viewContainer.addSubview(deleteButton)
        self.contentView.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { (make) in
            make.top.equalTo(canvasView).offset(-6)
            make.right.equalTo(canvasView).offset(8)
        }
        
        recordings.forEach { _ in
            print("embedding player to cell")
            // below does not show up! "/Users/guoliangwang/Downloads/example.m4a"
            let player = DKAudioPlayer.init(audioFilePath: "/Users/guoliangwang/Downloads/example.m4a", width:260, height: 45)
            var numPlayer = 0
            for p in canvasView.subviews {
                if let _ = p as? DKAudioPlayer {
                    numPlayer += 1
                }
            }
            
            player!.frame = CGRect(x: 30, y: 70 + CGFloat(numPlayer * 275), width: CGFloat(260), height: 45)
            canvasView.addSubview(player!)
            player!.show(animated: true)
        }
        
        contentView.bringSubview(toFront: canvasView)
        contentView.bringSubview(toFront: deleteButton)
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
