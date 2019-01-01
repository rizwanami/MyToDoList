//
//  DetailSecreteViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 12/27/18.
//  Copyright © 2018 myw. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework
import CoreData
class DetailSecreteViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var secretTitle: UITextField!
    var originalText: String = ""
    
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var secretNotes: UITextView!
    @IBAction func secretAction(_ sender: Any) {
        let secretButton = sender as! UIButton
        if !secretButton.isSelected {
           secretNotes.isSecureTextEntry = false
           secretNotes.text = originalText
        } else {
           secretNotes.isSecureTextEntry = true
           secretNotes.text = String(repeating: "*", count: (originalText ?? "").count)
        }
        secretButton.isSelected = !secretButton.isSelected
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var item :Item? {
        didSet{
            //loadItems()
        }
    }
    func formatNavigationItem(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        let navView = UIView()
        
        // Create the label
        let label = UILabel()
        label.text = "Edit Item"
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        
        // Create the image view
        let image = UIImageView()
        image.image = UIImage(named: "blueLock")
        // To maintain the image's aspect ratio:
        let imageAspect = image.image!.size.width/image.image!.size.height
        // Setting the image frame so that it's immediately before the text:
        image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
        image.contentMode = UIViewContentMode.scaleAspectFit
        
        // Add both the label and image view to the navView
        navView.addSubview(label)
        navView.addSubview(image)
        // Set the navigation bar's navigation item's titleView to the navView
        self.navigationItem.titleView = navView
        
        // Set the navView's frame to fit within the titleView
        navView.sizeToFit()
    }

    func formatView() {
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: Selector(("doneButtonAction")))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        //Configure Title Text
        secretTitle.layer.borderWidth = 0.2
        secretTitle.layer.cornerRadius = 0
        secretTitle.text = item?.title
        secretTitle.backgroundColor = UIColor.flatWhiteDark.lighten(byPercentage: 0.25)
        secretTitle.textColor = UIColor.flatNavyBlue
        secretTitle.inputAccessoryView = toolbar
        
        secretNotes.layer.cornerRadius = 10
        secretNotes.text = String(repeating: "*", count: (item?.notes ?? "").count)
        
        if let testText = item?.notes {
            originalText = testText
        } else {
            originalText = ""
        }
        
        secretNotes.keyboardDismissMode = .interactive
        secretNotes.backgroundColor = UIColor.flatWhiteDark.lighten(byPercentage: 0.25)
        secretNotes.inputAccessoryView = toolbar
        secretNotes.isSecureTextEntry = true
        secretNotes.delegate = self

        notesLabel.layer.cornerRadius = 0
        notesLabel.layer.borderWidth = 0.2
        notesLabel.backgroundColor = UIColor.flatPowderBlue
        notesLabel.textColor = ContrastColorOf(secretTitle.backgroundColor as! UIColor, returnFlat: true)
        notesLabel.layer.borderWidth = 0.2
        notesLabel.text = "Notes"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatNavigationItem()
        formatView()
    }
//
//    @IBAction func secreteNotesButton(_ sender: Any) {
//        if notesButton.isOn {
//            secretNotes.isHidden = true
//        } else {
//            secretNotes.isHidden = false
//        }
//    }
   
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //if textView.isSecureTextEntry {
        originalText = (originalText as NSString).replacingCharacters(in: range, with: text)
        //}

        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.isSecureTextEntry {
            textView.text = String(repeating: "*", count: (textView.text ?? "").count)
        }
    }
    
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
        item?.title = secretTitle.text
        item?.notes = originalText
        //self.title = item?.title
        saveItem()
        
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
