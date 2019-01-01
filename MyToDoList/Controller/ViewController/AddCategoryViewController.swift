//
//  AddCategoryViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 12/9/18.
//  Copyright © 2018 myw. All rights reserved.
//

import UIKit
import CoreData

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var isSecretCategory: UIButton!
    @IBOutlet weak var alterView: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //var categoryArray = [Catogries]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alterView.backgroundColor = UIColor.flatPowderBlue
        self.titleLabel.backgroundColor = UIColor.flatPowderBlueDark
        self.btnAdd.backgroundColor = UIColor.flatPowderBlueDark
        self.btnCancel.backgroundColor = UIColor.flatPowderBlueDark

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAction(_ sender: Any) {
        let newCategory = Catogries(context: self.context)
        newCategory.name = categoryText.text
        newCategory.isSecret = isSecretCategory.isSelected
        if let pVC = self.presentingViewController?.childViewControllers.last as? CategoryViewController {
            // do stuff here
            pVC.categoryArray.append(newCategory)
            pVC.tableView.reloadData()
        }
        
      CommonFunction.singleton.saveItem()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleSecretFlag(_ sender: Any) {
        isSecretCategory.isSelected = !isSecretCategory.isSelected
    }
    
//    func saveItem() {
//        do {
//            try context.save()
//        } catch {
//            print("error encoding data: \(error)")
//        }
//    }
}
