//
//  Session.swift
//  Curs2
//
//  Created by Артём Сарана on 12.01.2021.
//

import Foundation

class Session {
    public static let shared = Session()
    
    var token: String = ""
    var userId: Int = -1
    
    private init () {}
}
