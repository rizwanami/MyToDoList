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
   // var item : Item!
    //var title = item.title
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var item :Item? {
        didSet{
            textView.text = item?.title
            
        }
    }
    var itemArrayDetail = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("This item tiltle \(item?.title) \(item)")
        //textView.text = item.title
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         print("This item tiltle \(item?.title) \(item)")
    }
    
   
    
}
