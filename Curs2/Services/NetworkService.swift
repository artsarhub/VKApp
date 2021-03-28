//
//  NetworkService.swift
//  Curs2
//
//  Created by Артём Сарана on 16.01.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkService {
    private static let baseUrl = "https://api.vk.com"
    
    func loadGroups(completion: @escaping ([Group]) -> Void) {
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
                    let groups = groupJSONs.compactMap { Group($0) }
                    completion(groups)
                    try? RealmServce.save(items: groups)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func loadFriends(completion: @escaping ([User]) -> Void) {
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "v": "5.126",
            "fields": "photo_100"
        ]
        
        AF.request(NetworkService.baseUrl + path,
                   method: .get,
                   parameters: params)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let friendsJSONList = json["response"]["items"].arrayValue
                    let friends = friendsJSONList.compactMap { User($0) }
                    completion(friends)
                    try? RealmServce.save(items: friends)
                case .failure(let error):
                    print(error)
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
                    DispatchQueue.global(qos: .utility).async {
                        let json = JSON(data)
                        let postJSONs = json["response"]["items"].arrayValue
                        let profileJSONs = json["response"]["profiles"].arrayValue
                        let groupJSONs = json["response"]["groups"].arrayValue
                        let posts = postJSONs.compactMap { Post($0) }
                        let profiles = profileJSONs.compactMap { User($0) }
                        let groups = groupJSONs.compactMap { Group($0) }
                        try? RealmServce.save(items: profiles)
                        try? RealmServce.save(items: groups)
                        DispatchQueue.main.async {
                            completion(posts)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}
