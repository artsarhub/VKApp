//
//  Group.swift
//  Curs2
//
//  Created by Артём Сарана on 09.12.2020.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Group: Object {
    @objc dynamic var id: Int
    @objc dynamic var name: String
    @objc dynamic var photo100: String
    
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.photo100 = json["photo_100"].stringValue
    }
    
    init(id: Int, name: String, photo100: String) {
        self.id = id
        self.name = name
        self.photo100 = photo100
    }
}

//extension Group: Equatable {}
