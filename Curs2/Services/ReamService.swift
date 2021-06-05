//
//  ReamService.swift
//  Curs2
//
//  Created by Артём Сарана on 31.01.2021.
//

import Foundation
import RealmSwift

//class RealmService {
//    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//    
//    private static let isolationQueue = DispatchQueue(label: "com.realm.queue", qos: .default)
//    
//    static func save <T: Object>(items: [T],
//                                 configuration: Realm.Configuration = deleteIfMigration,
//                                 update: Realm.UpdatePolicy = .modified) {
//        isolationQueue.async {
//            do {
//                let realm = try Realm(configuration: configuration)
//    //            print(configuration.fileURL ?? "")
//                try realm.write {
//                    realm.add(items, update: update)
//                }
//            } catch {
//                print(error)
//            }
//        }
//    }
//    
//    static func getBy <T: Object>(type: T.Type) throws -> Results<T> {
//        try isolationQueue.sync {
//            try Realm().objects(T.self)
//        }
//    }
//    
//    static func getObject <T: Object, KeyType>(of objectType: T.Type, primaryKey: KeyType) throws -> T? {
//        try isolationQueue.sync {
//            try Realm().object(ofType: objectType, forPrimaryKey: primaryKey)
//        }
//    }
//}

class RealmService {
    private static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    private static var singleInstance: RealmService?
    private let realm: Realm
//    private let isolationQueue = DispatchQueue(label: "com.realm.queue")
    
    static var shared: RealmService? = {
        if singleInstance == nil {
            singleInstance = RealmService()
        }
        return singleInstance
    }()
    
    private init?() {
        do {
            try realm = Realm()
        } catch {
            print(error)
            return nil
        }
    }
    
    func save <T: Object>(items: [T],
                          configuration: Realm.Configuration = deleteIfMigration,
                          update: Realm.UpdatePolicy = .modified) {
//        isolationQueue.async {
            do {
                let realm = try Realm(configuration: configuration)
    //            print(configuration.fileURL ?? "")
                try realm.write {
                    realm.add(items, update: update)
                }
            } catch {
                print(error)
            }
//        }
    }
    
    func getBy <T: Object>(type: T.Type) throws -> Results<T> {
//        try isolationQueue.sync {
            try Realm().objects(T.self)
//        }
    }
    
    func getObject <T: Object, KeyType>(of objectType: T.Type, primaryKey: KeyType) throws -> T? {
//        try isolationQueue.sync {
            try Realm().object(ofType: objectType, forPrimaryKey: primaryKey)
//        }
    }
}
