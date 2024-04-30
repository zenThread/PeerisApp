//
//  imageCollectionViewCell.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 5/3/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase

class imageCollectionViewCell: UICollectionViewCell {
    
    // variables
    var mypost : mypost! {
        didSet {
            self.updateUI()
        }
    }
    @IBOutlet weak var imgview: UIImageView!
    
    @IBOutlet weak var picImg: UIImageView!
    func updateUI(){
        if let imageDownloadURL = mypost.imageDownloadURL {
            
            // 1 - Create the Storage Reference
            let imageStorageRef = Storage.storage().reference(forURL: imageDownloadURL)
            
            // 2 - Observe method to download the data
            imageStorageRef.getData(maxSize: 2 * 1024 * 1024, completion: { [weak self](data, error) in
                if let error = error {
                    print("*** ERROR DOWNLOAD IMAGE : \(error)")
                } else {
                    // Success
                    if let imageData = data {
                        // 3 - Put the image in imageview
                        DispatchQueue.main.async {
                            print("working")
                           // let width = UIScreen.main.bounds.width
                            
                           // self?.picImg.frame = CGRect(x: 0, y: 0, width: width / 3, height: width / 3)
                            
                            let image = UIImage(data: imageData)
                            self?.picImg.image = image
                            self?.picImg.clipsToBounds = true
                        }
                    }
                }
            })
        }
    }
    
    
    
}
