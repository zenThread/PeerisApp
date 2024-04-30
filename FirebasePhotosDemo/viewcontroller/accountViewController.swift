//
//  accountViewController.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 4/11/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SwiftKeychainWrapper

class accountViewController: UIViewController {
    @IBOutlet weak var emailTextfield: UITextField!
   
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameSignUp: UITextField!
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage!
    var idurl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func storeUserData(userUid: String) {
        if let imageData = self.profileImg.image!.jpegData(compressionQuality: 0.2) {
            let imgUid = NSUUID().uuidString
            let metaData = StorageMetadata()
            let ref = Storage.storage().reference().child("profile").child(imgUid)
            ref.putData(imageData, metadata: metaData) { (metadata, error) in
                
                metadata?.storageReference?.downloadURL(completion: { (url, err) in
                    if err != nil{
                        print("error :\(err!)")
                        return
                    } else {
                        self.idurl = url?.absoluteString
                        let usrdat = [
                            "email": self.usernameSignUp.text!,
                            "userImg": url?.absoluteString
                            ] as [String : Any]
                        print(usrdat)
                        Database.database().reference().child("users").child(userUid).setValue(usrdat)
                        self.performSegue(withIdentifier: "ShowNewsFeed", sender: nil)
                    }
                })
               // let downloadURL = metaData.
                
                
                
            }
        }
    }
    func gettingImage(image:UIImage,newpostkey:String){
        var usr = ["":""]
        if let imageData = image.jpegData(compressionQuality: 0.2) {
            
            // 2 - Create a new Strage Reference
            let imageStorageRef = Storage.storage().reference().child("profile")
            let newImageRef = imageStorageRef.child(newpostkey)
            
            // 3 - Save the image to the storage URL
            newImageRef.putData(imageData).observe(.success, handler: { (snapshot) in
                
                // 4 - Save the post caption & download URL
                
                snapshot.reference.downloadURL { (durl, error) -> Void in
                    if (error != nil) {
                        print("(error) THIS IS THE IMAGE DOWNLOAD URL: \(durl!.absoluteString)")
                    } else {
                        // Get the download URL for 'images/stars.jpg'
                       
                        //self.imageDownloadURL = durl!.absoluteString
                         usr = [
                            "userImg":durl?.absoluteString,
                            "email": self.usernameSignUp.text!
                            ] as! [String : String]
                         let refKey = Database.database().reference().child("users").child(newpostkey)
                        print(usr)
                        refKey.setValue(usr)
                        self.performSegue(withIdentifier: "ShowNewsFeed", sender: nil)
                        // you will get the String of Url
                    }
                }
                
            }
            
        )}
     
    }
    @IBAction func signupButtonTapped(_ sender: Any) {
        if let email = emailTextfield.text, let password = passTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error)
                in
                if error != nil{
                 print("Error when signing up")
                }
                else{
                    print((user?.user.uid)!)
                  
                    //self.storeUserData(userUid: (user?.user.uid)!)
                    KeychainWrapper.standard.set((user?.user.uid)!, forKey: "KEY_UID")//wrapper for login
                   
                     self.gettingImage(image: self.profileImg.image!, newpostkey: (user?.user.uid)!)
                   
                   // refKey.setValue("The result for the user database is: \(resUser)")
                   
                  //self.performSegue(withIdentifier: "ShowNewsFeed", sender: nil)
                }
            }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

        }
    }
    @IBAction func getPhoto(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}
extension accountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            profileImg.image = image
        } else {
            print("image not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
