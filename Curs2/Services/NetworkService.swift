//
//  NetworkService.swift
//  Curs2
//
//  Created by Артём Сарана on 16.01.2021.
//

import Foundation
import Alamofire

class NetworkService {
    private static let baseUrl = "https://api.vk.com"
    
    static func loadGroups() {
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "v": "5.126",
            "extended": 1,
        ]
        
        AF.request(self.baseUrl + path,
                   method: .get,
                   parameters: params)
            .responseJSON { response in
                guard let json = response.value else { return }
                
                print("GROUPS:", json)
            }
    }
    
    static func loadFriends() {
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "v": "5.126",
            "fields": "nickname"
        ]
        
        AF.request(self.baseUrl + path,
                   method: .get,
                   parameters: params)
            .responseJSON { response in
                guard let json = response.value else { return }
                
                print("FRIENDS:", json)
            }
    }
    
    static func loadPhotos() {
        let path = "/method/photos.get"
        
        let params: Parameters = [
            "access_token": Session.shared.token,
            "v": "5.126",
            "extended": 1,
            "album_id": "profile"
        ]
        
        AF.request(self.baseUrl + path,
                   method: .get,
                   parameters: params)
            .responseJSON { response in
                guard let json = response.value else { return }
                
                print("PHOTOS:", json)
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
}
