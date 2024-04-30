//
//  chatviewcontrollerViewController.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 10/24/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import SwiftyJSON
class chatviewcontrollerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    var chats = [chat]()
    @IBOutlet var chatTV: UITableView!
    @IBOutlet var newchat: UITextField!
    @IBOutlet var send: UIButton!
    @IBOutlet var inputview: UIView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.chats[indexPath.row].sender == Auth.auth().currentUser?.uid{
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! chatcell
        cell.chats = self.chats[indexPath.row]
        
            cell.chatbubble.clipsToBounds = true
            cell.chatbubble.layer.cornerRadius = cell.chatbubble.frame.size.height/2
            //  chatbubble.layer.maskedCorners = [.layerMinXMinYCorner]
            cell.chat.numberOfLines = 0
            cell.chat.text = cell.chats.text
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return cell
        
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chat", for: indexPath) as! chatcell
            cell.chats = self.chats[indexPath.row]
            Database.database().reference().child("users").child(cell.chats.sender).observe(.value, with:{(snap) in
                let json = JSON(snap.value ?? "")
                
                let imageDownloadURL = json["userImg"].stringValue
                cell.name.text = json["email"].stringValue
                let resource = ImageResource(downloadURL: URL(string:imageDownloadURL)!, cacheKey: imageDownloadURL)
                cell.altImage.kf.setImage(with: resource)
            })
            cell.chatbubble.layer.applySketchShadow(color: UIColor.black, alpha: 0.11, x: 1, y: 0, blur: 10, spread: 0)
            
            cell.chatbubble.layer.masksToBounds = false
            cell.chatbubble.clipsToBounds = false
            cell.chatbubble.layer.cornerRadius = 7
            cell.chat.numberOfLines = 0
            cell.chat.text = cell.chats.text
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newchat.delegate = self
        
        chatTV.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.navigationController?.navigationBar.setBackgroundImage(, for: .default) imageLiteral(resourceName: "commentButton")
        self.inputview.clipsToBounds = true
        self.inputview.layer.borderColor = UIColor.init(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).cgColor
        self.inputview.layer.borderWidth = 1
     
        newchat.layer.borderWidth = 0
        newchat.borderStyle = .none
        send.clipsToBounds = true
       send.layer.cornerRadius = 13
    
        Database.database().reference().child("messages").child(LoginViewController.GlobalVariable.myString).observe(.childAdded, with: { (snapshot) in
           // self.chatTV.reloadData()
            DispatchQueue.main.async {
                
                
                // 2 - Parse each of the post
                let newPost = chat(snapshot: snapshot)
                
                
                self.chats.insert(newPost, at: 0)
               
                // 3 - Update the tableView
                let indexPath = IndexPath(row: 0, section: 0)
                
                self.chatTV.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                               // self.chatTV.reloadData()
            }
            
        })
    }


    @IBAction func sndbutton(_ sender: Any) {
        let newdict = [
            "txt" : self.newchat.text! ,
            "uid" : Auth.auth().currentUser?.uid ?? "",
        "time" : NSDate().timeIntervalSince1970
            
            ] as [String : Any]
        Database.database().reference().child("messages").child(LoginViewController.GlobalVariable.myString).childByAutoId().setValue(newdict)
        self.newchat.text = ""
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    
    

}
