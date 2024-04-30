//
//  AppDelegate.swift
//  FirebasePhotosDemo
//
//  Created by YanTech on 30/12/17.
//  Copyright © 2017 YanTech. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    
    @IBOutlet weak var textDescription: UITextView!
    // Variables
    var textViewPlaceholderText = "Title"
    var imagePicker : UIImagePickerController!
    var takenImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionTextView.text = textViewPlaceholderText
      //  captionTextView.textColor = .black
        captionTextView.delegate = self
        
        // Create an imagePicker
      
        
    }
//    func getImage(){
//        imagePicker = UIImagePickerController()
//        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
//
//        // Set the source type for the imagePicker
//        //        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//        //            imagePicker.sourceType = .camera
//        //            imagePicker.cameraCaptureMode = .photo
//        //            //imagePicker.cameraCaptureMode = .video
//        //        } else {
//        //            imagePicker.sourceType = .photoLibrary
//        //            imagePicker.sourceType = .savedPhotosAlbum
//        //        }
//        imagePicker.sourceType = .photoLibrary
//        self.present(imagePicker, animated: true)
//    }
    
    // Share button
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        // create our image
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        self.takenImage = image
        
        self.postImageView.image = self.takenImage
        
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func shareDidTap() {
        
        if captionTextView.text != "" && captionTextView.text != textViewPlaceholderText && takenImage != nil {
            let newPost = Post(image: takenImage, caption: captionTextView.text, desc: textDescription.text)
            newPost.save()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func getimg(_ sender: Any){
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // Set the source type for the imagePicker
        //        if UIImagePickerController.isSourceTypeAvailable(.camera) {
        //            imagePicker.sourceType = .camera
        //            imagePicker.cameraCaptureMode = .photo
        //            //imagePicker.cameraCaptureMode = .video
        //        } else {
        //            imagePicker.sourceType = .photoLibrary
        //            imagePicker.sourceType = .savedPhotosAlbum
        //        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    // Cancel button
    @IBAction func cancelDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension NewPostViewController : UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceholderText {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = textViewPlaceholderText
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}


// Extension for UIImagePickerControllerDelegate & UINavigationControllerDelegate
//extension NewPostViewController : UIImagePickerControllerDelegate {
//
//     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        // create our image
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        self.takenImage = image
//
//        self.postImageView.image = self.takenImage
//
//
//        dismiss(animated: true, completion: nil)
//    }
//
//     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//}
@IBDesignable
open class GVeditor: UIView {
    @IBInspectable
    public var startColor: UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0) {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            setNeedsDisplay()
        }
    }
    @IBInspectable
    public var endColor: UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0) {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            setNeedsDisplay()
        }
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x:0.5,y:0)
        gradientLayer.endPoint = CGPoint(x:0.5,y:0.75)
        gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
        return gradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 100)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        
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
