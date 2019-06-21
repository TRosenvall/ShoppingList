//
//  ShoppingListListTableViewController.swift
//  Shopping List
//
//  Created by Timothy Rosenvall on 6/21/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemController.sharedInstance.fetchedResultsController.delegate = self
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        getItemName()
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemController.sharedInstance.fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ShoppingListTableViewCell else {return UITableViewCell()}
        //guard let item = ItemController.sharedInstance.fetchedResultsController.fetchedObjects?[indexPath.row] as? Item else {return UITableViewCell()}
        let item = ItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
        cell.update(item: item)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            guard let item = ItemController.sharedInstance.fetchedResultsController.fetchedObjects?[indexPath.row] else {return}
            let item = ItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
            ItemController.sharedInstance.deleteItem(item: item)
        }
    }
    
    func getItemName () {
        let alertController = UIAlertController(title: "Add Item", message: "Please add an item to your shopping list", preferredStyle: .alert)
        alertController.addTextField{ (textField) in textField.placeholder = "Item name..." }
        let addItemAction = UIAlertAction(title: "Add", style: .default) { (_) in guard let itemText = alertController.textFields?.first?.text else {return}
            ItemController.sharedInstance.createItem(name: itemText)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(addItemAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension ShoppingListListTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
}

extension ShoppingListListTableViewController: ShoppingListTableViewCellDelegate {
    func isCompleteButtonTapped(_ sender: ShoppingListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
//        guard let item = ItemController.sharedInstance.fetchedResultsController.fetchedObjects?[indexPath.row] else {return}
        let item = ItemController.sharedInstance.fetchedResultsController.object(at: indexPath)
        ItemController.sharedInstance.toggleIsCompleteFor(item: item)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
