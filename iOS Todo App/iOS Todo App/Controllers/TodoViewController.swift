//
//  ViewController.swift
//  iOS Todo App
//
//  Created by Ivan Su on 3/17/19.
//  Copyright © 2019 Ivan Su. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class TodoViewController: UIViewController {

    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Item] = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.black // Background Color
        navigationController?.navigationBar.tintColor = UIColor.white // Button Color
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white] // Title Color
        
        // Perform Delegate
        initDelegate()
        
        // Register NIB file for Cell
        registerComponent()
        
        // Configure itemsTableView
        configureTableView()
        
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
        searchBar.delegate = self
    }
    
    func registerComponent() {
        itemsTableView.register(UINib(nibName: "TodoItemCell", bundle: nil), forCellReuseIdentifier: "toDoItemCell")
    }
    
    func configureTableView() {
        // itemsTableView.rowHeight = UITableView.automaticDimension
        // itemsTableView.estimatedRowHeight = itemsTableView.rowHeight
        
        // itemsTableView.rowHeight = 80.0
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            items = try context.fetch(request)
        } catch {
            print("Error fetching context: \(error)")
        }
        
        itemsTableView.reloadData()
    }
    
    func saveItem(title: String) {
        let newItem = Item(context: self.context)
        
        newItem.title = title
        newItem.done = false
        
        items.append(newItem)
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        itemsTableView.reloadData()
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
        
        cell.delegate = self
        cell.titleLabel.text = items[indexPath.row].title
        cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].done = !items[indexPath.row].done
        
        saveContext()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TodoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadItems()
            
            // Turn search bar off
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

extension TodoViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.context.delete(self.items[indexPath.row])
            self.saveContext()
            self.items.remove(at: indexPath.row)
            self.itemsTableView.reloadData()
        }
        
        // ISSUE: Not showing image properly
        // deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
}

extension TodoViewController: TodoProtocol {
    func receiveNewItemData(title: String) {
        saveItem(title: title)
    }
}
