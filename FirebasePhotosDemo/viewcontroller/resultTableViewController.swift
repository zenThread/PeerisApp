//
//  resultTableViewController.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 10/30/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase


class resultTableViewController: UITableViewController {
    var searchresult = [NSDictionary?]()
    var filtered = [NSDictionary?]()
    
    let str = "Scroll"
    var posts = [Post]()
    var pfilter = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchresult.removeAll()
        tableView.delegate = self
        tableView.dataSource = self
        
        Database.database().reference().child("posts").queryOrdered(byChild:  "caption").observe(.childAdded, with: { (snapshot) in
            DispatchQueue.main.async {
                let newPost = Post(snapshot: snapshot)
                // let snap = snapshot.value as! NSDictionary
                
                
                // self.searchresult.append(snap)
                
                
                self.posts.insert(newPost, at: 0)
                self.filtering()
                // 3 - Update the tableView
                
                
            }
            
        })
        
        
    }
    func filtering(){
        let hh = pfilter.count
        self.pfilter = self.posts.filter{sort in
            
            let match = sort.caption
            // print(match!)
            return(((match?.lowercased().contains(LoginViewController.GlobalVariable.myString.lowercased()))!))
            
            
        }
        print("number of results: \(self.pfilter.count)")
        let ff = pfilter.count
        if hh < ff {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at:[indexPath], with: .top)
        }
        
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
        return self.pfilter.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoTableViewCell
        cell.post = self.pfilter[indexPath.row]
        
        return cell
    }
    
    @IBAction func toSearch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
