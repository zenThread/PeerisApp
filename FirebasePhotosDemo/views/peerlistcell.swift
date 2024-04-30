//
//  peerlistcell.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 8/9/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
class peerlistcell: UITableViewCell {

    var peers : peers! {
        didSet {
            self.updateUI()
        }
    }
    @IBOutlet var proimg: UIImageView!
    
    @IBOutlet var name: UILabel!
    func updateUI(){
        
        Database.database().reference().child("users").child(peers.username).child("email").observe(.value, with: {(snap:DataSnapshot) in
            let email = snap.value
            self.name.text = email as? String
        } )
        Database.database().reference().child("users").child(peers.username).child("userImg").observe(.value, with: {(snap: DataSnapshot) in
            
            
            let imageUrl = snap.value
            
            let storage = Storage.storage()
            _ = storage.reference()
            let ref = storage.reference(forURL: imageUrl as! String)
            ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    print("something wrong")
                } else {
                    
                    self.proimg.image = UIImage(data: data!)
                    self.proimg.layer.cornerRadius = self.proimg.frame.size.width / 2
                    self.proimg.clipsToBounds = true
                    
                    //
                }
            }
        })
    }

}
