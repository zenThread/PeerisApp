//
//  commSectTableViewCell.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 6/1/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class commSectTableViewCell: UITableViewCell {

    var cPost : cPost! {
        didSet {
            self.updateUI()
        }
    }
    
    
    
    @IBOutlet var section: UIView!
    
    @IBOutlet var username: UILabel!
    
    @IBOutlet weak var commimg: UIImageView!
    @IBOutlet var commentlbl: UILabel!
    
  
    func updateUI(){
        self.section.layer.cornerRadius = 0
        self.username.clipsToBounds = true
        self.username.layer.cornerRadius = 8
        self.commimg.layer.cornerRadius = self.commimg.frame.size.width/2
        self.commimg.clipsToBounds = true
        Database.database().reference().child("users").child(cPost.uid).child("userImg").observe(.value, with: {(snap:DataSnapshot) in
            let imageDownloadURL = snap.value
            let resource = ImageResource(downloadURL: URL(string:imageDownloadURL! as! String)!, cacheKey: imageDownloadURL! as? String)
            self.commimg.kf.setImage(with: resource)
            
            
        })
        self.section.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        if let yy = cPost.comment{
            
            self.commentlbl.text = yy
            //self.commentlbl.text = ("dgiuywgaudiuefiufegiuefiufiu iufgeifagaifeu eg iu")
            
            self.commentlbl.numberOfLines = 0
            Database.database().reference().child("users").child(cPost.uid).child("email").observe(.value, with:{(snapshot) in
                let uservalue = snapshot.value as! String
                self.username.text = "  \(uservalue)  "
            })
            
        }
        
    }
    
}
