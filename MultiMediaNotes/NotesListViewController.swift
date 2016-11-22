//
//  NotesListViewController.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/23/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit
import RealmSwift

class NotesListViewController: UIViewController {

    var notes: [Note] = [] // TODO: list of Note models, retrieved from database
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdNoImage = "NoteCellNoImage"
    let cellIdWithImage = "NoteCellWithImage"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
//        for i in 1..<10 {
//            notes.append("Note Title \(i)")
//        }
        
        setupTableView()
        loadNotes()
    }
    
    func setupTableView() {
        automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib(nibName: "NoteListTableViewCellNoImage", bundle: nil), forCellReuseIdentifier: cellIdNoImage)
        tableView.register(UINib(nibName: "NoteListTableViewCellWithImage", bundle: nil), forCellReuseIdentifier: cellIdWithImage)
        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.contentSize = CGSize(width: tableView.frame.size.width, height: tableView.frame.size.height)
        tableView.tableFooterView = UIView() // remove separator in empty cells
        tableView.estimatedRowHeight = 185.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    func setupUI() {
        // set up nav bar
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0, green: 0.24, blue: 0.45, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.title = "Lecture Notes"
        let textShadow = NSShadow()
        textShadow.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        textShadow.shadowOffset = CGSize(width: 0, height: 1)
        let fontAttr = UIFont(name: "HelveticaNeue-CondensedBlack", size: 25)
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(objects: [UIColor.white, textShadow, fontAttr!], forKeys: [NSForegroundColorAttributeName as NSCopying, NSShadowAttributeName as NSCopying, NSFontAttributeName as NSCopying]) as? [String : AnyObject]
    }
    
    func loadNotes() {
        let realm = try! Realm()
        notes = Array(realm.objects(Note.self)) // cast Results<Note> to [Note] array
        self.tableView.reloadData()
        
        
//        let savedNotes = realm.objects(Note.self)
//        savedNotes.forEach {
//            print("note subject: \($0.subject ?? "No subject")")
//            
//        }
    }
}

extension NotesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: create an interface for both Cell type: No Image and with image
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdWithImage, for: indexPath) as! NoteListTableViewCellWithImage
        let curNote = notes[indexPath.row]
//        cell.title.text = curNote.subject
//        cell.dateUpdated.text = "\(curNote.updatedAt)"
//        print("number of images: \(curNote.noteImages.count)")
//        curNote.noteImages.forEach {
//            print("desc: \($0.imageData.description)")
//        }
//        if let first = curNote.noteImages.first {
//            cell.firstImage.image = UIImage(data: first.imageData)
//        }
        cell.bind(note: curNote)
        
        return cell
    }
    
    
}

extension NotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNote = notes[indexPath.row]
        print("selected note: \(selectedNote)")
        // TODO: perform segue
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
