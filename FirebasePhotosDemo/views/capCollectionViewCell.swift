//
//  capCollectionViewCell.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 10/7/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit

class capCollectionViewCell: UICollectionViewCell {
    weak var test : test! {
        didSet {
            self.updateUI()
        }
    }
    @IBOutlet weak var ctxt: UILabel!
    @IBOutlet weak var ltxt: UILabel!
    
    @IBOutlet weak var bluebox: UIView!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    @IBOutlet weak var leftSpace: NSLayoutConstraint!
    
    func updateUI(){
        
    }
    
}
