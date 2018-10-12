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
        
        
         //print("Theis my Item array ==============\(self.itemArray)")
        //convertToJSONArray(moArray: itemArray)
        //print("This global Variable for title \(titleText)")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        updateNavigationController(withString: hexcolor)
        
       // convertToJSONArray(moArray: itemArray)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        
        updateNavigationController(withString: "04AEFF")
    }
    @objc func shareTapped(){
        
        let activityVC = UIActivityViewController(
            activityItems: ["Look at the list.", convertToJSONArray(moArray: itemArray)],
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
    
    func convertToJSONArray(moArray: [NSManagedObject]) -> Any {
        var titleText = [String]()
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        //print("This the array \(jsonArray)")
        for dic in jsonArray{
            guard let title = dic["title"] as? String else { fatalError("Unable To parse jsonArray") }
            //Output
            //print("This is the text from title \(title)")
            titleText.append(title)
           
        }
    print("This global Variable for title \(titleText)")
       // print("This is my \(jsonArray)")
        return jsonArray
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



// override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//self.view.endEditing(true)
//resignFirstResponder()
//}
