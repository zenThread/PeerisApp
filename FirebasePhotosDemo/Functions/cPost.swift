import UIKit
import Firebase
import SwiftyJSON

class cPost {
    
    // Variables
    
    var uid : String!
    private var image : UIImage!
    var comment: String!
    
    
    // Iniotialization of the variables
    init(image : UIImage, comment : String) {
        
        self.image = image
        self.comment = comment
    }
    
    // Snapshot the bdata
    init(snapshot : DataSnapshot) {
        let json = JSON(snapshot.value ?? "")
        
        self.uid = json["UID"].stringValue
        self.comment = json["comment"].stringValue
        
        
        
    }
}
