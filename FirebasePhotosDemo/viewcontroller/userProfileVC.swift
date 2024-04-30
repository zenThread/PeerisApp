//
//  userProfileVC.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 6/6/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
class userProfileVC: UIViewController {

    @IBOutlet weak var proIMG: UIImageView!
    
    @IBOutlet var puser: UILabel!
    @IBOutlet var pheader: UIView!
    @IBOutlet var followButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.followButton.layer.cornerRadius = 25
        
        self.followButton.clipsToBounds = true
        self.pheader.layer.cornerRadius = 15
        
        
        self.pheader.clipsToBounds = true
        Database.database().reference().child("users").child(LoginViewController.GlobalVariable.inuseUID).child("userImg").observe(.value, with: {(snap: DataSnapshot) in
            
            
            
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
                    self.proIMG.layer.borderWidth = 3
                    
                    self.proIMG.layer.borderColor = UIColor.white.cgColor
                }
            }
        })
        Database.database().reference().child("users").child(LoginViewController.GlobalVariable.inuseUID).child("email").observe(.value, with: {(snap:DataSnapshot) in
            let val = snap.value
            self.puser.text = val as? String
            
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
