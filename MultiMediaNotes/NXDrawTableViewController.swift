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

import DKAudioPlayer

//import Realm
import RealmSwift

class NXDrawTableViewController: UIViewController {
    
    @IBOutlet weak var audioRecorder: UIBarButtonItem!
    @IBOutlet weak var brushButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "DrawViewCell"
    let audioPlayerWidth: CGFloat = 260
    let audioPlayerHeight: CGFloat = 45
    let playerVGap: CGFloat = 15
    
    var popover: WYPopoverController? = .none
    var curNote: Note? = nil
    var paletteView: Palette = Palette()
    var canvasViews: [Canvas] = []
    var recordings: [NoteAudio] = [] // container for recorded audios
    var canvasImages: [UIImage] = []
    var curVisibleCellIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadNote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    @IBAction func didTapAddPageButton(_ sender: AnyObject) {
        let aCanvas = generateCanvas()
        canvasViews.append(aCanvas)
        tableView.reloadData()
        let indexPath = IndexPath(row: canvasViews.count-1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    
    @IBAction func didTapAudioRecordBtn(_ sender: AnyObject) {
        
        curVisibleCellIndex = tableView.visibleCells.endIndex
        curVisibleCellIndex = curVisibleCellIndex > 0 ? curVisibleCellIndex - 1 : 0
        
        let recorderVC = IQAudioRecorderViewController()
        recorderVC.delegate = self
        recorderVC.maximumRecordDuration = 10 // unlimited ??
        recorderVC.barStyle = .blackTranslucent
        recorderVC.allowCropping = true
        recorderVC.audioFormat = IQAudioFormat._m4a
        
        self.presentBlurredAudioRecorderViewControllerAnimated(recorderVC)
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        
        // save images for each canvas
        canvasImages = canvasViews.map {
            $0.save()
            return $0.image.asPNGImage()! //.asJPGImage(0.8)!
        }
        
        var note: Note
        if curNote == nil {
            note = Note()
            note.subject = "Note created at \(note.createdAt.description)"
        } else {
            note = curNote!
        }
        
        canvasImages.forEach {
            let noteImage = NoteImage()
            noteImage.image = $0
            noteImage.imageData = $0.asPNGData()! //.asJPEGData(0.8)!
            note.noteImages.append(noteImage)
        }
        
        recordings.forEach {
            note.recordings.append($0)
        }
        
        let realm = try! Realm()
        let isUpdate = curNote != nil
        try! realm.write {
            realm.add(note, update: isUpdate)
        }
    }
    
    @IBAction func didTapCameraButton(_ sender: Any) {
        curVisibleCellIndex = tableView.visibleCells.endIndex
        curVisibleCellIndex = curVisibleCellIndex > 0 ? curVisibleCellIndex - 1 : 0
        
        let imagePickerVC = ImagePickerController()
        imagePickerVC.imageLimit = 1
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    @IBAction func dismissView(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
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
    
    private func loadNote() {
        guard let note = curNote else { return }
        
        var count: Int = 0
        canvasViews = note.noteImages.map {
            let canvasView = Canvas(canvasId: count.description, backgroundImage: UIImage(data: $0.imageData))
            
            canvasView.layer.borderColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.8).cgColor
            canvasView.layer.borderWidth = 2.0
            canvasView.layer.cornerRadius = 5.0
            canvasView.clipsToBounds = true
            canvasView.delegate = self // delegate here?
            
            count += 1
            return canvasView
        }
        
        // add recordings to the container
        note.recordings.forEach {
            if let _ = $0.path {
                recordings.append($0) // append to the container for recordings
                print("recording path: \($0.path)")
//                // display recordings in their owning cells
//                if let audioPath = $0.path {
//                    // TODO: audioPath may not contain the audio!!
//                    let player = DKAudioPlayer.init(audioFilePath: "/Users/guoliangwang/Downloads/example.m4a", width:audioPlayerWidth, height: audioPlayerHeight)
//                    var numPlayer = 0
//                    let curCanvas = canvasViews[$0.cellIndex]
//                    for p in curCanvas.subviews {
//                        if let _ = p as? DKAudioPlayer {
//                            numPlayer += 1
//                        }
//                    }
//                    
//                    player!.frame = CGRect(x: 30, y: 70 + CGFloat(numPlayer) * (audioPlayerHeight + playerVGap), width: audioPlayerWidth, height: audioPlayerHeight)
//                    
//                    curCanvas.addSubview(player!)
//                    player!.show(animated: true)
//                }
            }
        }
        
        self.tableView.reloadData()
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
    
    private func promptForTitle(callback blockFunc: @escaping () -> Void) {
        
        OperationQueue.main.addOperation { 
            blockFunc()
        }
        
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
    
//    lazy var visibleCellPaths: [IndexPath] = {
//        let paths = self.tableView.indexPathsForVisibleRows ?? [IndexPath]()
//
//        print("paths.count: \(paths.count)")
//        paths.forEach {
//            print("visible index: \($0)")
//        }
//        
//        return paths
//    }()
    
//    lazy var visibleCellIndex: Int = {
//        var endIndex = self.tableView.visibleCells.endIndex
//        endIndex = endIndex > 0 ? endIndex - 1 : 0
//        return endIndex
//    }()
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
        let cellAudios = recordings.filter {
            return $0.cellIndex == indexPath.row
        }
//        cell.canvasView!.delegate = self
        cell.recordings = cellAudios
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
        print("did update drawing delegate called!, image size: \(image?.size), drawing: \(drawing.background?.size)")
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
        let recording = NoteAudio()
        recording.name = "Recording \(recordings.count + 1)"
        recording.path = filePath
        recording.cellIndex = curVisibleCellIndex // cell this recording belongs to
        recordings.append(recording) // add the recording
        
        controller.dismiss(animated: true, completion: nil)
        
        let visibleCanvas = canvasViews[curVisibleCellIndex]
        let player = DKAudioPlayer.init(audioFilePath: filePath, width:audioPlayerWidth, height: audioPlayerHeight)
        
        var numPlayer = 0
        for p in visibleCanvas.subviews {
            if let _ = p as? DKAudioPlayer {
                numPlayer += 1
            }
            print("numPlayer: \(numPlayer)")
        }
        
        player!.frame = CGRect(x: 30, y: 70 + CGFloat(numPlayer) * (audioPlayerHeight + playerVGap), width: audioPlayerWidth, height: audioPlayerHeight)
        
        visibleCanvas.addSubview(player!)
        
        player!.show(animated: true)
        player!.play()
    }
}

extension NXDrawTableViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("wrapper did press, images.count: \(images.count)")
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        if let selectedPhoto = images.first {
            let cropper = RSKImageCropViewController(image: selectedPhoto, cropMode: .square) // square cropper
            cropper.delegate = self
            self.present(cropper, animated: true, completion: nil)
        }
        // TODO: merge photos as a grid ??
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        print("photo selection canceled")
    }
}

extension NXDrawTableViewController: RSKImageCropViewControllerDelegate {
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
//        self.canvasView?.update(croppedImage)
        
        let currentCanvas = canvasViews[curVisibleCellIndex]
        currentCanvas.update(croppedImage) // update the canvas with the cropped image
    
        controller.dismiss(animated: true, completion: nil)
    }
}
