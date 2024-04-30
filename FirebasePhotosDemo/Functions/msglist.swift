//
//  msglist.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 10/23/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class msglist{
    var source : String!
    var altuid : String!
    
    init(snapshot : DataSnapshot) {
        let json = JSON(snapshot.value ?? "")
        self.source = json["chat"].stringValue
        self.altuid = json["uid"].stringValue
        
    }
}
