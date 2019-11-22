//
//  PostViewController.swift
//  T.M.Y.S-Thennakoon-COBSCCOMP181P015
//
//  Created by MacBook Air on 11/22/19.
//  Copyright © 2019 NIBM. All rights reserved.
//

import UIKit
import Nuke


class PostViewController: UIViewController {
    
    var post: PostModel?
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postContent: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTitle.text = post?.title
        postContent.text = post?.description
        let imgUrl = URL(string: post!.image_url)
        
        Nuke.loadImage(with: imgUrl!, into: postImage)

    }
    
    
    
}

