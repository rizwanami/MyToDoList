//
//  DetailItemViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 10/25/18.
//  Copyright © 2018 myw. All rights reserved.
//


import UIKit
import CoreData

class DetailItemViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var txfItemTitle: UITextField!
    
    //var item : Item!
    var notes = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var item :Item? {
        didSet{
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init the View
        txfItemTitle.text = item?.title
//        self.navigationItem.titleView = txfTitle
        textView.text = item?.notes
//        self.navigationItem.title = item?.title
        self.navigationController?.isToolbarHidden = false
        textView.keyboardDismissMode = .interactive
        self.title = item?.title
        //Tool bar on top of Keyboard
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: Selector(("doneButtonAction")))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        textView.inputAccessoryView = toolbar
        txfItemTitle.inputAccessoryView = toolbar
        
        //Make the Title Editable
        
    }
    
    //TODO: Make Title editable
    
    //Save the Context before existing the Item Details
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Inside viewWillDisapper.....")
        if self.isMovingFromParentViewController {
            print("Saving.....")
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            do {
                let tasks = try self.context.fetch(request)
                let manageObject = self.item
                manageObject?.setValue(self.textView.text, forKey: "notes")
                saveItem()
            } catch {
                print()
            }
        }
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
        item?.title = txfItemTitle.text
        item?.notes = textView.text
        self.title = item?.title
    }
    
    //Save Current Context
    func saveItem() {
        do {
            try context.save()
            print("Item Saved")
        } catch {
            print("error encoding data: \(error)")
        }
    }
}
