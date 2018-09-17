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
let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let newitem = Item()
        print(dataFilePath)
        newitem.title = "call Zakia"
        newitem.done = true
        itemArray.append(newitem)
        let newitem1 = Item()
        newitem1.title = "call Hamza"
        itemArray.append(newitem1)
        let newitem2 = Item()
        newitem2.title = "buy olives"
        itemArray.append(newitem2)
        
//        if let item = defaults.array(forKey: "ToDolistItem") as? [String] {
//            itemArray = item
//        }
        
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
            let item = itemArray[indexPath.row]
            cell.textLabel?.text = item.title
            // use trenary opertaor for below 5 line expression to change in to one line expression
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
            // or  cell.accessoryType = item.done == true ? .checkmark : .none
//            if item.done == true {
//                cell.accessoryType = .checkmark
//            } else {
//               cell.accessoryType = .none
//
//            }
            // Configure the cell...
            print("cell for index path is called")
            return cell
        }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        } else {
            itemArray[indexPath.row].done = true
        }
       tableView.reloadData()
        
       // So because of this method  when user  selected the row it flashes gray briefly but then it goes back to being de-selected and goes back to being white which looks a lot nicer in terms of user interface.
        
        tableView.deselectRow(at: indexPath, animated: true)
        }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let newItem = Item()
        let alert = UIAlertController(title: "Add new toDoList Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add item", style: .default){(action) in
            newItem.title = textField.text!
            self.itemArray.append(newItem)
           //self.defaults.set(self.itemArray, forKey: "ToDolistItem") as! [Item]
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


