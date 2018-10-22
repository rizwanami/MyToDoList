//
//  CategoryViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 9/26/18.
//  Copyright © 2018 myw. All rights reserved.
//
import UIKit
import CoreData
import ChameleonFramework

class CategoryViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Catogries]()
    var childView = ChildViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        loadItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "catogriesCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        cell.backgroundColor = UIColor(hexString: categoryArray[indexPath.row].hexColor ?? "1D9BF6")
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
          let destinationVC = segue.destination as! ToDoListViewController
        if  let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
            
        } else if segue.identifier == "addCategaory" {
            segue.destination as! ChildViewController
        }
        
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.context.delete(self.categoryArray[indexPath.row])
            self.categoryArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveItem()
            
            
        }
        
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            // share item at indexPath
            print("I want to share: \(self.categoryArray[indexPath.row])")
        }
        
        share.backgroundColor = UIColor.lightGray
        
        return [delete, share]
        
    }
    
    
    @IBAction func childViewButton(_ sender: Any) {
        //childViewSegue
        performSegue(withIdentifier: "childViewSegue", sender: self)
        print("nnnnnnnnnnnnnnnnnnn")
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add Category", style: .default) {(action) in
            let newCategory = Catogries(context: self.context)
            newCategory.name = textField.text!
            
            newCategory.hexColor = UIColor.randomFlat.hexValue()
            self.categoryArray.append(newCategory)
            
            self.saveItem()
            self.tableView.reloadData()
        }
        //alert.addChildViewController(childViewControllerContaining(self.childView))
        
        
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "add Category"
            textField = alertTextField
            
            //alert.addChildViewController(viewIfLoaded)
        }
        alert.addAction(action)
        
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "No!", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem() {
        do {
            try context.save()
        } catch {
            print("error encoding data: \(error)")
        }
    }
    
    func loadItems(with request : NSFetchRequest<Catogries> = Catogries.fetchRequest()){
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("There is an error in fetchin request\(error)")
        }
    }
    
}

