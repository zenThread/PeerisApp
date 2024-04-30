//
//  commSectTableViewController.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 6/1/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase

class commSectTableViewController: UITableViewController {

    var cPosts = [cPost]()
 
   
    
    
    
    // ViewDidLoad - Download all the posts
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 1 - Create the reference to tghe posts in the database
        print(LoginViewController.GlobalVariable.myString)
        let databaseRef = Database.database().reference()
        _ = databaseRef.child("posts").child(LoginViewController.GlobalVariable.myString).child("comments").observe(.childAdded, with: { (snapshot) in
            
            DispatchQueue.main.async {
                
                
                // 2 - Parse each of the post
                let newPost = cPost(snapshot: snapshot)
                
                
                self.cPosts.insert(newPost, at: 0)
                
                // 3 - Update the tableView
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .top)
            }
            
        })
        
    }
    
    
    @IBAction func stopComments(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK : UITableViewDataSource
    
    // 1 - Number of section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 2 - Number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Config the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! commSectTableViewCell
        cell.cPost = self.cPosts[indexPath.row]
        
        
        
        
        return cell
        
    }
   
}
