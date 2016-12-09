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
    var selectedNote: Note? = nil
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    let cellIdNoImage = "NoteCellNoImage"
    let cellIdWithImage = "NoteCellWithImage"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    @IBAction func didTapAddNoteButton(_ sender: Any) {
        
        let targetVC = self.storyboard?.instantiateViewController(withIdentifier: "NoteDetailBoard") as! NXDrawTableViewController
        
        targetVC.curNote = nil
        self.navigationController?.pushViewController(targetVC, animated: true) // TODO: remove the code redundancy
        
    }
    
    @IBAction func didTapEditButton(_ sender: Any) {

        if (self.tableView.isEditing) {
            self.setEditing(false, animated: true)
            self.editButton.title = "Edit"
            self.editButton.style = .plain
        } else {
            self.setEditing(true, animated: true)
            self.editButton.title = "Done"
            self.editButton.style = .done
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    func loadNotes() {
//        FileManager.default.removeItem(atPath: <#T##String#>)
        let realm = try! Realm()
        notes = Array(realm.objects(Note.self)) // cast Results<Note> to [Note] array
        self.tableView.reloadData()
    }
    
    func confirmDeleteNote(index: Int) {
        
        guard index >= 0 && index < notes.count else { return }
        
        
        let alert = UIAlertController(title: "Confirmation", message: "The deletion of the selected note is NOT reversible", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { _ in
            print("deleting note at index number: \(index)")
            let realm = try! Realm()
            realm.beginWrite()
            realm.delete(self.notes[index])
            try! realm.commitWrite()
            self.notes.remove(at: index)
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("deleting the cell index: \(indexPath.row)")
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            print("insert into row: \(indexPath.row)")
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
            
            self.notes.remove(at: indexPath.row)
            self.confirmDeleteNote(index: indexPath.row)
        })
        
        return [delete]
    }
}

extension NotesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNote = notes[indexPath.row]
//        print("selected note: \(selectedNote)")
        // TODO: perform segue
        let targetVC = self.storyboard?.instantiateViewController(withIdentifier: "NoteDetailBoard") as! NXDrawTableViewController
        targetVC.curNote = selectedNote
        self.navigationController?.pushViewController(targetVC, animated: true)
        
        selectedNote = nil
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
