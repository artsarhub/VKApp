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
    var sourceId: Int
    var postPhotoURL = ""
    var photoWidth = 0
    var photoHeight = 0
    
    var aspectRatio: CGFloat {
        guard photoWidth != 0 else { return 0 }
        return CGFloat(photoHeight) / CGFloat(photoWidth)
    }
    
    init(_ json: JSON) {
        self.date = Date(timeIntervalSince1970: TimeInterval(json["date"].doubleValue))
        self.text = json["text"].stringValue
        self.type = json["type"].stringValue
        self.postId = json["post_id"].doubleValue
        self.likesCount = json["likes"]["count"].intValue
        self.repostsCount = json["reposts"]["count"].intValue
        self.commentsCount = json["comments"]["count"].intValue
        self.sourceId = json["source_id"].intValue
        
        if type == "post" {
            let attachment = json["attachments"][0]
            switch attachment["type"] {
            case "photo":
                let photoSizes = attachment["photo"]["sizes"].arrayValue
                guard let photoSizeX = photoSizes.last
                else {
                    print("Error")
                    return
                }
                self.postPhotoURL = photoSizeX["url"].stringValue
                self.photoWidth = photoSizeX["width"].intValue
                self.photoHeight = photoSizeX["height"].intValue
            default:
                self.postPhotoURL = ""
            }
        }
    }
}
