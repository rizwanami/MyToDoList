//
//  ColumnFlowlayout.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 11/6/18.
//  Copyright © 2018 myw. All rights reserved.
//

import UIKit

class ColumnFlowlayout:  UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        print("prepare....")
        guard let cv = collectionView else { return }
        
        let availableWidth = cv.bounds.insetBy(dx: cv.layoutMargins.left, dy: cv.layoutMargins.bottom).size.width
        
        let minColumnWidth = CGFloat(90)
        let maxNumColumns = Int(availableWidth / minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        self.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        self.sectionInsetReference = .fromSafeArea
    }
    
}
