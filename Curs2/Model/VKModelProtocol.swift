//
//  VKModelProtocol.swift
//  Curs2
//
//  Created by Артём Сарана on 22.05.2021.
//

import Foundation
import SwiftyJSON

public protocol VKModel: Decodable {
    init(_ json: JSON)
}
