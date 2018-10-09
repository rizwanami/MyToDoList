//
//  ToDoListViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 9/16/18.
//  Copyright © 2018 myw. All rights reserved.
//

import UIKit
import CoreData
//import Foundation
import ChameleonFramework

class ToDoListViewController : UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var date = Date()
var hexcolor = ""
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //let date = Date()
    
    
    //Item.setValue(date.format(), forKey: "date")
var itemArray = [Item]()
var selectedCategory : Catogries? {
        didSet{
           loadItems()
        }
 }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
    }
    override func viewWillAppear(_ animated: Bool) {
        updateNavigationController(withString: hexcolor)
        
        
        //        guard let navBar = navigationController?.navigationBar  else{
        //            fatalError("There is no Navigation bar ")
        //
        //        }
        //        if let color =  UIColor(hexString: hexcolor) {
        //        navBar.barTintColor = color
        //       navBar.tintColor = ContrastColorOf(color, returnFlat: true)
        //            navBar.largeTitleTextAttributes =  [NSAttributedStringKey.foregroundColor: ContrastColorOf(color, returnFlat: true)]
        //
        //
        //
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        updateNavigationController(withString: "04AEFF")
    }
    func updateNavigationController(withString  hexyString : String){
        guard let navBar = navigationController?.navigationBar  else{
            fatalError("There is no Navigation bar ")
            
        }
        if let color =  UIColor(hexString: hexyString ) {
            navBar.barTintColor = color
            navBar.tintColor = ContrastColorOf(backgroundColor: color, returnFlat: true)
            navBar.largeTitleTextAttributes =  [NSAttributedStringKey.foregroundColor: ContrastColorOf(backgroundColor: color, returnFlat: true)]
            searchBar.barTintColor = color
            
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
            let item = itemArray[indexPath.row]
            if  let color  = UIColor(hexString: hexcolor)?.darken(byPercentage: CGFloat(indexPath.row) / ( CGFloat(itemArray.count) * (1.6))) {
                cell.textLabel?.text = item.title
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: color, returnFlat: true)
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
            }
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
            newItem.creationDate = Date()
            
            newItem.setValue(self.date, forKey: "creationDate")
            
            newItem.parentCatogeries = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItem()
            
           //self.defaults.set(self.itemArray, forKey: "ToDolistItem") as! [Item]
           self.tableView.reloadData()
            
             print("The date user enter the item is \(String(describing: newItem.creationDate))")
        }
        print("The date user enter the item is \(String(describing: newItem.creationDate))")
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "Add item"
            textField = alertTextField
            
           
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
        hexcolor = selectedCategory?.hexColor ?? "1D9BF6"
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
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.context.delete(self.itemArray[indexPath.row])
            self.itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveItem()
            
            
        }
        
      
        
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            // share item at indexPath
            print("I want to share: \(self.itemArray[indexPath.row])")
        }
        
        share.backgroundColor = UIColor.lightGray
    
        return [delete, share]
        
    }
    
    
}
// Mark: - SerchBar Method
extension ToDoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
         request.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        loadItems(with : request, predicate: searchPredicate)
        


       tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.loadItems()
            }
            
        }
    }
 
    
}
