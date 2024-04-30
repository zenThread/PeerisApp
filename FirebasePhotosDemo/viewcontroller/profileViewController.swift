//
//  profileViewController.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 4/19/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase

import SwiftKeychainWrapper


class profileViewController: UICollectionViewController {
   
    var myposts = [mypost]()
    var heightOfHeader = 571
    //var page : Int = 12
    @IBOutlet weak var imagecoll: UICollectionView!
   override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myposts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagecoll.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! imageCollectionViewCell
         cell.mypost = self.myposts[indexPath.row]
        
        return cell
    }
  
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
      

        
       
        loadimages()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func loadimages(){
        let uid = KeychainWrapper.standard.string(forKey: "uid")
        
        Database.database().reference().child("users").child(uid!).child("mypics").observe(.childAdded, with: {(snapshot) in
            
            //var newimages = [mypost]()
            DispatchQueue.main.async {
                
                // 2 - Parse each of the post
                let newimages = mypost(snapshot: snapshot)
                let indexPath = IndexPath(row: self.myposts.count, section: 0)
                self.myposts.insert(newimages, at: 0)
                self.imagecoll.insertItems(at: [indexPath])
                
                // 3 - Update the tableView
                self.imagecoll.reloadData()
                
            }
           
 }
 )}

    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
}
