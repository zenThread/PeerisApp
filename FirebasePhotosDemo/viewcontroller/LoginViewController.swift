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

class LoginViewController: UIViewController
{

    // Login button
    @IBAction func loginAnonymouslyDidTap(_ sender: Any) {
       
                self.performSegue(withIdentifier: "ShowNewsfeed", sender: nil)
                
        
        }
    override func viewDidAppear(_ animated: Bool) {
        print(Auth.auth().currentUser?.uid)
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                if let _ = KeychainWrapper.standard.string(forKey: "uid") {
                    let ref = Database.database().reference().child("users").child(user.uid)
                    ref.observeSingleEvent(of: .value, with: { snapshot in
                        if snapshot.exists() == true{
                            self.performSegue(withIdentifier: "myFeed", sender: nil)
                        } else {
                            print("account doesnt exist")
                        }
                    })
                    
                }
            } else {
                print("User is signed out.")
            }
        }
        
    }
    func tget(){
        
    }
    struct GlobalVariable {
        static var ts = String();
        static var mytime = String();
        static var myString = String();
        static var myRef = [String]()
        static var myNum = 1
        static var inuseUID = String();
    }
    }
    
    
    
  

