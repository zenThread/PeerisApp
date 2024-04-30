//
//  commentTableViewController.swift
//  FirebasePhotosDemo
//
//  Created by Isaiah Childs on 5/31/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper


class commentTableViewController: UITableViewController,UISearchResultsUpdating,UISearchBarDelegate, UISearchControllerDelegate {
    
    @IBOutlet var back: UIBarButtonItem!
    @IBOutlet var userTV: UITableView!
    let searchController = UISearchController(searchResultsController:nil)
    let uid = KeychainWrapper.standard.string(forKey: "uid")
    var usersArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
    var urlarray = [NSDictionary?]()
    var testArray = [NSDictionary?]()
    var myindex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "blueBG.png"), for: .default)
        self.back.backButtonBackgroundImage(for: UIControl.State.normal, barMetrics: UIBarMetrics.default)
        
        searchController.searchBar.delegate = self
        searchController.delegate = self
       // searchController.searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        searchController.searchResultsUpdater = self
   
        searchController.hidesNavigationBarDuringPresentation = false
       searchController.searchBar.barTintColor = .clear
        searchController.searchBar.setTextColor(color: .white)
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.layer.borderColor = UIColor.clear.cgColor //orange
        searchController.searchBar.setTextFieldColor(color: .clear)
        searchController.searchBar.setPlaceholderTextColor(color: UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.5))
        searchController.searchBar.setSearchImageColor(color: .white)
        
       
        searchController.searchBar.setShowsCancelButton(false, animated: false)
    
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.isTranslucent = false
        definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
            Database.database().reference().child("users").queryOrdered(byChild: "email").observe(.childAdded, with: { (snapshot) in
                
                
                let key = snapshot.key
                let snapshot = snapshot.value as? NSDictionary
                snapshot?.setValue(key, forKey: "uid")
                
                if(key == self.uid)
                {
                    print("Same as logged in user, so don't show!")
                }
                else
                {
                    self.usersArray.append(snapshot)
               
                    //insert the rows
                    self.userTV.insertRows(at: [IndexPath(row:self.usersArray.count-1,section:0)], with: UITableView.RowAnimation.automatic)
                }
                
                
            }) { (error) in
                print(error.localizedDescription)
        }
        
        
        
    }
    func didPresentSearchController(_ searchController: UISearchController) {
         searchController.searchBar.setTextFieldClearButtonColor(color: .white)
        searchController.searchBar.showsCancelButton = false
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
         searchController.searchBar.setTextFieldClearButtonColor(color: .white)
    }
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.setTextFieldClearButtonColor(color: .white)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.setTextFieldClearButtonColor(color: .white)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myindex = indexPath.row //when searching the
        if searchController.searchBar.text != ""{
            LoginViewController.GlobalVariable.inuseUID = filteredUsers[myindex]!["uid"] as! String
        }else{
        LoginViewController.GlobalVariable.inuseUID = usersArray[myindex]!["uid"] as! String
        }
        print(LoginViewController.GlobalVariable.inuseUID)
        performSegue(withIdentifier: "toProfile", sender: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredUsers.count
        }
        return self.usersArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! searchtvcell
        
        let user : NSDictionary?
        
        if searchController.isActive && searchController.searchBar.text != ""{
            
            user = filteredUsers[indexPath.row]
        }
        else
        {
            user = self.usersArray[indexPath.row]
        }
        
        cell.userlbl?.text = user?["email"] as? String
        cell.uidlbl?.text = user?["uid"] as? String
        let imageUrl = user!["userImg"] as? String
        
        
        let storage = Storage.storage()
        _ = storage.reference()
        let ref = storage.reference(forURL: imageUrl as! String)
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print("something wrong")
            } else {
                
                cell.userimg.image = UIImage(data: data!)
                cell.userimg.layer.cornerRadius = cell.userimg.frame.size.width / 2
                cell.userimg.clipsToBounds = true
                
                //
            }
        }

        
        
        return cell
    }
    
    @IBAction func dismissComm(_ sender: Any) {
       
        dismiss(animated: true, completion: nil)
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        
      filterContent(searchText: self.searchController.searchBar.text!)
        
    }
    func filterContent(searchText:String)
    {
        self.filteredUsers = self.usersArray.filter{ user in
            
            let username = user!["email"] as? String
            
            return(username?.lowercased().contains(searchText.lowercased()))!
            
        }
        
        tableView.reloadData()
    }
}
extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func getSearchBarTextField() -> UITextField? {
        return getViewElement(type: UITextField.self)
    }
    
    func setTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }
    
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
            case .prominent, .default:
                textField.backgroundColor = color
            }
        }
    }
    
    func setPlaceholderTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
    
    func setTextFieldClearButtonColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            
            let button = textField.value(forKey: "clearButton") as! UIButton
            if let image = button.imageView?.image {
                button.setImage(image.transform(withNewColor: color), for: .normal)
            }
        }
    }
    
    func setSearchImageColor(color: UIColor) {
        
        if let imageView = getSearchBarTextField()?.leftView as? UIImageView {
            imageView.image = imageView.image?.transform(withNewColor: color)
        }
    }
}
extension UIImage {
    
    func transform(withNewColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
