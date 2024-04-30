//
//  editorVC.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 10/5/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class editorVC: UIViewController,UITextFieldDelegate {

    @IBOutlet var sendB: UIBarButtonItem!
    @IBOutlet var capOut: UILabel!
    @IBOutlet var capinput: UITextField!
    @IBOutlet var viewDrag: UIView!
    @IBOutlet var ocCaption: UILabel!
    @IBOutlet var mainIMG: UIImageView!
    @IBOutlet var proIMG: UIImageView!
    @IBOutlet var roundview: UIView!
    
    var panGesture = UIPanGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        roundview.clipsToBounds = true
        roundview.layer.cornerRadius = 10
        roundview.layer.shadowColor = UIColor.black.cgColor
        roundview.layer.shadowOpacity = 0.3
        roundview.layer.shadowOffset = CGSize(width: 0, height: 0)
        roundview.layer.shadowRadius = 1
        capinput.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(editorVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editorVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
         print(LoginViewController.GlobalVariable.myString)
       let dbref = Database.database().reference()
        dbref.child("posts").child(LoginViewController.GlobalVariable.myString).observe(.value, with: {(snapshot) in
            let val = JSON(snapshot.value)
            let nurl = val["imageDownloadURL"].stringValue
           
            
            let storage = Storage.storage()
            _ = storage.reference()
            let ref = storage.reference(forURL: nurl )
            ref.getData(maxSize: 2 * 1024 * 1024) { data, error in
                if error != nil {
                    print("something wrong")
                } else {
                    
                    
                    
                    self.mainIMG.image = UIImage(data: data!)
                    self.mainIMG.clipsToBounds = true
                    
                    
                }
            }
            let nUID = val["UID"].stringValue
            let ncap = val["caption"].stringValue
            self.ocCaption.text = ncap
            dbref.child("users").child(nUID).child("userImg").observe(.value, with: {(snap:DataSnapshot) in
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
            
            
        })
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        capinput.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    @IBAction func send(_ sender: Any) {
        let newx = viewDrag.center.x/mainIMG.frame.size.width
        let newy = viewDrag.center.y/mainIMG.frame.size.height
        let dict = [
            "x" : newx,
            "y" : newy,
            "ctext" : capOut.text!
            ] as [String : Any]
        Database.database().reference().child("posts").child(LoginViewController.GlobalVariable.myString).child("caps").childByAutoId().setValue(dict)
         dismiss(animated: true, completion: nil)
    }
    @IBAction func confirmButton(_ sender: Any) {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(editorVC.draggedView(_:)))
        viewDrag.isUserInteractionEnabled = true
        viewDrag.addGestureRecognizer(panGesture)
        capOut.text = capinput.text
        viewDrag.alpha = 1
        capinput.text = ""
        sendB.isEnabled = true
        
       
        
    }
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(editorVC.draggedView(_:)))
        self.view.bringSubviewToFront(viewDrag)
        let translation = sender.translation(in: self.view)
        
       
        viewDrag.center = CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
        if viewDrag.center.x <= viewDrag.frame.size.width/2{
            viewDrag.center.x = viewDrag.frame.size.width/2
            
        }else if viewDrag.center.x >= (mainIMG.frame.size.width - (viewDrag.frame.size.width/2)){
            viewDrag.center.x = mainIMG.frame.size.width - viewDrag.frame.size.width/2
        }
        if viewDrag.center.y <= viewDrag.frame.size.height/2{
            viewDrag.center.y = viewDrag.frame.size.height/2
            
        }else if viewDrag.center.y >= (mainIMG.frame.size.height - (viewDrag.frame.size.height/2)){
            viewDrag.center.y = mainIMG.frame.size.height - viewDrag.frame.size.height/2
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
        print(viewDrag.center.y)
        print(viewDrag.center.x)
        
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
