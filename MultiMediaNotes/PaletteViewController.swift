//
//  PaletteViewController.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/30/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit

@objc protocol PaletteViewControllerDelegate: class {
    func retrieveColor(color: UIColor)
    func retrieveAlpha(alpha: CGFloat)
    func retrieveWidth(width: CGFloat)
}

class PaletteViewController: UIViewController {
    weak var paletteView: Palette? // needs to be passed in
    weak var delegate: PaletteViewControllerDelegate? // needs to be passed in
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPalette()
        print("PaletteVC loaded!")
    }
    
    private func setupPalette() {
        self.view.backgroundColor = UIColor.white

        if paletteView == nil {
            paletteView = Palette()
        }
        paletteView!.setup()
        paletteView!.delegate = self
        self.view.addSubview(paletteView!)
        paletteView!.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(self.view)
        }
    }
}

// MARK: - PaletteDelegate
extension PaletteViewController: PaletteDelegate
{
    private func didChangeBrushColor(color: UIColor) {
        print("did change brush color: \(color)")
        delegate?.retrieveColor(color: color)
    }
    
    private func didChangeBrushAlpha(alpha: CGFloat) {
        delegate?.retrieveAlpha(alpha: alpha)
        print("did change brush alpha: \(alpha)")
    }
    
    private func didChangeBrushWidth(width: CGFloat) {
        delegate?.retrieveWidth(width: width)
        print("brush width: \(width)")
    }
    
    // tag can be 1 ... 12
    func colorWithTag(_ tag: NSInteger) -> UIColor? {
        if tag == 4 {
            // if you return clearColor, it will be eraser
            return UIColor.clear
        }
        return nil
    }
}
