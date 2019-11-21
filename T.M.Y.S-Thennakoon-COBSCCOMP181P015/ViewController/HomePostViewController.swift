//
//  HomePostViewController.swift
//  T.M.Y.S-Thennakoon-COBSCCOMP181P015
//
//  Created by MacBook Air on 11/22/19.
//  Copyright © 2019 NIBM. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication


class HomePostViewController: UIViewController {
    var postsList : [PostModel] = []
    var window: UIWindow?
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        tableview.dataSource = self
        tableview.delegate = self
         getStudentData()
        
    }
    
    func getStudentData(){
        let db = Firestore.firestore()
        
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let title = document.get("title") as! String
                    let description = document.get("desc") as! String
                    let user = document.get("username") as! String
                    let image_url = document.get("imageUrl") as! String
                    
                    let post = PostModel(
                        title: title,
                        description: description,
                        user: user ,
                        image_url: image_url
                    )
                    
                    self.postsList.append(post)
                    
                }
                print("*********")
                print(self.postsList)
                self.tableview.reloadData()
            }
        }
    }
    
}

extension HomePostViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return postsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! PostTableViewCell
        
        cell.selectionStyle = .none
        
        cell.populateData(post: postsList[indexPath.row])
        
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    //        performSegue(withIdentifier: "friendDetail", sender: postsList[indexPath.row])
    //    }
    //
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "friendDetail" {
    //            if let viewController = segue.destination as? postsViewController{
    //
    //                viewController.posts = sender as? AddPostModel
    //            }
    //        }
    //    }
}
