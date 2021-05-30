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

class ThreaSafeRealmService: RealmServce {
    private let isolationQueue = DispatchQueue(label: "com.vk.realm.write.queue", qos: .default, attributes: .concurrent)
    
    func saveSafety <T: Object>(items: [T],
                                configuration: Realm.Configuration = deleteIfMigration,
                                update: Realm.UpdatePolicy = .modified) {
        isolationQueue.async(flags: .barrier) {
            do {
                let realm = try Realm(configuration: configuration)
                print(configuration.fileURL ?? "")
                try realm.write {
                    realm.add(items, update: update)
                }
            } catch {
                print("Error in Realm: \(error.localizedDescription)")
            }
        }
    }
}
