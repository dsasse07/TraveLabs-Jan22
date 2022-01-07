//
//  ViewController.swift
//  Shopper
//
//  Created by Daniel Sasse on 1/7/22.
//

import UIKit

class ViewController: UITableViewController {
    var listItems = [ShoppingListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shopper"
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareList))
        navigationItem.rightBarButtonItems = [addButton, shareButton]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .remove, style: .plain, target: self, action: #selector(clearList))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        var cellContents = cell.defaultContentConfiguration()
        let item = listItems[indexPath.row]
        cellContents.text = item.itemName
        cellContents.secondaryText = "Amount: \(item.quantity)"
        cell.contentConfiguration = cellContents
        return cell
    }
    
    @objc func addItem(){
        let ac = UIAlertController(title: "Add New Item", message: "Enter the information for the new item", preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        
        let getWord = UIAlertAction(title: "Add Item", style: .default) {
            [weak self, weak ac] action in
            guard let newItem = ac?.textFields?[0].text else { return }
            self?._add(newItem: newItem.capitalized)
        }
        
        ac.addAction(getWord)
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[0]
        present(ac, animated: true, completion: nil)
    }
    
    @objc func clearList(){
        let ac = UIAlertController(title: "Clear List", message: "Are you sure you want to clear the list?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: _clear))
        ac.addAction((UIAlertAction(title: "Cancel", style: .cancel, handler: nil)))
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(ac, animated: true, completion: nil)
    }
    
    @objc func shareList(){
        let shoppingList = listItems.map{ listItem in listItem.itemName}.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [shoppingList], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[1]
        present(vc, animated: true, completion: nil)
    }
    
    private func _clear(action: UIAlertAction! = nil){
        listItems.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    private func _add(newItem: String) {
        let newListItem = ShoppingListItem(item: newItem, amount: 1)
        listItems.insert(newListItem, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }


}

