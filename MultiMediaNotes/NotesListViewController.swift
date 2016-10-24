//
//  NotesListViewController.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/23/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController {

    var notes: [String] = [] // TODO: list of Note models, retrieved from database
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdNoImage = "NoteCellNoImage"
    let cellIdWithImage = "NoteCellWithImage"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        for i in 1..<10 {
            notes.append("Note Title \(i)")
        }
        
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "NoteListTableViewCellNoImage", bundle: nil), forCellReuseIdentifier: cellIdNoImage)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentSize = CGSize(width: tableView.frame.size.width, height: tableView.frame.size.height)
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
}

extension NotesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdNoImage, for: indexPath) as! NoteListTableViewCellNoImage
        
        cell.title.text = notes[indexPath.row]
        cell.dateUpdated.text = "10/22/2016"
        
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
