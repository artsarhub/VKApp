//
//  Group.swift
//  Curs2
//
//  Created by Артём Сарана on 09.12.2020.
//

import UIKit
import SwiftyJSON

struct Group {
//    var name: String
//    var logoImage: UIImage
    
    let id: Int
    let name: String
    let photo100: String
    
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.photo100 = json["photo_100"].stringValue
    }
}

extension Group: Equatable {}
