//
//  NXDrawTableViewController.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/30/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit
import WYPopoverController
import IQAudioRecorderController
import RSKImageCropper
import ImagePicker

class NXDrawTableViewController: UIViewController {
    
    @IBOutlet weak var audioRecorder: UIBarButtonItem!
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
    
    
    @IBAction func didTapAudioRecordBtn(_ sender: AnyObject) {
        let recorderVC = IQAudioRecorderViewController()
        recorderVC.delegate = self
        recorderVC.maximumRecordDuration = 10 // unlimited ??
        recorderVC.barStyle = .blackTranslucent
        recorderVC.allowCropping = true
        recorderVC.audioFormat = IQAudioFormat._m4a
        
        self.presentBlurredAudioRecorderViewControllerAnimated(recorderVC)
    }
    
    
    @IBAction func didTapCameraButton(_ sender: Any) {
        let imagePickerVC = ImagePickerController()
        imagePickerVC.imageLimit = 1
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    @IBAction func dismissView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapEraserButton(_ sender: Any) {
        paletteView.currentBrush().color = UIColor.clear
        paletteView.currentBrush().width = 10
    }
    
    @IBAction func didTapPaletteButton(_ sender: AnyObject) {
        let paletteVC = self.storyboard?.instantiateViewController(withIdentifier: "PaletteVC") as! PaletteViewController
        paletteVC.preferredContentSize = CGSize(width: view.bounds.width, height: view.bounds.height/5)
        paletteVC.title = "Select Brush Color and Width"
        paletteVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        paletteVC.isModalInPopover = false
//        paletteVC.delegate = self
        paletteVC.paletteView = paletteView
        
        let contentVC = UINavigationController(rootViewController: paletteVC)
        
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
//        paletteView.delegate = self
//        paletteView.setup()
//        paletteView.alpha = 0
//        paletteView.width = 1 // ??
//        paletteView.isHidden = true
//        self.view.addSubview(paletteView)
        
        // TODO: load notes
    }
    
    private func generateCanvas() -> Canvas {
        let canvasView = Canvas()
        canvasView.layer.borderColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.8).cgColor
        canvasView.layer.borderWidth = 2.0
        canvasView.layer.cornerRadius = 5.0
        canvasView.clipsToBounds = true
        canvasView.delegate = self // delegate here?
        
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
    
    lazy var visibleCellPaths: [IndexPath] = {
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
        
        cell.delegate = self // cell delegate - delete
        cell.canvasView = canvasViews[indexPath.row]
//        cell.canvasView!.delegate = self
        cell.canvasDelegate = self  // TODO: canvas delegate
        cell.deleteButton.tag = indexPath.row
        
        return cell
    }
}

extension NXDrawTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension NXDrawTableViewController: ExtendedCanvasDelegate {
    
    func brush() -> Brush? {
        print("returning current brush from paletteView")
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

/*
extension NXDrawTableViewController: PaletteViewControllerDelegate {
    func retrieveAlpha(alpha: CGFloat) {
        print("retrieving alpha!")
        self.paletteView.currentBrush().alpha = alpha        
    }
    
    func retrieveColor(color: UIColor) {
        print("retrieving color: \(color)")
        self.paletteView.currentBrush().color = color
    }
    
    func retrieveWidth(width: CGFloat) {
        self.paletteView.currentBrush().width = width
    }
}
*/

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

extension NXDrawTableViewController: IQAudioRecorderViewControllerDelegate {
    
    func audioRecorderControllerDidCancel(_ controller: IQAudioRecorderViewController) {
        print("audio recorder canceled")
        controller.dismiss(animated: true, completion: nil)
    }
    
    func audioRecorderController(_ controller: IQAudioRecorderViewController, didFinishWithAudioAtPath filePath: String) {
        print("finished recording, filePath: \(filePath)")
        controller.dismiss(animated: true, completion: nil)
    }
}

extension NXDrawTableViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("wrapper did press, images.count: \(images.count)")
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        images.forEach {
            if let currentCanvasIndex = visibleCellPaths.first?.row {
                let currentCanvas = canvasViews[currentCanvasIndex]
                currentCanvas.update($0) // update the canvas with the selected image
            }
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        print("photo selection canceled")
    }
}
