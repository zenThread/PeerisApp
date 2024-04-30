//
//  AppDelegate.swift
//  FirebasePhotosDemo
//
//  Created by YanTech on 30/12/17.
//  Copyright © 2017 YanTech. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import Kingfisher

protocol PhotoCellDelegate {
    func pressComment(comment:String)
    func tapPic()
    func pressMore(more:String,inUse:String)
   
}
protocol tableDelegate {
    func tapPic()
}
class PhotoTableViewCell: UITableViewCell {
    
    
    var post : Post! {
        didSet {
            self.updateUI()
        }
    }
    
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    
    @IBOutlet weak var cellURL: UILabel!
    @IBOutlet weak var proIMG: UIImageView!
    @IBOutlet weak var descript: UILabel!
    @IBOutlet var timelbl: UILabel!
    @IBOutlet var likelbl: UILabel!
    @IBOutlet weak var postBar: UIView!
    // @IBOutlet weak var postAttech: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var proView: UIView!
    @IBOutlet var commCount: UILabel!
    var likeref: DatabaseReference!
    //@IBOutlet weak var postAttech: UIView!
    var delegate: PhotoCellDelegate?
    var delegates: tableDelegate?
    var now = NSDate().timeIntervalSince1970
    var past : Int!
    var v: Double!
    var x: Double!
    var k: String!
    var secs: Double!
    var times = "   7d ago   "
    
    @IBAction func comnfunc(_ sender: Any) {
        
        delegate?.pressComment(comment: post.key)
    }
    
    @IBAction func moreButton(_ sender: Any) {
        delegate?.pressMore(more: post.key, inUse: post.UID)
    }
    
    @IBAction func like(_ sender: Any) {
        //self.likeButton.isEnabled = false
        let uid = KeychainWrapper.standard.string(forKey: "uid")
        let ref = Database.database().reference().child("users").child(uid!).child("likes").child(post.key!)
     likeref = Database.database().reference().child("posts").child(post.key!).child("likes")
        //let keyToPost = ref.child("posts").childByAutoId().key
        
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                //self.likeButton.isEnabled = false
                self.post.adjustLikes(addLike: true, _postRef : self.likeref)
                //update in firebase
                ref.setValue(true)
                self.likeButton.setImage(UIImage(named:"likeButton"), for: .normal)
                self.relike()
            } else {
                //self.likeButton.isEnabled = true
                self.post.adjustLikes(addLike: false, _postRef : self.likeref)
                self.likeButton.setImage(UIImage(named:"likeButton"), for: .normal)
                ref.removeValue()
                self.relike()
            }
            
                })
            }
            
            
    
    
    func relike(){
        Database.database().reference().child("posts").child((post.key!)).child("likes").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            // print((self?.cellURL.text!)!)
            let sv = snapshot.value
            let mr = String(describing: sv!)
            
            self.likelbl.text = ("\(mr) likes")
            // ...
        })
    }
    @objc func taps(sender: UITapGestureRecognizer){
        LoginViewController.GlobalVariable.inuseUID = post.UID
        delegate?.tapPic()
        
    }
    func get(){
        
        Database.database().reference().child("posts").child(post.key).child("time").observe(.value, with: {(snapshot) in
            self.past = snapshot.value as! Int
            
            
            let uu:Int? = Int(self.past)//the past date
            let ff = Double(uu!)
            let newnow = (self.now - ff)
            //print(self.now)
            //print(self.past)
           
            
            let myTimeInterval = TimeInterval(self.now)
            let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
            
            
            if newnow < 3600{//mins
                self.v = newnow
                self.x = 60
                self.k = "m ago"
                self.timeread()
            }else if newnow < 86400{
                self.v = newnow
                self.x = 3600
                self.k = "h ago"
                self.timeread()
            }else if newnow < 2592000{
                self.v = newnow
                self.x = 86400
                self.k = "d ago"
                self.timeread()
            }else{
                self.v = newnow
                self.x = 2592000
                self.k = "mo ago"
                self.timeread()
            }
        })
    }
    
    
    func timeread(){
        let hh = floor(self.v/self.x)
        
        let integer = NSNumber(value: hh).stringValue
        let n = "   \(integer)\(k!)   "
        
        self.timelbl.text = n
        self.timelbl.isHidden = false
        
    }
    func updateUI() {
        self.descript.text = "nothing here to see"
        design()
        // Download the post photo from Firebase
        get()
        profile()
        content()
        setuplike()
    }
    func design(){
        
        timelbl.layer.cornerRadius = 8
    
        proView.layer.applySketchShadow(color: UIColor.black, alpha: 0.09, x: 0, y: 0, blur: 11, spread: 0)
        postBar.layer.applySketchShadow(color: UIColor.black, alpha: 0.09, x: 0, y: 0, blur: 11, spread: 0)
        //proView.layer.shadowPath = UIBezierPath(rect: proView.bounds).cgPath
//        proView.layer.shadowColor = UIColor.black.cgColor
//        proView.layer.shadowOpacity = 0.12
//        proView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        proView.layer.shadowRadius = 1
//        //proView.layer.masksToBounds = false
//        // Caption
//        postBar.layer.shadowColor = UIColor.black.cgColor
//        postBar.layer.shadowOpacity = 0.12
//        postBar.layer.shadowOffset = CGSize(width: 0, height: 0)
//        postBar.layer.shadowRadius = 1
        self.descript.text = post.desc
        self.captionLabel.text = post.caption
      
        
       
        self.captionLabel.numberOfLines = 0
        self.proView.layer.cornerRadius = 6
        self.proView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.postBar.layer.cornerRadius = 6
        
        
        
        self.postBar.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        /// self.postAttech.layer.cornerRadius = 15
        //self.proView.layer.borderWidth = 1
        // self.proView.layer.borderColor = UIColor.darkGray.cgColor
        
    }
    func setuplike(){
        Database.database().reference().child("posts").child(self.post.key).child("comments").observe(.value, with:{(snapshot) in
            
            let snp = snapshot.childrenCount
            let kk = Int(snp)
            
            self.commCount.text = ("\(kk) comments")
            
        })
        Database.database().reference().child("posts").child((self.post.key)!).child("likes").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            // print((self?.cellURL.text!)!)
            let sv = snapshot.value
            let mr = String(describing: sv!)
            
            self.likelbl.text = ("\(mr) likes")
            // ...
        })
        
        
        // print((self?.cellURL.text!)!)
        Database.database().reference().child("users").child(post.UID!).child("likes").child((self.post.key!)).observeSingleEvent(of: .value, with: { (snapshot) in
            
            //print(snapshot.value!)
            if let _ = snapshot.value as? NSNull {
                self.likeButton.isEnabled = true
                self.likeButton.setImage(UIImage(named:"likeButton"), for: .normal)
            } else {
                self.likeButton.isEnabled = true
                self.likeButton.setImage(UIImage(named:"likeButton"), for: .normal)
            }
            
        })
    }
    func profile(){
        let UID = post.UID
        // print(UID!)
        Database.database().reference().child("users").child(UID!).child("userImg").observe(.value, with: {(snap: DataSnapshot) in
            
            
            
            let imageUrl = snap.value
            
            let storage = Storage.storage()
            _ = storage.reference()
            let ref = storage.reference(forURL: imageUrl as! String)
            ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    print("something wrong")
                } else {
                    self.proIMG.image = UIImage(data: data!)
                    self.proIMG.layer.cornerRadius = self.proIMG.frame.size.width / 2
                    self.proIMG.clipsToBounds = true
                    self.proIMG.isUserInteractionEnabled = true
                    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(PhotoTableViewCell.taps(sender:)))
                    self.proIMG.addGestureRecognizer(tapRecognizer)
                    
                    Database.database().reference().child("users").child(UID!).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        
                        let value = snapshot.value
                        let email = value as! String
                        
                        self.user.text = email
                        
                        // ...
                    }) { (error) in
                        
                        print("no user")
                    }
                }
            }
        })
    }
    
    func content(){
            let imageDownloadURL = post.imageDownloadURL
                        let resource = ImageResource(downloadURL: URL(string:imageDownloadURL!)!, cacheKey: imageDownloadURL!)
                            self.postImageView.kf.setImage(with: resource)
                            self.postImageView.isHidden = false
                            self.postImageView.layer.cornerRadius = 8

    }
}
















