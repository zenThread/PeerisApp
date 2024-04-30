//
//  testTableViewController.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 10/1/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
class testTableViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
  
    @IBOutlet var icoll: testCollView!
    var myposts = [mypost]()

    override func viewDidLoad() {
        super.viewDidLoad()
       self.icoll.delegate = self
        self.icoll.dataSource = self
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let width = collectionView!.bounds.width
        layout.headerReferenceSize = CGSize(width: width, height: 575)
        LoginViewController.GlobalVariable.inuseUID = Auth.auth().currentUser!.uid
        self.collectionView?.register(UINib(nibName: "hview", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
                // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
      loadimages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myposts.count
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let sizeOfCollView = UIScreen.main.bounds.width - 4
        let nheight = (sizeOfCollView/3) * 1.22
        return CGSize(width: sizeOfCollView/3, height: nheight)
    }
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! testCollectionViewCell
        cell.mypost = self.myposts[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
        } catch let err {
            print(err)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newvc = storyboard.instantiateViewController(withIdentifier: "initialView")
        self.present(newvc, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! headerView        
        header.upUI()
        header.delegate = self
        return header
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.width,height:667)
//    }
    
    func loadimages(){
        let uid = KeychainWrapper.standard.string(forKey: "uid")
        
        Database.database().reference().child("users").child(uid!).child("mypics").observe(.childAdded, with: {(snapshot) in
            
            //var newimages = [mypost]()
            DispatchQueue.main.async {
                
                // 2 - Parse each of the post
                let newimages = mypost(snapshot: snapshot)
                let indexPath = IndexPath(row: self.myposts.count, section: 0)
                self.myposts.insert(newimages, at: 0)
                //self.icoll.insertItems(at: [indexPath])
                
                // 3 - Update the tableView
                self.icoll.reloadData()
                
            }
            
        }
        )}
    
}
extension testTableViewController: mypicsdelegate,headerDelegate{
    func tapmypic(mykey:String){
        print(LoginViewController.GlobalVariable.myString)
        self.performSegue(withIdentifier: "details", sender: nil)
      
    }
    func toPeers(peer: String) {
        LoginViewController.GlobalVariable.inuseUID = peer
        performSegue(withIdentifier: "peers", sender: nil)
    }
}
