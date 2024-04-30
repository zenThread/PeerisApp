 
//
//  discoverTableViewController.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 10/27/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher


class discoverTableViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UISearchControllerDelegate {
var searchController = UISearchController(searchResultsController:nil)
    var numberOfRows:Int!
    var posts = [Post]()
    var results:String!
    var startColor = UIColor.init(red: 19/255, green: 197/255, blue: 255/255, alpha: 1)
    var endColor = UIColor.init(red: 8/255, green: 147/255, blue: 255/255, alpha: 1)
    @IBOutlet var backsearch: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.isUserInteractionEnabled = true
        UIApplication.shared.statusBarStyle = .default
       
       createSearch()
        
        createcoll()
        
   
    }
    func createSearch(){
        searchController.searchBar.delegate = self
        searchController.delegate = self
        definesPresentationContext = true
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.backgroundImage = UIImage()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "accents"), for: .default)
        //navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.applySketchShadow(color: UIColor.black, alpha: 0.16, x: 0, y: 2, blur: 4, spread: 0)
      searchController.searchBar.setTextFieldColor(color: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.33))
        
//        searchController.searchBar.barTintColor = .clear
//        searchController.searchBar.setTextColor(color: UIColor.init(red: 73/255, green: 197/255, blue: 252/255, alpha: 1))
     searchController.searchBar.setPlaceholderTextColor(color: .white)
        searchController.searchBar.setSearchImageColor(color: .white)
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.white
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.33)
                
                backgroundview.layer.cornerRadius = 20;
                backgroundview.clipsToBounds = true;
                
            }
        }
        
    }
    
    

    func createcoll(){
        Database.database().reference().child("posts").observe(.childAdded, with: {(snapshot) in
            DispatchQueue.main.async {
                
                
                // 2 - Parse each of the post
                let newPost = Post(snapshot: snapshot)
                
                
                self.posts.insert(newPost, at: 0)
                print("got items")
                
                // 3 - Update the tableView
                let indexPath = IndexPath(row: 0, section: 0)
                self.collectionView?.insertItems(at: [indexPath])
                print("items are in view")
                
                
            }
        })
        print("end of GET")
        // tableView.reloadData()
    }
   
   
    @IBAction func searching(_ sender: Any) {
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(self.posts[indexPath.row].caption) //ACTIVE CHANGE 01
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        LoginViewController.GlobalVariable.myString = self.searchController.searchBar.text!
       print(searchController.searchBar.text!)
        self.performSegue(withIdentifier: "result", sender: nil)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let nsize = (collectionView.frame.size.width/2) - 5
        return CGSize(width:nsize , height:(nsize + (nsize/2)))
    }
    
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! discoverCVCell
        
        cell.posts = self.posts[indexPath.row]
        cell.img.layer.cornerRadius = 8
        
        
        cell.rating.layer.cornerRadius = cell.rating.frame.height/2
        cell.rating.clipsToBounds = true
       //cell.img.clipsToBounds = true
        //cell.label.clipsToBounds = true
        let imageDownloadURL = cell.posts.imageDownloadURL
        let resource = ImageResource(downloadURL: URL(string:imageDownloadURL!)!, cacheKey: imageDownloadURL)
        cell.img.kf.setImage(with: resource)
        
      
        cell.img.layer.masksToBounds = true
       cell.shade.layer.applySketchShadow(color: UIColor.black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
       // cell.shade.layer.masksToBounds = true
        
            //cell.img.generateOuterShadow()
        
        
        cell.label.text = "\(cell.posts.email!)"
        cell.rating.text = " \(cell.posts._likes!) likes    "
       cell.label.numberOfLines = 0
        cell.label.sizeToFit()
        
       
       cell.bv.layer.cornerRadius = cell.bv.frame.size.height/2
        cell.bv.clipsToBounds = true
        
        
        return cell
    }
    // MARK: - Table view data source
 
   

}
class searchHeader:UICollectionReusableView{
    @IBOutlet weak var backView: UIView!
    @IBOutlet var searching: UISearchBar!
    
    var startColor = UIColor.init(red: 19/255, green: 197/255, blue: 255/255, alpha: 1)
    var endColor = UIColor.init(red: 8/255, green: 147/255, blue: 255/255, alpha: 1)
   
    func create(){
        
       
        self.backView.layer.applySketchShadow(
            color: .black,
            alpha: 0.11,
            x: 0,
            y: 22,
            blur: 24,
            spread: 0)
        
        let borderView = UIView()
        borderView.frame = backView.bounds
        borderView.layer.cornerRadius = 12
        
        borderView.layer.masksToBounds = true
        backView.addSubview(borderView)
        borderView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        //backView.layer.cornerRadius = 12
        let gradient = CAGradientLayer()
        gradient.frame = self.backView.bounds
        gradient.colors = [endColor.cgColor, startColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.35)
        
        borderView.layer.addSublayer(gradient)
        
        //self.searching.delegate = discoverTableViewController.self()
        
        searching.setSearchImageColor(color: .white)
        searching.setPlaceholderTextColor(color: .white)
        
        if let textfield = searching.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 45/100)
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 45/100)
                backgroundview.layer.cornerRadius = 20;
                backgroundview.clipsToBounds = true;
                
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}
extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x : CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
extension UIBezierPath {
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero){
        
        self.init()
        
        let path = CGMutablePath()
        
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        
        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        if topRightRadius != .zero{
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
            path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
        }
        
        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        }
        
        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        }
        
        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        path.closeSubpath()
        cgPath = path
    }
}
extension UIView{
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {//(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
