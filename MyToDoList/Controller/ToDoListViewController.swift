//
//  ToDoListViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 9/16/18.
//  Copyright © 2018 myw. All rights reserved.
//

import UIKit
import CoreData
import EventKit
import ChameleonFramework


class ToDoListViewController : UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    let appDelegate = UIApplication.shared.delegate
        as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var date = Date()
    var hexcolor = ""
    var itemArray = [Item]()
    var reminder = [Reminder]()
    let dateFormatter = DateFormatter()
    let local = Locale.current
    var selectedCategory : Catogries? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.barTintColor = UIColor.flatPowderBlue
        searchBar.backgroundColor = UIColor.flatPowderBlue
       
        
        //self.navigationItem.title = selectedCategory?.name
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [add, share]
        loadItems()
        self.title = selectedCategory?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //updateNavigationController(withString: hexcolor)
        loadItems()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //updateNavigationController(withString: "FFFDDB")
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
    
    //Add Item Action
    @objc func addTapped(){
        var textField = UITextField()
        let newItem = Item(context: self.context)
        let alert = UIAlertController(title: "Add new toDoList Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add item", style: .default){(action) in
            newItem.title = textField.text!
            newItem.done = false
            
            newItem.creationDate = Date()
            
            newItem.setValue(self.date, forKey: "creationDate")
            
            newItem.parentCat = self.selectedCategory
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
  
    //CheckBox Button Action
    @objc func checkboxClicked(_ sender: UIButton) {
        let item = itemArray[sender.tag]
        sender.isSelected = !sender.isSelected
        print(sender.isSelected)
        if sender.isSelected{
            item.setValue(true, forKey: "done")
        } else if !sender.isSelected {
            item.setValue(false, forKey: "done")
        }
        saveItem()
    }
    
    @IBAction func updateBtn(sender: UIButton) {}
}

// Mark: -  TableViewDlegate
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //Load Data to Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title

        var tempColor = [UIColor.flatBlue,UIColor.flatBlueDark]
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = tempColor[0]
        } else {
            cell.backgroundColor = tempColor[1]
        }
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor as! UIColor, returnFlat: true)
        cell.tintColor =  UIColor(hexString: "0400EB")

            
        if let btnChk = cell.contentView.viewWithTag(1) as? UIButton {
            btnChk.addTarget(self, action: #selector(checkboxClicked(_ :)), for: .touchUpInside)
            btnChk.tag = indexPath.row
            if item.done {
                btnChk.isSelected = true
            }
        }
        
   
        return cell
    }
    
}

// Mark:- TableViewDataSource
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailItem" {
            let destinationVC = segue.destination as! DetailItemViewController
            if  let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.item = itemArray[indexPath.row]
            }
        }
    }
    // Mark: - editActionsForRowAt indexPath
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            let alert = UIAlertController(title: "Do you want to delete " + self.itemArray[indexPath.row].title! + "?", message: "", preferredStyle: .alert)
            let myaction = UIAlertAction(title: "Delete", style: .default){(action) in
                
                self.context.delete(self.itemArray[indexPath.row])
                self.itemArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.saveItem()
            }
            alert.addAction(myaction)
            // Create Cancel button
            let cancelAction = UIAlertAction(title: "No!", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel button tapped");
            }
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
            
        }
       
        
        
        return [delete]
        
    }
    
        
        
    
//    func createReminder() {
//
//        let reminder = EKReminder(eventStore: appDelegate.eventStore!)
//
//        //reminder.title = reminderText.text!
//        reminder.calendar =
//            appDelegate.eventStore!.defaultCalendarForNewReminders()
//        //let date = myDatePicker.date
//        let alarm = EKAlarm(absoluteDate: date)
//
//        reminder.addAlarm(alarm)
//
//        do {
//            try appDelegate.eventStore?.save(reminder,
//                                             commit: true)
//        } catch let error {
//            print("Reminder failed with error \(error.localizedDescription)")
//        }
//    }
//
}
// Mark:- CoreData
extension ToDoListViewController {
    
    // Mark: - saveItem
    func saveItem() {
        
        do {
            
            try context.save()
        } catch {
            print("error encoding data: \(error)")
        }
    }
    // Mark: - loadItems
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        hexcolor = selectedCategory?.hexColor ?? "1D9BF6"
        let categoryPredicate = NSPredicate(format: "parentCat IN %@", [selectedCategory!])
        print("After Predicate.....")
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates : [categoryPredicate, additionalPredicate])
        }else {
            print("Assing Predicate....")
            request.predicate = categoryPredicate
        }
        do {
            print("Fetching Item Array....")
            itemArray = try context.fetch(request)
            print("Item Array Fetched.....")
        } catch {
            print("There is an error in fetchin request\(error)")
        }
        print("Something Fecthed......123....")
        print(itemArray.count)
        tableView.reloadData()
        
    }
    
}
// Mark: - SearchBar Method
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
