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
  
    @IBAction func addButtonPressed(_ sender: Any) {
    }
    
    @IBAction func setting(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 40
        loadItems()
        self.title = "Home"
    self.navigationController!.navigationBar.barTintColor = UIColor.flatPowderBlue
    self.navigationController!.navigationBar.backgroundColor = UIColor.flatPowderBlue
        
    }
    
}

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "catogriesCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        //if (indexPath.row % 2 == 0) {
        var tempColor = [UIColor.flatBlue,UIColor.flatBlueDark]
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = tempColor[0]
        } else {
            cell.backgroundColor = tempColor[1]
        }
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor as! UIColor, returnFlat: true)
        cell.textLabel?.textAlignment = .left
        cell.tintColor =  UIColor(hexString: "0400EB")
        cell.imageView?.frame = CGRect(x: (cell.bounds.width-110), y: 0, width: 100, height: 100)
        if category.isSecret {
            cell.accessoryView = UIImageView(image: UIImage(named: "blueLock"))
        }
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categoryArray[indexPath.row].isSecret == true{
            performSegue(withIdentifier: "goToLogin", sender: self)
        }else {
            performSegue(withIdentifier: "goToItems", sender: self)
        }
    }
    
    func gotoItem() {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as!ToDoListViewController
            // TODO:
            //setItemTitleView(nvi: destinationVC.navigationItem)
            if  let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoryArray[indexPath.row]
                 print("Passing the Selected \(destinationVC.selectedCategory)")
            }
        } else if segue.identifier == "goToLogin" {
            let destinationVC = segue.destination as!LoginViewController
            if  let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.catVC = self
            }
        } else if segue.identifier == "editCategory" {
            let destinationVC = segue.destination as! EditCategoryViewController
            if  let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.category = categoryArray[indexPath.row]
                print("category array to edit Category \(categoryArray[indexPath.row])")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.context.delete(self.categoryArray[indexPath.row])
            self.categoryArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
         // edit item at indexPath
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
           let next = self.storyboard?.instantiateViewController(withIdentifier: "EditCategoryViewController") as! EditCategoryViewController
            next.category = self.categoryArray[indexPath.row]
            self.present(next, animated: false, completion: nil)
            
        }
        edit.backgroundColor = UIColor.lightGray
        
        return [delete, edit]
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func editCategory(){
        
    }
}

extension CategoryViewController {
    func saveItem() {
        do {
            try context.save()
        } catch {
            print("error encoding data: \(error)")
        }
    }
    
    // Mark - loadItem
    func loadItems(with request : NSFetchRequest<Catogries> = Catogries.fetchRequest()){
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("There is an error in fetchin request\(error)")
        }
    }
    
}

