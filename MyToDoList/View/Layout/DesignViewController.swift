//
//  DesignViewController.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 12/18/18.
//  Copyright © 2018 myw. All rights reserved.
//

import UIKit

@IBDesignable class DesignViewController: UIView {

 
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    

}
