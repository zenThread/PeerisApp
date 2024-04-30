 
 import UIKit
 import Firebase
 import SwiftyJSON
 
 class chat{
    var sender : String!
    var text : String!
    
    
    
    init (snapshot:DataSnapshot){
       let json = JSON(snapshot.value ?? "")
        self.text = json["txt"].stringValue
        self.sender = json["uid"].stringValue
    }
 }
