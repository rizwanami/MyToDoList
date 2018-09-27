//
//  CategoryViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 9/26/18.
//  Copyright © 2018 myw. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    // we are getting the context from app delegate
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // create an object which have hold Ctaogry entity
  
    var categoryArray = [Catogries]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
loadItems()
       
    }

    

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "catogriesCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
       
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if  let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add Category", style: .default){(action) in
            let newCategory = Catogries(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveItem()
            self.tableView.reloadData()
        }
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "add Category"
            textField = alertTextField
            
        }
        alert.addAction(action)
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
