//
//  messagesTableViewController.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 10/23/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class messagesTableViewController: UITableViewController {
    var msglists = [msglist]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Messages"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "accents"), for: .default)
        tableView.delegate = self
        tableView.dataSource = self
let UID = Auth.auth().currentUser?.uid
        
         Database.database().reference().child("users").child(UID!).child("msg").observe(.childAdded, with: { (snapshot) in
            
            DispatchQueue.main.async {
                
                
                // 2 - Parse each of the post
                let newPost = msglist(snapshot: snapshot)
                
                
                self.msglists.insert(newPost, at: 0)
                
                // 3 - Update the tableView
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .top)
                //self.tableView.reloadData()
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.msglists.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        LoginViewController.GlobalVariable.myString = self.msglists[indexPath.row].source
        performSegue(withIdentifier: "toChat", sender: nil)
        
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! messagesTableViewCell
        cell.msglist = self.msglists[indexPath.row]
        //      cell.upUI()

        // Configure the cell...

        return cell
    }
    
    @IBAction func addnewmess(_ sender: Any) {
        
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
