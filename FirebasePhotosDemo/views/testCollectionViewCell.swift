//
//  testCollectionViewCell.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 10/1/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
protocol mypicsdelegate {
    func tapmypic(mykey:String)
}

class testCollectionViewCell: UICollectionViewCell {
    @IBOutlet var cellview: UIView!
    
    @IBOutlet var cellimg: UIImageView!
    var delegate:mypicsdelegate?
    var mypost : mypost! {
        didSet {
            self.updateUI()
        }
    }
    @objc func myimg(sender: UITapGestureRecognizer){
       
        
        delegate?.tapmypic(mykey:mypost.key)
        LoginViewController.GlobalVariable.myString = mypost.key
        
    }
    
    func updateUI(){
        
        let imageDownloadURL = mypost.imageDownloadURL
        let resource = ImageResource(downloadURL: URL(string:imageDownloadURL!)!, cacheKey: imageDownloadURL!)
        self.cellimg.kf.setImage(with: resource)
        
        self.cellimg.clipsToBounds = true
        self.cellimg.layer.cornerRadius = 7
        self.cellimg.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(testCollectionViewCell.myimg(sender:)))
        self.cellimg.addGestureRecognizer(tapRecognizer)
    }
}

