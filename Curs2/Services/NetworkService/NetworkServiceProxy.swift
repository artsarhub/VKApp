//
//  NetworkServiceProxy.swift
//  Curs2
//
//  Created by Артём on 04.07.2021.
//

import Foundation
import PromiseKit

class NetworkServiceProxy: NetworkServiceInterface {
    let networkService: NetworkServiceInterface
    
    init(networkService: NetworkServiceInterface) {
        self.networkService = networkService
    }
    
    func loadGroups() {
        print("Group loading started")
        networkService.loadGroups()
    }
    
    func loadFriends() -> Promise<[User]> {
        print("Friends loading started")
        return networkService.loadFriends()
    }
    
    func loadPhotos(for userId: Int, completion: @escaping ([Photo]) -> Void) {
        print("Photos loading started")
        networkService.loadPhotos(for: userId, completion: completion)
    }
    
    func loadNewsFeed(startTime: Date? = nil, nextFrom: String? = nil, _ completion: @escaping ([Post], NextFromAnchor) -> Void) {
        print("News feed loading started")
        networkService.loadNewsFeed(startTime: startTime, nextFrom: nextFrom, completion)
    }
}
