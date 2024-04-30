//
//  testCollView.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 10/2/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit

class testCollView: UICollectionView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.bounds.size.equalTo(self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            let intrinsicContentSize = self.contentSize
            return intrinsicContentSize
        }
    }
    
    // MARK: - setup
    func setup() {
        self.isScrollEnabled = true
        self.bounces = true
        self.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
    }
}
