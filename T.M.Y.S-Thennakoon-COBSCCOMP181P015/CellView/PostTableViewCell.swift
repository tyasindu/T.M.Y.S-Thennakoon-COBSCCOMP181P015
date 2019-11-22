//
//  PostTableViewCell.swift
//  T.M.Y.S-Thennakoon-COBSCCOMP181P015
//
//  Created by MacBook Air on 11/22/19.
//  Copyright © 2019 NIBM. All rights reserved.
//

import UIKit
import Nuke
import Firebase

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postContent: UITextView!
    
    var delegate: PostTableCellDelegate?
    var singlePost: PostModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let postImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(postImageClicked))
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(postImageTapGesture)
    }
    
    @objc func postImageClicked(){
        if let myDelegate = delegate, let myPost = singlePost {
            myDelegate.openPostView(post: myPost)
        }
    }

    func populateData(post: PostModel)  {
        
        postTitle.text = post.title
        postContent.text = post.description
        let userid = post.userid
        //userName.text = post.user
        
        let db = Firestore.firestore()
       
        
        db.collection("users").whereField("uid", isEqualTo: userid as Any)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let profilePhoto = document.get("imageUrl") as! String
                        
                        if let url = NSURL (string: profilePhoto ) {
                            if let data = NSData(contentsOf: url as URL) {
                                self.userImage.contentMode = UIView.ContentMode.scaleAspectFit
                                self.userImage.image = UIImage (data: data as Data)
                                
                            }
                        }
                        
                    }
                    
                }
        }
        
        let imgUrl = URL(string: post.image_url)
        
        Nuke.loadImage(with: imgUrl!, into: postImage)
        
    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}


protocol PostTableCellDelegate {
    func openPostView(post: PostModel)
}
