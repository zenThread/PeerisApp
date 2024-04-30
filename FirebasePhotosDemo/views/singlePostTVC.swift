//
//  singlePostTVC.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 7/25/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import SwiftyJSON

class singlePostTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("captions: \(self.tests.count)")
       return self.tests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tstcoll.dequeueReusableCell(withReuseIdentifier: "ccell2", for: indexPath) as! capCollectionViewCell
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: img.layer.frame.width , height: img.layer.frame.height)
    }
    
  
    var tests = [test]()
    @IBOutlet weak var singleview: UIView!
    @IBOutlet weak var proIMG: UIImageView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var tstcoll: UICollectionView!
    
    @IBOutlet weak var decript: UILabel!
    @IBOutlet var titleOfComment: UILabel!
    @IBOutlet weak var likes: UILabel!
    var eml: String!
    
   // @IBOutlet var commentView: UITextView!
    
    @IBOutlet weak var profile: UILabel!
    
    func collSetUp(){
        self.tstcoll.delegate = self
        self.tstcoll.dataSource = self
       
        Database.database().reference().child("posts").child(LoginViewController.GlobalVariable.myString).child("caps").observe(.childAdded, with: { (snapshot) in
            DispatchQueue.main.async {
                // self.testcoll.numberOfItems(inSection: 0)
                //self.tests.removeAll()
                
                
                let newimages = test(snapshot: snapshot)
                
                //let indexPath = IndexPath(row: 0, section: 0)
                
                self.tests.insert(newimages, at: 0)
               
                //self.tstcoll.insertItems(at: [indexPath])
                self.tstcoll.reloadData()
              
            }
        })
    }
  
   
     func upUI() {
       
    
        print("number of loops:")
        
        Database.database().reference().child("posts").child(LoginViewController.GlobalVariable.myString).observe(.value, with: {(snps) in
            
            let json = JSON(snps.value ?? "")
            self.titleOfComment.text = json["caption"].stringValue
           // self.decript.text = json["text"].stringValue
             
            
            let ls = json["likes"].stringValue
            self.likes.text = ("\(ls) Likes")
        })
       
        self.singleview.layer.applySketchShadow(color: UIColor.black, alpha: 0.11, x: 0, y: -6, blur: 22, spread: 0)
       // self.singleview.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        Database.database().reference().child("posts").child(LoginViewController.GlobalVariable.myString).child("imageDownloadURL").observeSingleEvent(of: .value, with: { (snapshot) in
            let imageUrl = snapshot.value as! String
            let resource = ImageResource(downloadURL: URL(string:imageUrl)!, cacheKey: imageUrl)
            self.img.kf.setImage(with: resource)
           
        })
//        Database.database().reference().child("posts").child(LoginViewController.GlobalVariable.myString).child("text").observe(.value, with:{(snapshot) in
//            let textCap = snapshot.value
//
//        })
        

        
        Database.database().reference().child("posts").child(LoginViewController.GlobalVariable.myString).child("UID").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            let value = snapshot.value
            let email = value as! String
            Database.database().reference().child("users").child(email).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
                let val = snapshot.value
                let i = val as! String
                self.profile.text = i
            })
            //self.profile.text = email
            self.eml = email
            Database.database().reference().child("users").child(self.eml).child("userImg").observe(.value, with: {(snap: DataSnapshot) in
                
                
                let imageUrl = snap.value as! String
                
                let resource = ImageResource(downloadURL: URL(string:imageUrl)!, cacheKey: imageUrl)
                self.proIMG.kf.setImage(with: resource)
                        
                        
                        
//                        self.proIMG.image = UIImage(data: data!)
                        self.proIMG.layer.cornerRadius = self.proIMG.frame.size.width / 2
                        self.proIMG.clipsToBounds = true
                        self.proIMG.layer.borderWidth = 0.2
                        self.proIMG.layer.borderColor = UIColor.black.cgColor
                        //self.commentView.text = yy
               
            })
            // ...
        })
        
        
       collSetUp()
        
        
        
    }
}
