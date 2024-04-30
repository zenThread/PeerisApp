//
//  messagesTableViewCell.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 10/23/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import Kingfisher

class messagesTableViewCell: UITableViewCell {

    @IBOutlet var timestamp: UILabel!

    @IBOutlet weak var unread: UILabel!
    @IBOutlet var msg: UILabel!
    @IBOutlet var username: UILabel!
    @IBOutlet var msgimg: UIImageView!
    var iurl : String!
   
    var msglist : msglist! {
        didSet {
            self.upUI()
        }
    }
  

    func upUI(){

        timestamp.clipsToBounds = true
        timestamp.layer.cornerRadius = 11
        
      msg.sizeToFit()
        msgimg.layer.cornerRadius = msgimg.frame.size.width/2
        msgimg.clipsToBounds = true
        content()
    }
    func content(){
        
        Database.database().reference().child("users").child(msglist.altuid).observe(.value, with: {(snapshot) in
            let json = JSON(snapshot.value ?? "")
           
           self.username.text = json["email"].stringValue
          print(self.username.text!)
        })
        Database.database().reference().child("users").child(msglist.altuid).child("userImg").observe(.value, with: {(snapshot) in
           self.iurl = snapshot.value as! String
            let resource = ImageResource(downloadURL: URL(string:self.iurl)!, cacheKey: self.iurl)
            
            self.msgimg.kf.setImage(with: resource)
//            self.msgimg.layer.borderColor = UIColor.init(red: 19/255, green: 98/255, blue: 127/255, alpha: 1).cgColor
//            self.msgimg.layer.borderWidth = 1
            
        })
        Database.database().reference().child("messages").child(msglist.source).observe(.childAdded, with: {(snapshot) in
            let json = JSON(snapshot.value ?? "")
            self.msg.text = json["txt"].stringValue
            
        })
        
    }
}
