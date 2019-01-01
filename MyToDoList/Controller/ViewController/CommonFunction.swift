//
//  CommonFunction.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 12/30/18.
//  Copyright © 2018 myw. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class CommonFunction {
    public static let singleton = CommonFunction()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public func saveItem() {
        do {
            try context.save()
        } catch {
            print("error encoding data: \(error)")
        }
    }
    
    public func loadItems(with request : NSFetchRequest<NSManagedObject>, array : [ Any]){
        var arr = array
        do {
           arr = try context.fetch(request)
        } catch {
            print("There is an error in fetchin request\(error)")
        }
    }
    //static var funbbb : Int = 0
}
