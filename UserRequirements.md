# iOS App - Multimedia Lecture Notes
## In Fulfillment of Georgia Tech CS6460 Course Requirements
## Author: Guoliang Wang (gwang89@gatech.edu)


## Revision History
| Rev. #        | Date          |  Revision Summary  |
| ------------- |:-------------:| :------------------|
| N/A           | N/A           | N/A                |


## Table Of Contents

1. Introduction
2. Program Requirements
   * User Interfaces
   * Data Storage
3. Life Cycle Requirements
   * Architecture Design
   * Development
   * Testing
   * Delivery

### 1. Introduction
 To help students take lecture notes more effectively, I create this iOS-based app for students to take notes through multimedia such as charts, free text handwriting, recording lecture audio/video clips and taking pictures.

 The multimedia format allows students to take notes with more dimensions of information. The app aims to help students organize media files by lecture and/or dates, users need not to spend time
 organizing media files for the lecture notes. Furthermore, the media files can be stored on the
 iOS device or the Apple `iCloud`.

### 2. Program Requirements
* 2.1 User Interfaces

 The main user interface (UI, hereafter) uses the `UITableView` class as provided in the iOS UIKit for displaying the notes by title or the creation date in each table cell (`UITableViewCell`). This table view supports notes search and sorting by title and date. Furthermore, the user will be able to delete notes in this main user interface view, and users may tap on the `Add` button on this interface to create a new note.

 The UI for creating lecture notes uses the same `UITableView` and `UITableViewCell` classes, however, each table cell will load a custom view named `DrawView` that supports user handwriting and inserting media files. Each table view cell will be represented as a page, because the height of the `DrawView` is the same as the height of the iOS device screen, and users can use their fingertips to tap/scroll down the note pages. They can also add/remove pages as needed. At the bottom and the top of this UI, there will be tools/buttons for users to perform the following operations:

    * Adjust the stroke width and color of the brush/pencil
    * Eraser to remove unwanted handwriting
    * Add or delete a page in the notes
    * Take pictures on the iOS device camera for inserting into the note
    * Select pictures from their iOS device album for inserting into the note
    * Delete inserted pictures
    * Record voice/video and insert the recording to the note
    * Drag the media anywhere on the note for better organization

* 2.1.1 User Stories
    - a. As a user, I can open the Lecture Notes App by tapping on the app icon. Once the App is open, I can view the list of saved lecture notes, and I see the following options at the navigation bar: 1. Edit, 2. Add.

    - b. As a user, when I tap on a note title, the screen will redirect to the note detail page, where I can see free text drawing, pictures, and icons for playing the recorded audio/video (if any). When I tap on the play button for playing audio or video, the screen will start playing the media. I do not need to open the audio and video in another app.
    

* 2.2 Data Storage

This iOS app uses the `CoreData` for data storage by default, and it allows users to save the notes with the associated media files in their **iCloud** account. The app uses the *MVC* architecture pattern and, therefore a `LectureNote` class will be created for modeling the lecture notes and its association relationships with media files. Both notes and the associated media files are stored in the binary data format, and the association of note to media files will be one-to-many.


### 3. Life Cycle Requirements
* 3.1 Architecture Design

This app uses *MVC* architecture pattern for the three layers: model, view, and controller. The version of the `Swift` language is 3.0, and wherever appropriate, the reactive version `RxSwift` will be used for facilitating user interaction and the program work flow.

* 3.2 Development

Implementation of this app will be modular, and the following modules will be implemented in a sequential order:

        * 3.2.1 DrawView: An extension of the iOS UIView for tracking user's handwriting by translating  tapping to connected `UIBezierPath`.
        * 3.2.2 Notes Table View: This is the list of persisted notes with their title or date of creation displayed, which extends from the iOS `UITableView` and `UITableViewCell` classes.
        * 3.2.3 Notes Creation View: This is a list of `DrawView` in the form of `UITableView`, each cell in the `UITableView` has a `DrawView` embedded, which simulates pages visually.

* 3.3 Testing

Unit tests will be implemented for each custom UIView class in `Swift`.

* 3.4 Delivery

Upon completion of the implementation and testing, the app will be available for download from [this repo page](https://github.com/rcholic/LectureNotes-iOS), and the user can build and run the app in `XCode 8` or above.
