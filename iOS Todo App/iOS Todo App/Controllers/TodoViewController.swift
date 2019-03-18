//
//  ViewController.swift
//  iOS Todo App
//
//  Created by Ivan Su on 3/17/19.
//  Copyright © 2019 Ivan Su. All rights reserved.
//

import UIKit

class TodoViewController: UIViewController {

    @IBOutlet weak var itemsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform Delegate
        initDelegate()
        
        // Register NIB file for Cell
        registerComponent()
    }
    
    func initDelegate() {
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
    }
    
    func registerComponent() {
        itemsTableView.register(UINib(nibName: "TodoItemCell", bundle: nil), forCellReuseIdentifier: "toDoItemCell")
    }
}

extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath) as! TodoItemCell
        
        cell.titleLabel.text = "Hello"
        
        return cell
    }
    
    
}
