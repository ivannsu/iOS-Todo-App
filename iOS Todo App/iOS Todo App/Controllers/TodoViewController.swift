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
    
    var items: [Item] = [Item]()
    var sampleString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform Delegate
        initDelegate()
        
        // Register NIB file for Cell
        registerComponent()
        
        // Load items data
        loadItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddToDo" {
            let destination = segue.destination as! AddTodoViewController
            
            destination.delegate = self
        }
    }
    
    func initDelegate() {
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
    }
    
    func registerComponent() {
        itemsTableView.register(UINib(nibName: "TodoItemCell", bundle: nil), forCellReuseIdentifier: "toDoItemCell")
    }
    
    func loadItems() {
        let item1 = Item(title: "Buy an egg", done: false)
        let item2 = Item(title: "Save the world", done: false)
        let item3 = Item(title: "Get seven dragonball", done: false)
        
        items.append(item1)
        items.append(item2)
        items.append(item3)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToAddToDo", sender: self)
    }
}

extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath) as! TodoItemCell
        
        cell.titleLabel.text = items[indexPath.row].title
        
        return cell
    }
}

extension TodoViewController: TodoProtocol {
    func receiveNewItemData(title: String) {
        print("received from TodoView: \(title)")
    }
}
