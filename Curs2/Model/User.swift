//
//  User.swift
//  Curs2
//
//  Created by Артём Сарана on 09.12.2020.
//

import UIKit
import SwiftyJSON

struct User {
//    var name: String
//    var avatar: UIImage
//    var album: [UIImage]
    
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photo100 = json["photo_100"].stringValue
    }
}
