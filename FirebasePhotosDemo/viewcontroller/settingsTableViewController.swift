//
//  settingsTableViewController.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 11/15/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher


class settingsTableViewController: UIViewController {

    @IBOutlet weak var userBack: UIImageView!
    @IBOutlet weak var userPic: UIImageView!
    
    let get = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
    override func viewDidLoad() {
        super.viewDidLoad()
        get.child("userImg").observe(.value, with: {(snapshot) in
            let snap = snapshot.value
            let imageDownloadURL = snap as! String
            print(imageDownloadURL)
            let resource = ImageResource(downloadURL: URL(string:imageDownloadURL)!, cacheKey: imageDownloadURL)
            self.userPic.kf.setImage(with: resource)
             self.userBack.kf.setImage(with: resource)
           
        })
        self.userBack.clipsToBounds = true
        self.userBack.layer.cornerRadius = 5
        self.userPic.layer.cornerRadius = 75
        self.userPic.clipsToBounds = true
        
    
    }

    

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
 
}
