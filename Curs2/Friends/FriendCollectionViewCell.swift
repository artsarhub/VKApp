//
//  FriendCollectionViewCell.swift
//  Curs2
//
//  Created by Артём Сарана on 09.12.2020.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var likeControl: LikeControl!
    
    var user: User?
    
}
