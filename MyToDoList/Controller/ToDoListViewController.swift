//
//  ToDoListViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 9/16/18.
//  Copyright © 2018 myw. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController : UITableViewController {
    
   
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
var itemArray = [Item]()
    // here we created a property which hold the categaries it is nil untill we can set it we will open an Bracket and after the selected categaory variable and and I can use a special keyword code did set and everything that's between these curly braces is going to happen as soon as selected category gets set with a value. This perfect place to call loadItem and also we can delete it from viewdid load
    
    
    
    
    var selectedCategory : Catogries? {
        didSet{
           loadItems()
        }
    }
let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        if let item = defaults.array(forKey: "ToDolistItem") as? [String] {
//            itemArray = item
//        }
        
    
        // Do any additional setup after loading the view, typically from a nib.
        loadItems()
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
            saveItem()
            print("cell for index path is called")
            return cell
        }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //  replace above one line code with following five line code
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
//
       saveItem()
        tableView.reloadData()
        
       // So because of this method  when user  selected the row it flashes gray briefly but then it goes back to being de-selected and goes back to being white which looks a lot nicer in terms of user interface.
        
        tableView.deselectRow(at: indexPath, animated: true)
        }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
       
        let newItem = Item(context: self.context)
        let alert = UIAlertController(title: "Add new toDoList Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add item", style: .default){(action) in
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCatogeries = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItem()
            
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
    // Mark: - Model Manupulation method
    func saveItem() {
        
        do {
            
            try context.save()
        } catch {
            print("error encoding data: \(error)")
        }
    }
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCatogeries.name Matches %@", (selectedCategory!.name!))
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates : [categoryPredicate, additionalPredicate])
        }else {
        
        request.predicate = categoryPredicate
    }
        do {
          itemArray = try context.fetch(request)
        } catch {
            print("There is an error in fetchin request\(error)")
        }
       tableView.reloadData()
    }
    
    
}
// Mark: - SerchBar Method
extension ToDoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
         request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with : request, predicate: searchPredicate)
        

//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("There is an error in fetchin request\(error)")
//        }
       tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
 
    
}
