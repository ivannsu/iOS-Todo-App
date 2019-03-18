//
//  AddTodoViewController.swift
//  iOS Todo App
//
//  Created by Ivan Su on 3/18/19.
//  Copyright © 2019 Ivan Su. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        print(titleTextField.text!)
    }

}
