//
//  ToDoListViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 9/16/18.
//  Copyright © 2018 myw. All rights reserved.
//

import UIKit

class ToDoListViewController : UITableViewController {
var itemArray = [Item]()
let Default = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        let newitem = Item()
        newitem.title = "call Zakia"
        itemArray.append(newitem)
        let newitem1 = Item()
        newitem1.title = "call Hamza"
        itemArray.append(newitem1)
        let newitem2 = Item()
        newitem2.title = "buy olives"
        itemArray.append(newitem2)
        
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
            cell.textLabel?.text = itemArray[indexPath.row].title
            // Configure the cell...
            
            return cell
        }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let newItem = Item()
        let alert = UIAlertController(title: "Add new toDoList Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add item", style: .default){(action) in
            newItem.title = textField.text!
            self.itemArray.append(newItem)
           print(textField.text)
            self.tableView.reloadData()
            
        }
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "Add item"
            textField = alertTextField
            
            print("Now")
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}


