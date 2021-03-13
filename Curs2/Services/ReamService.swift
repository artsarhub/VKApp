//
//  ReamService.swift
//  Curs2
//
//  Created by Артём Сарана on 31.01.2021.
//

import Foundation
import RealmSwift

class RealmServce {
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    static func save <T: Object>(items: [T],
                                 configuration: Realm.Configuration = deleteIfMigration,
                                 update: Realm.UpdatePolicy = .modified) throws {
        let realm = try Realm(configuration: configuration)
        print(configuration.fileURL ?? "")
        try realm.write {
            realm.add(items, update: update)
        }
    }
    
    static func getBy <T: Object>(type: T.Type) throws -> Results<T> {
        try Realm().objects(T.self)
    }
}
