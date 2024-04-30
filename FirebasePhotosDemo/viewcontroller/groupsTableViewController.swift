//
//  groupsTableViewController.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 7/11/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class groupsTableViewController: UITableViewController {
    var posts = [Post]()
    //var something = 0
    var selectedPost: Post!
    var rndGET : String!
    
    
    // ViewDidLoad - Download all the posts
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "accents"), for: .default)
        // 1 - Create the reference to tghe posts in the database
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("groups").observe(.childAdded, with: {(snaps) in
            let json = JSON(snaps.value ?? "")
            let res = json["postId"].stringValue
            print(res)
            self.getGroups(group: res)
            
            
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getRand(){
        Database.database().reference().child("posts").observe(.value, with:{(snapshot) in
            let value = Int(snapshot.childrenCount)
            let rand = Int(arc4random_uniform(UInt32(value)))
            let vv = snapshot.children.allObjects as! [DataSnapshot]
            self.rndGET = vv[rand].key
            print(vv[rand].key)
            
        })
    }
    func getGroups(group:String){
        
        let databaseRef = Database.database().reference()
        _ = databaseRef.child("posts").child(group).observe(.value, with: { (snapshot) in
            
            
            DispatchQueue.main.async {
                
                
                
                // 2 - Parse each of the post
                let newPost = Post(snapshot: snapshot)
                
                
                
                self.posts.insert(newPost, at: 0)
                
                // 3 - Update the tableView
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .top)
            }
            
        })
        
        
    }
    @IBAction func rand(_ sender: Any) {
        getRand()
        
       
    }
    @IBAction func goMsg(_ sender: Any) {
        self.performSegue(withIdentifier: "toMsg", sender: nil)

    }
    @objc func tapcom() {
        self.performSegue(withIdentifier: "comments", sender: nil)
    }

  
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Config the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! groupsTableViewCell
         //delete array for tests
    
        cell.tests.removeAll()
        cell.testcoll.reloadData()
        
        cell.post = self.posts[indexPath.row]
        
        cell.selectionStyle = .none
       
       cell.delegate = self
        
        
        
        
        
        
        return cell
        
    }
    func hiworld(){
        print("please say something")
        print(LoginViewController.GlobalVariable.myString)
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

}
extension groupsTableViewController: GroupCellDelegate{
    
    
    func pressEdit(edit: String) {
        
        LoginViewController.GlobalVariable.myString = edit
       
        //hiworld()
        self.performSegue(withIdentifier: "edit", sender: nil)
    }
}
