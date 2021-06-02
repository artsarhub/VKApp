//
//  NetworkService.swift
//  Curs2
//
//  Created by Артём Сарана on 16.01.2021.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

class NetworkService {
//    private let realmWriteQueue = DispatchQueue(label: "com.vk.realm.write", qos: .default)
    private let threadSafeRealmService = ThreaSafeRealmService()
    
    private static let baseUrl = "https://api.vk.com"
    
    private let operationQueue: OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 1
        q.name = "ru.parsing.operations"
        q.qualityOfService = .userInitiated
        return q
    }()
    
    // TODO - Сохранение в Realm
    func loadGroups(/*completion: @escaping ([Group]) -> Void*/) {
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "v": "5.126",
            "extended": 1,
        ]
        
        AF.request(NetworkService.baseUrl + path,
                   method: .get,
                   parameters: params)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let groupJSONs = json["response"]["items"].arrayValue
                    let groupParsingOperations = groupJSONs.compactMap { GroupParsingOperation($0) }
                    groupParsingOperations.forEach { groupParsingOperation in
                        groupParsingOperation.completionBlock = {
                            if let group = groupParsingOperation.parsedGroup {
                                self.threadSafeRealmService.saveSafety(items: [group])
                            }
                        }
                    }
                    self.operationQueue.addOperations(groupParsingOperations, waitUntilFinished: false)
//                    let groups = groupJSONs.compactMap { Group($0) }
//                    completion(groups)
//                    try? RealmServce.save(items: groups)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func loadFriends() -> Promise<[User]> {
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "v": "5.126",
            "fields": "photo_100"
        ]
        
        return Promise.init { resolver in
            AF.request(NetworkService.baseUrl + path,
                       method: .get,
                       parameters: params)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        let json = JSON(data)
                        let friendsJSONList = json["response"]["items"].arrayValue
                        let friends = friendsJSONList.compactMap { User($0) }
//                        completion(friends)
                        try? RealmServce.save(items: friends)
                        resolver.fulfill(friends)
                    case .failure(let error):
                        resolver.reject(error)
                    }
                }
        }
    }
    
    func loadPhotos(for userId: Int, completion: @escaping ([Photo]) -> Void) {
        let path = "/method/photos.getAll"
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "v": "5.126",
            "extended": 1,
            "owner_id": "\(userId)"
        ]
        
        AF.request(NetworkService.baseUrl + path,
                   method: .get,
                   parameters: params)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let photoJSONs = json["response"]["items"].arrayValue
                    let photos = photoJSONs.compactMap { Photo($0) }
                    completion(photos)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    static func searchGroups(by query: String) {
        let path = "/method/groups.search"
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "v": "5.126",
            "q": query,
            "type": "group"
        ]
        
        AF.request(self.baseUrl + path,
                   method: .get,
                   parameters: params)
            .responseJSON { response in
                guard let json = response.value else { return }
                
                print("FOUND GROUPS:", json)
            }
    }
    
    func loadNewsFeed(_ completion: @escaping ([Post]) -> Void) {
        let path = "/method/newsfeed.get"
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "v": "5.126",
            "filters": "post"
        ]
        
        AF.request(NetworkService.baseUrl + path,
                   method: .get,
                   parameters: params)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let parsingGroup = DispatchGroup()
                    
                    var posts: [Post] = []
                    var profiles: [User] = []
                    var groups: [Group] = []
                    
                    DispatchQueue.global().async(group: parsingGroup, qos: .userInitiated) {
                        let postJSONs = JSON(data)["response"]["items"].arrayValue
                        posts = postJSONs.compactMap { Post($0) }
                    }
                    
                    DispatchQueue.global().async(group: parsingGroup, qos: .userInitiated) {
                        let profileJSONs = JSON(data)["response"]["profiles"].arrayValue
                        profiles = profileJSONs.compactMap { User($0) }
                        try? RealmServce.save(items: profiles)
                    }
                    
                    DispatchQueue.global().async(group: parsingGroup, qos: .userInitiated) {
                        let groupJSONs = JSON(data)["response"]["groups"].arrayValue
                        groups = groupJSONs.compactMap { Group($0) }
                        try? RealmServce.save(items: groups)
                    }
                    
                    parsingGroup.notify(queue: DispatchQueue.main) {
                        completion(posts)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}
