//
//  PostModel.swift
//  T.M.Y.S-Thennakoon-COBSCCOMP181P015
//
//  Created by MacBook Air on 11/22/19.
//  Copyright © 2019 NIBM. All rights reserved.
//

import Foundation

struct PostModel: Codable {
    
    var title : String!
    var description : String!
    var user: String!
    var image_url: String!
    var userid: String!
    
    init(title: String, description: String,user: String,userid: String,image_url:String) {
        self.title = title
        self.description = description
        self.user=user
        self.image_url=image_url
        self.userid=userid
    }
    
    
    
    
}
