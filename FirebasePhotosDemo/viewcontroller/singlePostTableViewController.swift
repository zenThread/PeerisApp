//
//  singlePostTableViewController.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 7/25/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class singlePostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var cposts = [cPost]()
    var startColor = UIColor.init(red: 19/255, green: 197/255, blue: 255/255, alpha: 1)
    var endColor = UIColor.init(red: 8/255, green: 147/255, blue: 255/255, alpha: 1)
    @IBOutlet var submit: UIButton!
    @IBOutlet var commtxt: UITextField!
    @IBOutlet var commtv: UITableView!
    @IBOutlet var roundInput: UIView!
    var sample : String!

    override func viewDidLoad() {
        super.viewDidLoad()
         navigationController?.navigationBar.setBackgroundImage(UIImage(named: "accents"), for: .default)
       //C8C5FF
     self.commtv.estimatedSectionHeaderHeight = 476
     self.commtv.sectionHeaderHeight = UITableView.automaticDimension
       roundInput.layer.applySketchShadow(color: UIColor.black, alpha: 0.29, x: 0, y: 2, blur: 5, spread: 0)
       self.commtxt.delegate = self
        commtxt.isUserInteractionEnabled = true
    
        
   // setupinput()
        print(LoginViewController.GlobalVariable.myString,"lflflsfkokeode")
        let databaseRef = Database.database().reference()
        _ = databaseRef.child("posts").child(LoginViewController.GlobalVariable.myString).child("comments").observe(.childAdded, with: { (snapshot) in
            
            DispatchQueue.main.async {
                
                
                // 2 - Parse each of the post
                
                let newPost = cPost(snapshot: snapshot)
               
                print(newPost)
                self.cposts.insert(newPost, at: 0)
                
                // 3 - Update the tableView
                //self.commtv.beginUpdates()
                let indexPath = IndexPath(row: 0, section: 0)
                
                
                self.commtv.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                //self.commtv.endUpdates()
               // self.commtv.scrollToRow(at: indexPath, at: .bottom, animated: true)
                
            self.commtv.reloadData()
                
            }
            
        })
     
        
     
    
    }
    
 
    func returnIsTouched(){
        if commtxt.text == ""{
            print("no comment")
        }else{
            let uid = (Auth.auth().currentUser?.uid)!
            let newdb = [
                "comment": self.commtxt.text!,
                "UID": uid
                ] as [String : Any]; Database.database().reference().child("posts").child(LoginViewController.GlobalVariable.myString).child("comments").childByAutoId().setValue(newdb)
            //self.commtv.reloadData()
            self.commtxt.text = ""
        }
    }
    @IBAction func comsend(_ sender: Any) {
        if commtxt.text == ""{
            print("no comment")
        }else{
            let uid = (Auth.auth().currentUser?.uid)!
           let newdb = [
            "comment": self.commtxt.text,
            "UID": uid
            ] as [String : Any]; Database.database().reference().child("posts").child(LoginViewController.GlobalVariable.myString).child("comments").childByAutoId().setValue(newdb)
            //self.commtv.reloadData()
            self.commtxt.text = ""
        }
    }
    func setupinput(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 476
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head = commtv.dequeueReusableCell(withIdentifier: "postcell") as! singlePostTVC
        Database.database().reference().child("posts").child(LoginViewController.GlobalVariable.myString).child("text").observe(.value, with:{(snap) in
            self.sample = snap.value as? String
            
        })
        head.decript.numberOfLines = 0
        head.decript.text = sample
        head.upUI()
        
        
        //13C5FF
        //0894FE
        return head
    }
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cposts.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        
      
           
        
           
            //cell.img.image = UIImage(named: "image1")
            //cell.proIMG.image = UIImage(named: "image1")
             
            
            
            
           
            // Configure the cell...
            
         
          
            let ccell = commtv.dequeueReusableCell(withIdentifier: "commentcell", for: indexPath) as! commSectTableViewCell
           
            //print(self.cposts[1].comment)
            ccell.cPost = self.cposts[indexPath.row]
            
            
            // ccell.commentView.text = ("dgiuywgaudiuefiufegiuefiufiu iufgeifagaifeu eg iu")
            
            //ccell.updateUI()
            return ccell
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


