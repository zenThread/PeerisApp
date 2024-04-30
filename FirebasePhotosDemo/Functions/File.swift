//
//  File.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 10/19/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase

class File{
    var now = NSDate().timeIntervalSince1970
    var min : Double!
    var hr : Double!
    var day : Double!
    var mon : Double!
    var v: Double!
    var x: Double!
    var k: String!
    var secs: Double!
    
    var past = 204488
     func get(){
        self.secs = 60
        self.min = self.secs * 60//mins in hour
        self.hr = self.min * 24// hour in day
        self.day = self.hr * 30// day in month
        Database.database().reference().child("posts").child(LoginViewController.GlobalVariable.mytime).child("time").observe(.value, with: {(snapshot) in
            self.past = snapshot.value as! Int
            
        
            let uu:Int? = Int(self.past)//the past date
        let ff = Double(uu!)
            let newnow = (self.now - ff)
           //print(self.now)
            //print(self.past)
        print(newnow)
           
            let myTimeInterval = TimeInterval(self.now)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
       

            if newnow < 3600{//mins
                self.v = newnow
                self.x = 60
                self.k = "m ago"
                self.timeread()
            }else if newnow < 86400{
                self.v = newnow
                self.x = 3600
                self.k = "h ago"
                self.timeread()
            }else if newnow < 2592000{
                self.v = newnow
            self.x = 86400
            self.k = "d ago"
            self.timeread()
        }else{
                self.v = newnow
                self.x = 2592000
                self.k = "mo ago"
                self.timeread()
        }
        })
    }
    
    
    func timeread(){
        let hh = floor(self.v/self.x)
       
        let integer = NSNumber(value: hh).stringValue
        let n = "   \(integer)\(k!)   "
        print("\(integer)\(k!)   fopjwjofepofewjopf")
     LoginViewController.GlobalVariable.ts = n
    }
        
}



