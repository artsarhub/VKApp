//
//  Post.swift
//  Curs2
//
//  Created by Артём Сарана on 27.02.2021.
//

import Foundation
import SwiftyJSON

class Post {
    var date: Date
    var text: String
    var type: String
    var postId: Double
    var likesCount: Int
    var repostsCount: Int
    var commentsCount: Int
    
    init(_ json: JSON) {
        self.date = Date(timeIntervalSince1970: TimeInterval(json["date"].doubleValue))
        self.text = json["text"].stringValue
        self.type = json["type"].stringValue
        self.postId = json["post_id"].doubleValue
        self.likesCount = json["likes"]["count"].intValue
        self.repostsCount = json["reposts"]["count"].intValue
        self.commentsCount = json["comments"]["count"].intValue
    }
}
