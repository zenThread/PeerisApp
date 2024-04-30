//
//  mypost.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 5/3/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class mypost {
    
    // Variables
    
    var imageDownloadURL : String!
    var key:String!
    private var image : UIImage!
    
    // Iniotialization of the variables
    init(image : UIImage) {
        
        self.image = image
    }
    
    // Snapshot the bdata
    init(snapshot : DataSnapshot) {
        let json = JSON(snapshot.value ?? "")
        self.key = json["key"].stringValue
        self.imageDownloadURL = json["url"].stringValue
       
}
}
