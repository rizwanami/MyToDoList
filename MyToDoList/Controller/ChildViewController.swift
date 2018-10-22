//
//  childViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 10/14/18.
//  Copyright © 2018 myw. All rights reserved.
//

import Foundation
import UIKit
class ChildViewController : UIViewController, UINavigationBarDelegate, UITextFieldDelegate {
    
@IBOutlet weak var navBar: UINavigationBar!
    
var textFieldMy: UITextField!
    
override func viewDidLoad() {
        
    super.viewDidLoad()
     //self.navBar(frame: CGRect(x: 0, y: 0, width: 375, height: 120))
    let navItem = UINavigationItem()
   navItem.prompt = "Add Items"
    
   
    navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    navBar.items = [navItem]
    print("The navbarHeight is \(navBar.frame.height) and navBarWidth \(navBar.frame.width)")
    self.textFieldMy = UITextField(frame: CGRect(x: 20, y: (navBar.frame.height) , width: (navBar.frame.width - 15), height: 40))
    self.textFieldMy.translatesAutoresizingMaskIntoConstraints = true
    self.textFieldMy.backgroundColor = UIColor.flatWhite
    self.textFieldMy.tintColor = UIColor.black
    self.textFieldMy.text = "Enter The Item"
    self.textFieldMy.textAlignment = .center
        
    self.textFieldMy.layer.cornerRadius = 22.0
    self.textFieldMy.layer.borderWidth = 1
    self.view.addSubview(self.textFieldMy)
}
    @objc func cancel(){
        dismiss(animated: true, completion: nil)
        
    }
    @objc func addTapped(){
        
    }
    override func viewWillAppear(_ animated: Bool) {
       }
    override func viewDidAppear(_ animated: Bool) {
      }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    
  
    
}
