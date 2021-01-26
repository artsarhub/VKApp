//
//  FriendCell.swift
//  Curs2
//
//  Created by Артём Сарана on 08.12.2020.
//

import UIKit

class FriendCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarView: Avatar!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.avatarView.imageView.image = nil
    }
    
    func configure(with user: User) {
        self.nameLabel.text = "\(user.firstName) \(user.lastName)"
        let url = URL(string: user.photo100)
        self.avatarView.imageView.kf.setImage(with: url)
    }

}
