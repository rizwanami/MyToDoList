//
//  MosaicLayout.swift
//  MyToDoList
//
//  Created by Mohammed Ibrahim on 11/7/18.
//  Copyright © 2018 myw. All rights reserved.
//

import UIKit

class MosaicLayout: UICollectionViewLayout {
    var contentBounds = CGRect.zero
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else { return }
        
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: cv.bounds.size)
        
        //For every Item :
        // - Prepare attribute
        // - Store attribute in cachedAttribute array
        // - union contentBounds with attribute.frame
        //self.layoutAttributesForItem(at: <#T##IndexPath#>)
    }
    
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let cv = collectionView else { return false}
        
        return !newBounds.size.equalTo(cv.bounds.size)
        
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? { return cachedAttributes.filter { (attributes : UICollectionViewLayoutAttributes)-> Bool in
            return rect.intersects(attributes.frame)
        }
    }
}
