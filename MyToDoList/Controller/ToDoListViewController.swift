//
//  ToDoListViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 9/16/18.
//  Copyright © 2018 myw. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class ToDoListViewController : UITableViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var date = Date()
    var hexcolor = ""
    var itemArray = [Item]()
    
    var selectedCategory : Catogries? {
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [add, share]
        loadItems()
    }
    override func viewWillLayoutSubviews() {
        
        navigationController?.navigationBar.topItem?.title = selectedCategory?.name ?? "Item"
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        updateNavigationController(withString: hexcolor)

}
    
    override func viewWillDisappear(_ animated: Bool) {
       
        
        updateNavigationController(withString: "FFFDDB")
    }
    @objc func shareTapped(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        var arrTaskList = [String]()
        
        arrTaskList.append("Shared from SimpleList")
        arrTaskList.append(selectedCategory?.name ?? "-")
        
        do {
            let tasks = try context.fetch(request)
            for task in tasks {
                //title = task.title ?? "no title")
                arrTaskList.append(task.title ?? "no title")
    
                print("The array list \(arrTaskList)")
                print("The list of title \(task.title ?? "no title")")
                
            }
 
        } catch let error {
            print(error.localizedDescription)
        }
        //print("This my list in shared \(arrTaskList)")
        
        let activityVC = UIActivityViewController(
            activityItems: arrTaskList,
            applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = self.view
        
        present(activityVC, animated: true, completion: nil)
        
    }
    @objc func addTapped(){
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
            
            
            self.tableView.reloadData()
            
        }
        print("The date user enter the item is \(String(describing: newItem.creationDate))")
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "Add item"
            textField = alertTextField
            
            
        }
        alert.addAction(action)
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "No!", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    func updateNavigationController(withString  hexyString : String){
        guard let navBar = navigationController?.navigationBar  else{
            fatalError("There is no Navigation bar ")
            
        }
        if let color =  UIColor(hexString: hexyString ) {
            navBar.barTintColor = color
            navBar.tintColor = ContrastColorOf(color, returnFlat: true)
            navBar.largeTitleTextAttributes =  [NSAttributedStringKey.foregroundColor: ContrastColorOf(color, returnFlat: true)]
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
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            saveItem()
        }
        print("cell for index path is called")
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItem()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
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
