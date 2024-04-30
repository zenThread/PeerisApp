//
//  test.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 10/12/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class test {
    var xposition : Double!
    var yposition : Double!
    var captext : String!
    var z : Int!
    
    init(snapshot : DataSnapshot) {
        let json = JSON(snapshot.value ?? "")
        self.xposition = json["x"].double
        self.yposition = json["y"].double
        self.captext = json["ctext"].stringValue
        
    }
    
    
    
}
