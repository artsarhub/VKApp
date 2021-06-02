//
//  User.swift
//  Curs2
//
//  Created by Артём Сарана on 09.12.2020.
//

import UIKit
import SwiftyJSON
import RealmSwift

class User: Object, VKModel {
    @objc dynamic var id: Int = -1
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var photo100: String = ""
    
    required convenience init(_ json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photo100 = json["photo_100"].stringValue
    }
    
    convenience init(id: Int, firstName: String, lastName: String, photo100: String) {
        self.init()
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.photo100 = photo100
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
}
