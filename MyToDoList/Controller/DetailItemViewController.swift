//
//  DetailItemViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 10/25/18.
//  Copyright © 2018 myw. All rights reserved.
//


import UIKit
import CoreData

class DetailItemViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    //var item : Item!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var item :Item? {
        didSet{
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let editItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(edit))
        navigationItem.rightBarButtonItem = editItem
        textView.text = item?.title
        
    }
    
    @objc func edit(){
        let alert = UIAlertController(title: "Add new toDoList Item", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No!", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alert.addAction(cancelAction)
        let editAction = UIAlertAction(title: "add item", style: .default){(action) in
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            do {
                let tasks = try self.context.fetch(request)
                let manageObject = self.item
                manageObject?.setValue(self.textView.text, forKey: "title")
            } catch {
                print()
            }
            self.dismiss(animated: true, completion: nil)
            
        }
        self.dismiss(animated: true, completion: nil)
        alert.addAction(editAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        item?.title = textView.text
        //saveItem()
    }
    
    func saveItem() {
        
        do {
            
            try context.save()
        } catch {
            print("error encoding data: \(error)")
        }
    }
}
