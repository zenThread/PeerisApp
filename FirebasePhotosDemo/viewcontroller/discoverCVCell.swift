//
//  discoverCVCell.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 10/28/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit

class discoverCVCell: UICollectionViewCell{
    
    @IBOutlet var label: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var shade: UIView!
    @IBOutlet weak var bv: UIView!
    @IBOutlet var rating: UILabel!
    var posts:Post!{
        didSet{
            
        }
    }

    
}
