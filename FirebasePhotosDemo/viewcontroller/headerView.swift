//
//  headerView.swift
//  Instragram
//
//  Created by Ahmad Idigov on 10.12.15.
//  Copyright © 2015 Akhmed Idigov. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

protocol headerDelegate {
    func toPeers(peer:String)
}
class headerView: UICollectionReusableView {
    @IBOutlet var messageButton: UIButton!
    @IBOutlet var bgimg: UIImageView!
    @IBOutlet var proIMG: UIImageView!
    @IBOutlet var puser: UILabel!
    @IBOutlet var nPosts: UILabel!
    @IBOutlet var nPeers: UILabel!
    @IBOutlet var nLikes: UILabel!
    @IBOutlet var pheader: UIView!
    @IBOutlet var followButton: UIButton!
    @IBOutlet var container: UIView!
    @IBOutlet var imgcont: UIView!
    var delegate : headerDelegate?
    var gcolor = UIColor.init(red: 71/255, green: 180/255, blue: 254/255, alpha: 1)
    @IBAction func toPosts(_ sender: Any) {
        
    }
 
    @IBAction func toLikes(_ sender: Any) {
        
    }
    @IBAction func toPeers(_ sender: Any) {
        delegate?.toPeers(peer: LoginViewController.GlobalVariable.inuseUID)
    }
    @IBAction func message(_ sender: Any) {
    }
    
    func not(){
      
    }
    func upUI(){
        self.proIMG.image = nil
//        let testLayer:CALayer = {
//           let layer = CALayer()
//            layer.applySketchShadow()
//            return layer
//        }()
//       self.proIMG.layer.insertSublayer(testLayer, at: 0)
      self.followButton.layer.shadowColor = UIColor.black.cgColor
        self.followButton.layer.shadowOpacity = 0.5
        self.followButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.followButton.layer.shadowRadius = 1
        
        self.messageButton.isHidden = false
        
        self.bgimg.clipsToBounds = true
//        self.imgcont.clipsToBounds = true
       // self.bgimg.layer.cornerRadius = 16
        // self.bgimg.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        //self.imgcont.layer.cornerRadius = 16
       // self.imgcont.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        print(LoginViewController.GlobalVariable.inuseUID)
    self.followButton.layer.cornerRadius = 25
//self.proIMG.cornerRadius = proIMG.frame.size.width/2
        self.messageButton.cornerRadius = messageButton.frame.size.width/2
        
    self.followButton.clipsToBounds = true
    //self.pheader.layer.applySketchShadow(color: gcolor, alpha: 0.38, x: 0, y: 1, blur: 17, spread: 1)
    
    Database.database().reference().child("users").child(LoginViewController.GlobalVariable.inuseUID).child("userImg").observe(.value, with: {(snap: DataSnapshot) in



    let imageUrl = snap.value as! String
        let resource = ImageResource(downloadURL: URL(string:imageUrl)!, cacheKey: imageUrl)
            self.proIMG.kf.setImage(with: resource)
//            self.proIMG.layer.cornerRadius = self.proIMG.frame.size.width / 2
//            self.proIMG.clipsToBounds = true
        self.proIMG.layer.applySketchShadow(color: UIColor.black, alpha: 0.13, x: 0, y: 22, blur: 14, spread: 0)
        self.proIMG.layer.masksToBounds = true
       // self.proIMG.generateOuterShadow()
        
        
    
    })
    Database.database().reference().child("users").child(LoginViewController.GlobalVariable.inuseUID).child("email").observe(.value, with: {(snap:DataSnapshot) in
    let val = snap.value
    self.puser.text = val as? String

    })
    Database.database().reference().child("users").child(LoginViewController.GlobalVariable.inuseUID).child("mypics").observe(.value, with: {(snapshot) in
        let vlue = Int(snapshot.childrenCount)
        self.nPosts.text = "\(vlue)"
        
    })
        Database.database().reference().child("users").child(LoginViewController.GlobalVariable.inuseUID).child("likes").observe(.value, with: {(snapshot) in
            let vlue = Int(snapshot.childrenCount)
            self.nLikes.text = "\(vlue)"
            
        })
        Database.database().reference().child("users").child(LoginViewController.GlobalVariable.inuseUID).child("peers").observe(.value, with: {(snapshot) in
            let vlue = Int(snapshot.childrenCount)
            self.nPeers.text = "\(vlue)"
            
        })
        
        // Do any additional setup after loading the view.
    }
    

    
}
    /*
    0894FE
    13C5FF
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
extension UIView{
    open func generateOuterShadow() {
        
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = layer.cornerRadius
        view.layer.shadowRadius = layer.shadowRadius
        view.layer.shadowOpacity = layer.shadowOpacity
        view.layer.shadowColor = layer.shadowColor
        view.layer.shadowOffset = CGSize.zero
        view.clipsToBounds = false
        view.backgroundColor = .white
        
        superview?.insertSubview(view, belowSubview: self)
        
        let constraints = [
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            ]
        superview?.addConstraints(constraints)
    }
}


