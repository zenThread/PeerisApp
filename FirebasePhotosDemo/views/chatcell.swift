//
//  chatcell.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 10/24/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher


class chatcell: UITableViewCell {
   
    @IBOutlet var chatbubble: UIView!
    @IBOutlet var chat: UILabel!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var altImage: UIImageView!
    
    var colorS = UIColor.init(red: 88/255, green: 177/255, blue: 243/255, alpha: 1)
    var colorE = UIColor.init(red: 200/255, green: 177/255, blue: 255/255, alpha: 1)
    
    var chats : chat! {
        didSet {
            self.update()
        }
    }
    
    func update(){
        
        
        
     
       
        
        
    }
    
    
    
    
    

}
