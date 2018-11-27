//
//  DetailImageViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 11/9/18.
//  Copyright © 2018 myw. All rights reserved.
//

import Foundation
import UIKit
class DetailImageViewController : UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextfield: UITextField!
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var photo = Photo()
     var item : Item?
    var photoimage : NSData!
    let memeTextAttributes = [
        NSAttributedStringKey.strokeColor.rawValue : UIColor.white, NSAttributedStringKey.foregroundColor : UIColor.clear, NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSAttributedStringKey.strokeWidth : -10.0] as! [String : Any]
    

    override func viewDidLoad() {
        
       
        photoimage = photo.image as! NSData
        imageView.image = UIImage(data:photoimage as Data,scale:1.0)
        bottomTextfield.delegate = self
        bottomTextfield.defaultTextAttributes = memeTextAttributes
        bottomTextfield.textAlignment = NSTextAlignment.center
        //Tool bar on top of Keyboard
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: Selector(("doneButtonAction")))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        bottomTextfield.inputAccessoryView = toolbar
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(addPinch(sender:)))
        imageView.addGestureRecognizer(pinch)
}
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        bottomTextfield.defaultTextAttributes = memeTextAttributes
       bottomTextfield.textAlignment = NSTextAlignment.center
        subscribeToKeyboardNotifications()
        keyboardDidDisapper()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
        }
    @objc func addPinch(sender : UIPinchGestureRecognizer){
        guard sender.view != nil else {
            return
        }
        if sender.state == .began || sender.state == .changed {
    sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
        sender.scale = 1.0
        }
    }
    func textFieldShouldReturn(textField : UITextField) -> Bool {
        bottomTextfield.resignFirstResponder()
        //topText.resignFirstResponder()
        //BottomToolBar.resignFirstResponder()
        return true;
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if bottomTextfield.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification: notification) * (-1)
        }
    }
    
    //Testing the commit
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:
            #selector(DetailImageViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillHide(notification : NSNotification) {
        if bottomTextfield.isFirstResponder {
            view.frame.origin.y = 0        }
    }
    
    func keyboardDidDisapper() {
        NotificationCenter.default.addObserver(self, selector: #selector(DetailImageViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
   
}

    

