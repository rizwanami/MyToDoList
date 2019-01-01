//
//  EditCategoryViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 12/29/18.
//  Copyright © 2018 myw. All rights reserved.
//

import UIKit


class EditCategoryViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var category : Catogries? {
        didSet{
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("this ")
       textField.text = category?.name
        //formatView()
        
    }
    @IBAction func cancel(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func ChangeName(_ sender: Any) {
        if let pVC = self.presentingViewController?.childViewControllers.last as? CategoryViewController {
            // do stuff here
            category?.name = textField.text
            pVC.tableView.reloadData()
        }
        
        CommonFunction.singleton.saveItem()
        
        // saveItem()
    
        
        dismiss(animated: true, completion: nil)
    }
   
}
