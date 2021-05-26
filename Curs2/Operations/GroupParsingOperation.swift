//
//  ParsingOperation.swift
//  Curs2
//
//  Created by Артём Сарана on 22.05.2021.
//

import Foundation
import SwiftyJSON

public class GroupParsingOperation: Operation {
    let json: JSON
    private(set) var parsedGroup: Group?
    
    init(_ json: JSON) {
        self.json = json
    }
    
    public override func main() {
        if !isCancelled {
            let id = json["id"].intValue
            let name = json["name"].stringValue
            let photo100 = json["photo_100"].stringValue
            self.parsedGroup = Group(id: id, name: name, photo100: photo100)
        }
    }
}
