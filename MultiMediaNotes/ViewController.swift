//
//  ViewController.swift
//  MultiMediaNotes
//
//  Created by Guoliang Wang on 10/15/16.
//  Copyright © 2016 iParroting.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var nums: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for i in 1...10 {
            nums.append(i * 10)
        }
        print("nums.size: \(nums.count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

