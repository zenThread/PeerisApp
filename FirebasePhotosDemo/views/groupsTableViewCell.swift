//
//  groupsTableViewCell.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 7/17/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import SwiftyJSON
import Kingfisher
protocol GroupCellDelegate {
   // func pressProfile(UUID:String)
    func pressEdit(edit:String)
    func tapcom()
}
class groupsTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.tests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = testcoll.dequeueReusableCell(withReuseIdentifier: "ccell", for: indexPath) as! capCollectionViewCell
        cell.test = self.tests[indexPath.row]
        cell.bluebox.layer.cornerRadius = 6
            cell.ltxt.text = cell.test.captext
        cell.ltxt.numberOfLines = 0
        cell.ltxt.sizeToFit()
        let x = cell.bluebox.frame.size.width / 2
        let y = cell.bluebox.frame.size.height / 2
    
            cell.topSpace.constant = ((CGFloat(cell.test.yposition) * cell.frame.size.height) - y)
      //  print("left constraint is \(cell.leftSpace.constant)")
        let leftspace = ((CGFloat(cell.test.xposition)*cell.frame.size.width)-x)
        
        //let tot = leftspace + cell.bluebox.frame.size.width
        print("text box length: \(cell.bluebox.frame.size.width), text length: \((cell.ltxt.frame.size.width) + 16) ")
       
        cell.leftSpace.constant = leftspace
        
        
//        if (tot) > cell.frame.size.width{
//            cell.leftSpace.constant = cell.frame.size.width - x
//        } else {
//            cell.leftSpace.constant = leftspace
//        }
     
        

        
        
       
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: postImageView.layer.frame.width , height: postImageView.layer.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
        
    }
  
    

    var post : Post! {
        didSet {
            self.updateUI()
        }
    }
    var tests = [test]()
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    
    @IBOutlet weak var cellURL: UILabel!
    @IBOutlet weak var proIMG: UIImageView!
    
    @IBOutlet weak var lview: UIView!
    @IBOutlet var limg: UIImageView!
    @IBOutlet var com: UILabel!
    @IBOutlet var commbox: UIView!
    @IBOutlet var commimg: UIImageView!
    //@IBOutlet weak var postBar: UIView!
    // @IBOutlet weak var postAttech: UIView!
   // @IBOutlet weak var likeButton: UIButton!
    //@IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var user: UILabel!
    //@IBOutlet weak var proView: UIView!
    @IBOutlet var postview: UIView!
    
    @IBOutlet var testcoll: UICollectionView!
    @IBOutlet var cimg: UIImageView!
    @IBOutlet var comnumview: UIView!
    @IBOutlet var likenumview: UIView!
    @IBOutlet var grouplikenum: UILabel!
    //@IBOutlet weak var postAttech: UIView!
    var delegate: GroupCellDelegate?
    var likeref: DatabaseReference!
    var link: String!
    var comT: String!
    var countz = 0
    var tst = "not"
    
    
    @IBAction func profPress(_ sender: Any) {
        
        //delegate?.pressProfile(UUID: cellURL.text!)
    }
    @objc func tapc(sender: UITapGestureRecognizer){
        LoginViewController.GlobalVariable.myString = post.key
        delegate?.tapcom()
    }
    @objc func taps(sender: UITapGestureRecognizer){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(uid!).child("likes").child(post.key!)
        likeref = Database.database().reference().child("posts").child(post.key!).child("likes")
        //let keyToPost = ref.child("posts").childByAutoId().key
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                //self.likeButton.isEnabled = false
                self.post.adjustLikes(addLike: true, _postRef : self.likeref)
                //update in firebase
                ref.setValue(true)
                self.limg.image = UIImage(named:"likeButton")
            self.limg.layer.borderWidth = 1
                self.limg.layer.borderColor = UIColor.init(red: 0/255, green: 164/255, blue: 207/255, alpha: 1).cgColor
                self.relike()
            } else {
                //self.likeButton.isEnabled = true
                self.post.adjustLikes(addLike: false, _postRef : self.likeref)
                self.limg.image = UIImage(named:"likeButton")
                self.limg.layer.borderWidth = 0
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
            
            self.grouplikenum.text = ("\(mr)")
            // ...
        })
    }
    @IBAction func editbutton(_ sender: Any) {
        
        delegate?.pressEdit(edit: post.key)
    }
    
    func collui(){
        
       // if self.tests.count == 0{
        Database.database().reference().child("posts").child(post.key).child("caps").observe(.childAdded, with: { (snapshot) in
            DispatchQueue.main.async {
               // self.testcoll.numberOfItems(inSection: 0)
                //self.tests.removeAll()
            
            
            let newimages = test(snapshot: snapshot)
                
            //let indexPath = IndexPath(row: 0, section: 0)
                
            self.tests.insert(newimages, at: 0)
                
          //  self.testcoll.insertItems(at: [indexPath])
            self.testcoll.reloadData()
            }
        })
       /// }else{
            
        //}
    }
    
    
    func content(){
        let imageDownloadURL = post.imageDownloadURL
        let resource = ImageResource(downloadURL: URL(string:imageDownloadURL!)!, cacheKey: imageDownloadURL!)
        
        self.postImageView.kf.setImage(with: resource)
        self.cimg.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(groupsTableViewCell.tapc(sender:)))
      self.cimg.addGestureRecognizer(tapRecognizer)
        self.collui()
        
       
    }
    func setuplike(){
        Database.database().reference().child("posts").child((self.post.key)!).child("likes").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            // print((self?.cellURL.text!)!)
            let sv = snapshot.value
            let mr = String(describing: sv!)
            
            self.grouplikenum.text = ("\(mr)")
            // ...
        })
    }
    func design(){
        self.comnumview.layer.cornerRadius = 6
        self.likenumview.layer.cornerRadius = 6
        self.comnumview.clipsToBounds = true
        self.likenumview.clipsToBounds = true
        
        
        
        self.cimg.layer.cornerRadius = cimg.frame.size.width/2
        self.cimg.clipsToBounds = true
        self.lview.layer.cornerRadius = lview.frame.size.width/2
        self.lview.clipsToBounds = true
        self.limg.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(PhotoTableViewCell.taps(sender:)))
        self.limg.addGestureRecognizer(tapRecognizer)

        self.postImageView.clipsToBounds = true
        self.postImageView.layer.cornerRadius = 10
        self.postImageView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        postview.layer.shadowColor = UIColor.black.cgColor
        postview.layer.shadowOpacity = 0.3
        postview.layer.shadowOffset = CGSize(width: 0, height: 0)
        postview.layer.shadowRadius = 1
        
        self.postview.layer.cornerRadius = 10
        self.postview.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        self.captionLabel.text = post.caption
        self.captionLabel.numberOfLines = 0
        //postImageView.layer.cornerRadius = 8
        
    }
    func proinfo(){
       
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
                }
            }
        })
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
   
    func updateUI() {
        
        self.testcoll.delegate = self
        self.testcoll.dataSource = self
        design()
        proinfo()
        content()
        setuplike()
        
       
    }

}
//                            let image = UIImage(data: imageData)
//                            self?.postImageView.image = image
//
//                            self?.cellURL.text = imageStorageRef.name
//                             //print((self?.cellURL.text!)!)
//

