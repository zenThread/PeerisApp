//
//  testTableViewCell.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 10/1/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class testTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var myposts = [mypost]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myposts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = icoll.dequeueReusableCell(withReuseIdentifier: "collcell", for: indexPath) as! testCollectionViewCell
        //cell.mypost = self.myposts[indexPath.row]
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let oo = self.bounds.size.width
        
        return CGSize(width: oo/3, height: oo/3)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    @IBOutlet var icoll: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

