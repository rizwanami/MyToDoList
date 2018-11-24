//
//  DetailImageViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 11/9/18.
//  Copyright © 2018 myw. All rights reserved.
//

import Foundation
import UIKit
class DetailImageViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextfield: UITextField!
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var photo = Photo()
     var item : Item?
    var photoimage : NSData!
    let memeTextAttributes = [
        NSAttributedStringKey.strokeColor.rawValue : UIColor.white, NSAttributedStringKey.foregroundColor : UIColor.clear, NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSAttributedStringKey.strokeWidth : -10.0] as! [String : Any]
    
//     let memeTextAtrributes = [
//        NSAttributedStringKey.font.rawValue: UIFont(name: "CopalStd-Solid", size: 40)!,
//        NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
//        NSAttributedStringKey.strokeWidth.rawValue : -8.0, NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
//        ] as! [String : Any]
    override func viewDidLoad() {
        photoimage = photo.image as! NSData
        imageView.image = UIImage(data:photoimage as Data,scale:1.0)
//        topTextField.delegate = self
        bottomTextfield.delegate = self
//        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextfield.defaultTextAttributes = memeTextAttributes
//        topTextField.textAlignment = NSTextAlignment.center
        bottomTextfield.textAlignment = NSTextAlignment.center
        //Tool bar on top of Keyboard
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: Selector(("doneButtonAction")))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
//        topTextField.inputAccessoryView = toolbar
        bottomTextfield.inputAccessoryView = toolbar
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//       topTextField.defaultTextAttributes = memeTextAttributes
       bottomTextfield.defaultTextAttributes = memeTextAttributes
//       topTextField.textAlignment = NSTextAlignment.center
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
        save()
        
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
extension DetailImageViewController {
    func save() {
//        let meme = MemeMeObject(top: self.topTextField.text!, bottom: self.bottomTextfield.text!, image: self.imageView.image, memedImage:generateMemeImage())
       // let meme1 = meme as NSData?
       //var imageUIImage: UIImage = UIImage(data: meme1)
      
    }
    
    func generateMemeImage()->UIImage {
        
        //BottomToolBar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //BottomToolBar.isHidden = false
        return memedImage
    }
    func prepareImageForSaving(image:UIImage) {
        
        // use date as unique id
        let date : Double = NSDate().timeIntervalSince1970
        
        // dispatch with gcd.
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            
            // create NSData from UIImage
            guard let imageData = UIImageJPEGRepresentation(image, 1) else {
                // handle failed conversion
                print("jpg error")
                return
            }
            
            // scale image, I chose the size of the VC because it is easy
            let thumbnail = image
            
            guard let thumbnailData  = UIImageJPEGRepresentation(thumbnail, 0.7) else {
                // handle failed conversion
                print("jpg error")
                return
            }
            
            // send to save function
            self.saveImage(imageData: imageData as NSData, thumbnailData: thumbnailData as NSData, date: date)
            
        }
    }
    func saveImage(imageData:NSData, thumbnailData:NSData, date: Double) {
        print("Saving New Image....")
        //set image data of fullres
        let newPhoto = Photo(context: self.context)
        
        //self.item?.photos
        newPhoto.image = imageData as Data
        newPhoto.parentItem = self.item
        
        let newThumbnail = Thumbnail(context: self.context)
        newThumbnail.image = thumbnailData as Data
        newThumbnail.photo = newPhoto
        
        do {
            try self.context.save()
        } catch {
            print("error encoding data: \(error)")
        }
        
    }
    
}
