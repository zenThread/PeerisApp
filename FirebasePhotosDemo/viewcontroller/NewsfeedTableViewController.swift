//
//  AppDelegate.swift
//  FirebasePhotosDemo
//
//  Created by YanTech on 30/12/17.
//  Copyright © 2017 YanTech. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import SwiftyJSON






class NewsfeedTableViewController: UITableViewController {
    
    
    
    var posts = [Post]()
    //var something = 0
    var selectedPost: Post!
    var myvc : UIViewController?
    var deleteID : String!
    lazy var functions = Functions.functions()
    
    
    
    // ViewDidLoad - Download all the posts
    override func viewDidLoad() {
        super.viewDidLoad()
       
        myvc = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.masksToBounds = false
        let navbar = UIImage(named: "accents")
        print((Auth.auth().currentUser?.uid)!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "accents"), for: .default)
        
        // 1 - Create the reference to tghe posts in the database
        
        let databaseRef = Database.database().reference()
        _ = databaseRef.child("posts").queryOrdered(byChild: "algo").observe(.childAdded, with: { (snapshot) in
            
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
   
    func goSingle(){
        self.performSegue(withIdentifier: "showC", sender: nil)
    }
    
    @objc func tapPic(){
        
        
        self.performSegue(withIdentifier: "showp", sender: nil)
         print("A PICTURE WAS TAPPPED")
    }
    func okk(currentUID:String,currentKey:String){
        print("start")
        
        let alertController = UIAlertController(title: "" , message: "Options for post", preferredStyle: UIAlertController.Style.actionSheet)
        
       if currentUID == (Auth.auth().currentUser?.uid)! {
        self.deleteID = currentKey
        alertController.addAction(UIAlertAction(title: "delete", style: .destructive, handler: self.deletingPost))
        
        }
        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel, handler:self.hh))
        myvc?.present(alertController, animated: true, completion: nil)
    }
    func hh(alert:UIAlertAction){
        
    }
    func deletingPost(alert:UIAlertAction){
        Database.database().reference().child("posts").child(deleteID).removeValue()
        
    }
    
    // MARK : UITableViewDataSource
    
    // 1 - Number of section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 2 - Number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // 3 - Cell for at indexPath
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoTableViewCell
        
        cell.post = self.posts[indexPath.row]
        
        
        cell.selectionStyle = .none
        cell.delegate = self
        cell.contentView.layer.masksToBounds = false
            return cell
            
      
    }

}
extension NewsfeedTableViewController: PhotoCellDelegate{
    func pressComment(comment: String) {
        LoginViewController.GlobalVariable.myString = comment
        self.performSegue(withIdentifier: "showC", sender: nil)
    }
    func pressMore(more: String,inUse:String) {
      LoginViewController.GlobalVariable.myString = more
        //self.performSegue(withIdentifier: "groupTxt", sender: nil)
        okk(currentUID: inUse, currentKey: more)
    }
}
extension UINavigationController {
    func setBackgroundImage(_ image: UIImage) {
        navigationBar.isTranslucent = true
        navigationBar.barStyle = .blackTranslucent
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(imageView, belowSubview: navigationBar)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor)
            ])
    }
}




















