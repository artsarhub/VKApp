//
//  PostDisplayItemsFactory.swift
//  Curs2
//
//  Created by Артём on 20.06.2021.
//

import Foundation

class PostHeaderDisplayItemsFactory {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd.MM.yyyy"
        return dateFormatter
    }()
    
    static func make(for post: Post) -> PostHeaderDisplayItem {
        var name = "Unnamed"
        var avatarURL: URL? = URL(string: "https://thumbs.dreamstime.com/b/damaged-file-line-icon-outline-vector-sign-linear-style-pictogram-isolated-white-corrupted-document-symbol-logo-illustration-108045828.jpg")
        var dateString: String = "Undated"
        
        if post.sourceId < 0 {
            guard
                let group = try? RealmService.shared?.getBy(type: Group.self).filter("id == %@", -post.sourceId).first,
                let unwrappedAvatarURL = URL(string: group.photo100)
            else { return PostHeaderDisplayItem(name: name, avatarUrl: avatarURL, dateString: dateString) }
            name = group.name
            avatarURL = unwrappedAvatarURL
        } else {
            guard
                let user = try? RealmService.shared?.getBy(type: User.self).filter("id == %@", post.sourceId).first,
                let unwrappedAvatarURL = URL(string: user.photo100)
            else { return PostHeaderDisplayItem(name: name, avatarUrl: avatarURL, dateString: dateString) }
            name = "\(user.firstName) \(user.lastName)"
            avatarURL = unwrappedAvatarURL
        }
        
        dateString = Self.dateFormatter.string(from: post.date)
        
        return PostHeaderDisplayItem(name: name, avatarUrl: avatarURL, dateString: dateString)
    }
}
