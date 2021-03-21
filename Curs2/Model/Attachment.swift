//
//  Attachment.swift
//  Curs2
//
//  Created by Артём Сарана on 13.03.2021.
//

import Foundation
import SwiftyJSON

class Attachment {
    var type: String
    
    init(_ json: JSON) {
        self.type = json["type"].stringValue
    }
}
