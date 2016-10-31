//
//  NXDrawTableViewController.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/30/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit
import WYPopoverController

class NXDrawTableViewController: UIViewController {

    
    @IBOutlet weak var brushButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "DrawViewCell"
    var popover: WYPopoverController? = .none
    var curNote: Note? = nil
    var paletteView: Palette = Palette()
    var canvasViews: [Canvas] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    @IBAction func didTapAddPageButton(_ sender: AnyObject) {
        canvasViews.append(generateCanvas())
        tableView.reloadData()
        let indexPath = IndexPath(row: canvasViews.count-1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @IBAction func dismissView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapPaletteButton(_ sender: AnyObject) {
        let paletteVC = self.storyboard?.instantiateViewController(withIdentifier: "PaletteVC") as! PaletteViewController
        paletteVC.preferredContentSize = CGSize(width: view.bounds.width, height: view.bounds.height/5)
        paletteVC.title = "Select Brush Color and Width"
        paletteVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        paletteVC.isModalInPopover = false
        paletteVC.delegate = self
        
//        self.present(paletteVC, animated: true, completion: nil)
        
        let contentVC = UINavigationController(rootViewController: paletteVC) // or palleteVC ?
        
        if popover == nil {
            // pass thru
            popover = WYPopoverController(contentViewController: contentVC)
            // popover.passthroughViews = [btn!]
            popover!.theme = WYPopoverTheme.forIOS7()
            popover!.beginThemeUpdates()
//            popover!.theme.outerShadowColor = MaterialColor.deepOrange.accent2
            popover!.theme.outerShadowColor = UIColor.lightGray
            popover!.theme.outerShadowOffset = CGSize(width: 0, height: 0)
            popover!.theme.outerShadowColor = UIColor.black
            popover!.theme.borderWidth = 3
//            popover!.theme.fillTopColor = MaterialColor.orange.base
//            popover!.theme.fillBottomColor = MaterialColor.orange.base
            popover!.endThemeUpdates()
            
            popover!.popoverContentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height/3)
            popover!.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
            popover!.delegate = self
        }
        
        popover!.presentPopover(from: brushButton, permittedArrowDirections: .up, animated: true, options: .fadeWithScale)
    }
    
    private func setupUI() {
        paletteView.delegate = self
        paletteView.setup()
        paletteView.alpha = 0
        paletteView.isHidden = true
        self.view.addSubview(paletteView)
        
        // TODO: load notes
    }
    
    private func generateCanvas() -> Canvas {
        let canvasView = Canvas()
        canvasView.layer.borderColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.8).cgColor
        canvasView.layer.borderWidth = 2.0
        canvasView.layer.cornerRadius = 5.0
        canvasView.clipsToBounds = true
        canvasView.delegate = self
        
        return canvasView
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: "NXDrawViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        tableView.rowHeight = 430 // UITableViewAutomaticDimension;
        // tableView.estimatedRowHeight = 400 // TODO: change this to global
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.separatorStyle = .none
        tableView.contentSize = self.view.bounds.size
        tableView.bounces = false // disable the bounce
        tableView.bouncesZoom = false
        tableView.allowsSelection = false
        
        // tableView.scrollEnabled = false // disable scroll
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private lazy var visibleCellPaths: [IndexPath] = {
        let paths = self.tableView.indexPathsForVisibleRows ?? [IndexPath]()

        print("paths.count: \(paths.count)")
        paths.forEach {
            print("visible index: \($0)")
        }
        
        return paths
    }()
}

extension NXDrawTableViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return canvasViews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NXDrawViewCell
        
        cell.delegate = self // TODO: cell delegate - delete
        cell.canvasView = canvasViews[indexPath.row]
        cell.canvasDelegate = self  // TODO: canvas delegate
        cell.deleteButton.tag = indexPath.row
        
        return cell
    }
}

extension NXDrawTableViewController: UITableViewDelegate {
    // TODO: implement the delegate for table
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension NXDrawTableViewController: ExtendedCanvasDelegate {
    
    func brush() -> Brush? {
        return self.paletteView.currentBrush()
    }
    
    func canvas(_ canvas: Canvas, didUpdateDrawing drawing: Drawing, mergedImage image: UIImage?) {
//        self.updateToolbar(canvas) // TODO:
    }
    
    func canvas(_ canvas: Canvas, didSaveDrawing drawing: Drawing, mergedImage image: UIImage?) {
        
        // you can save merged image
        //        if let pngImage = image?.asPNGImage() {
        //            UIImageWriteToSavedPhotosAlbum(pngImage, self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        //        }
        
        // you can save strokeImage
        //        if let pngImage = drawing.stroke?.asPNGImage() {
        //            UIImageWriteToSavedPhotosAlbum(pngImage, self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        //        }
        
        //        self.updateToolBarButtonStatus(canvas)
        
        // you can share your image with UIActivityViewController
        if let pngImage = image?.asPNGImage() {
            let activityViewController = UIActivityViewController(activityItems: [pngImage], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func viewDrawStartedDrawing() {
        print("Started Drawing")
        tableView.isScrollEnabled = false
    }
    
    func viewDrawEndedDrawing() {
        print("Ended Drawing")
        tableView.isScrollEnabled = true
    }
    
}

extension NXDrawTableViewController: NXDrawViewCellDelegate {
    func removeCell(cell: NXDrawViewCell, index: Int) {
        print("removing draw view cell at index \(index)")
        let _ = canvasViews.remove(at: index)
        let deleted = IndexPath(item: index, section: 0)
        tableView.deleteRows(at: [deleted], with: .fade)
        tableView.reloadData()
    }
}

extension NXDrawTableViewController: PaletteDelegate {
    func didChangeBrushColor(_ color: UIColor) {
        paletteView.currentBrush().color = color
    }
    
    func didChangeBrushAlpha(_ alpha: CGFloat) {
        paletteView.currentBrush().alpha = alpha
    }
    
    func didChangeBrushWidth(_ width: CGFloat) {
        paletteView.currentBrush().width = width
    }
    
    func colorWithTag(tag: NSInteger) -> UIColor? {
        if tag == 4 {
            return UIColor.clear
        }
        return nil
    }
}

extension NXDrawTableViewController: PaletteViewControllerDelegate {
    func retrieveAlpha(alpha: CGFloat) {
        self.paletteView.currentBrush().alpha = alpha
        
    }
    
    func retrieveColor(color: UIColor) {
        self.paletteView.currentBrush().color = color
    }
    
    func retrieveWidth(width: CGFloat) {
        self.paletteView.currentBrush().width = width
    }
}

extension NXDrawTableViewController: WYPopoverControllerDelegate {
    
    func popoverControllerShouldDismissPopover(popoverController: WYPopoverController!) -> Bool {
        return true
    }
    
    func popoverControllerDidDismissPopover(popoverController: WYPopoverController!) {
        print("popover dismissed")
    }
    
    //    func addObserver(observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions, context: UnsafeMutablePointer<Void>) {
    //        <#code#>
    //    }
    
}

