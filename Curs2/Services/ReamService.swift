//
//  ReamService.swift
//  Curs2
//
//  Created by Артём Сарана on 31.01.2021.
//

import Foundation
import RealmSwift

class RealmService {
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    private static let isolationQueue = DispatchQueue(label: "com.realm.queue", qos: .default)
    
    static func save <T: Object>(items: [T],
                                 configuration: Realm.Configuration = deleteIfMigration,
                                 update: Realm.UpdatePolicy = .modified) {
        isolationQueue.async {
            do {
                let realm = try Realm(configuration: configuration)
                //            print(configuration.fileURL ?? "")
                try realm.write {
                    realm.add(items, update: update)
                }
            } catch {
                print(error)
            }
        }
    }
    
    static func delete <T: Object>(_ object: Results<T>,
                                   configuration: Realm.Configuration = deleteIfMigration,
                                   update: Realm.UpdatePolicy = .modified) {
        isolationQueue.sync {
            do {
                let reaml = try Realm(configuration: configuration)
                try reaml.write {
                    reaml.delete(object)
                }
            } catch {
                print(error)
            }
        }
    }
    
    static func getBy <T: Object>(type: T.Type,
                                  configuration: Realm.Configuration = deleteIfMigration,
                                  update: Realm.UpdatePolicy = .modified) throws -> Results<T> {
        try isolationQueue.sync {
            try Realm(configuration: configuration).objects(T.self)
        }
    }
    
    static func getObject <T: Object, KeyType>(of objectType: T.Type,
                                               primaryKey: KeyType,
                                               configuration: Realm.Configuration = deleteIfMigration,
                                               update: Realm.UpdatePolicy = .modified) throws -> T? {
        try isolationQueue.sync {
            try Realm(configuration: configuration).object(ofType: objectType, forPrimaryKey: primaryKey)
        }
    }
}
