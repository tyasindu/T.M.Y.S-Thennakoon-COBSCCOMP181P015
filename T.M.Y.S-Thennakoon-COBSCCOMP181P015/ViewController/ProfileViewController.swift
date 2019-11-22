//
//  ProfileViewController.swift
//  T.M.Y.S-Thennakoon-COBSCCOMP181P015
//
//  Created by MacBook Air on 11/22/19.
//  Copyright © 2019 NIBM. All rights reserved.
//

import UIKit
import Firebase


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var email: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
    }
    
    
    @IBAction func logoutUser(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            transitionToLogin()
        } catch {
            
        }
    }
    
    func transitionToLogin() {
        
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController) as? LoginViewController
        
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    
    func fetchData() {
        let db = Firestore.firestore()
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            db.collection("users").whereField("uid", isEqualTo: uid)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            //print("\(document.documentID) => \(document.data())")
                            let firstName = document.get("firstname")
                            let lastName = document.get("lastname")
                            let email = document.get("email")
                            let profilePhoto = document.get("imageUrl")
                            
                            self.firstName.text = firstName as? String
                            self.lastName.text = lastName as? String
                            self.email.text = email as? String
                            
                            if let url = NSURL (string: profilePhoto as! String) {
                                if let data = NSData(contentsOf: url as URL) {
                                    self.profileImage.contentMode = UIView.ContentMode.scaleAspectFit
                                    self.profileImage.image = UIImage (data: data as Data)
                                    
                                }
                            }
                        }
                        
                    }
            }
        }
    }
    
    
    
    
}
