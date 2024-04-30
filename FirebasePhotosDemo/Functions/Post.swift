//
//  AppDelegate.swift
//  FirebasePhotosDemo
//
//  Created by YanTech on 30/12/17.
//  Copyright © 2017 YanTech. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class Post {
    
    // Variables
    var caption : String!
    var imageDownloadURL : String!
    var UID : String!
    var _likes : Int!
    var em : String!
    var num = 0
    var peers : String!
    var txt : Bool!
    var key : String!
    var email : String!
    var desc : String!
    
    
    private var image : UIImage!
    
    
    // Iniotialization of the variables
    init(image : UIImage, caption : String, desc:String) {
        self.caption = caption
        self.image = image
        self.desc = desc
        //self._likes = _likes
    }
    
    // Snapshot the bdata
    init(snapshot : DataSnapshot) {
        let json = JSON(snapshot.value ?? "")
        self.key = snapshot.key
        self.caption = json["caption"].stringValue
        self.imageDownloadURL = json["imageDownloadURL"].stringValue
        self.UID = json["UID"].stringValue
        self._likes = json["likes"].intValue
        self.txt = json["txt"].boolValue
        self.email = json["email"].stringValue
        self.desc = json["text"].stringValue
    }
    func adjustLikes(addLike: Bool, _postRef: DatabaseReference) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        
        _postRef.setValue(_likes)
    }
    // Function to save the newPost
    func save() {
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("email").observe(.value, with: {(snap: DataSnapshot) in
            self.em = snap.value as! String
            
            
        })
        
        let myp = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("mypics").childByAutoId()
        // 1 - Create a new Database Reference
        let newPostRef = Database.database().reference().child("posts").childByAutoId()
        let newPostKey = newPostRef.key
//        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("peers").observe(.value, with:{ (snap:DataSnapshot) in
//            self.num = (Int(snap.childrenCount))
//            let json = JSON(snap.value!)//fix child added vs value^^^
//            self.peers = json["uid"].stringValue
//            let newgroup = Database.database().reference().child("users").child(self.peers).child("groups").childByAutoId()
//
//            for n in 0...(self.num){
//                print(n)
//                    let dict = [
//                        "pkey" : newPostKey
//                    ]
//                    newgroup.setValue(dict)
//
//            }
//        })
//        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("peers").observe(.childAdded, with:{(snapshot) in
//            let json = JSON(snapshot.value ?? "")
//            let peer = json["uid"].stringValue
//            let reff = Database.database().reference().child("users").child(peer).child("groups").childByAutoId()
//            let ndict = [
//                "id" : newPostKey
//            ]
//            reff.setValue(ndict)
//
//        })
//       let sn = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("groups").childByAutoId()
//        let mygroup = [
//            "id" : newPostKey
//        ]
//        sn.setValue(mygroup)
        // Convert image into data
        if let imageData = self.image.jpegData(compressionQuality: 0.6) {
            
            // 2 - Create a new Strage Reference
            let imageStorageRef = Storage.storage().reference().child("images")
            let newImageRef = imageStorageRef.child(newPostKey!)
            
            // 3 - Save the image to the storage URL
            newImageRef.putData(imageData).observe(.success, handler: { (snapshot) in
                
                // 4 - Save the post caption & download URL
                
                snapshot.reference.downloadURL { (durl, error) -> Void in
                    if (error != nil) {
                       print("(error) THIS IS THE IMAGE DOWNLOAD URL: \(durl!.absoluteString)")
                    } else {
                        // Get the download URL for 'images/stars.jpg'
                         print("THIS IS THE IMAGE DOWNLOAD URL: \(durl!.absoluteString)")
                         //self.imageDownloadURL = durl!.absoluteString
                       
                        // you will get the String of Url
                        let newDictionary = [
                            "imageDownloadURL" : durl?.absoluteString,
                            "caption" : self.caption,
                            "likes" : "0",
                            "UID" : (Auth.auth().currentUser?.uid)!,
                            "email" : self.em,
                            "algo" : "5",
                            "text": self.desc,
                            "time" : NSNumber(value: NSDate().timeIntervalSince1970).intValue
                            
                            ] as [String : Any]
                        
                        newPostRef.setValue(newDictionary)
                        
                        let newp = [
                            "url" : durl?.absoluteString,
                            "key" : newPostKey
                        ]
                        myp.setValue(newp)

                    }
                }
                
            })
            
        }
        
        
    }


}








