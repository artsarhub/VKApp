//
//  Group.swift
//  Curs2
//
//  Created by Артём Сарана on 09.12.2020.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Group: Object, VKModel {
    @objc dynamic var id: Int = -1
    @objc dynamic var name: String = ""
    @objc dynamic var photo100: String = ""
    
    required convenience init(_ json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.photo100 = json["photo_100"].stringValue
    }
    
    convenience init(id: Int, name: String, photo100: String) {
        self.init()
        self.id = id
        self.name = name
        self.photo100 = photo100
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
}

//extension Group: Equatable {}
