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
    
    var delegate: TodoViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        /*
         navigationController?.viewControllers -> [UINavigationController]
         navigationController?.viewControllers.remove(at: index)
         navigationController?.viewControllers.removeLast()
        */
        
        if titleTextField.text == "" {
            print("Title is empty!")
        } else {
            delegate?.receiveNewItemData(title: titleTextField.text!)
            navigationController?.viewControllers.removeLast()
            print("dismis stack")
        }
    }

}
